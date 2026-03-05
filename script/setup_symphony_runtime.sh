#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
symphony_dir="${SYMPHONY_DIR:-$HOME/code/symphony-runtime/openai-symphony}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required." >&2
  exit 1
fi

if ! command -v mise >/dev/null 2>&1; then
  echo "mise is required. Install with: brew install mise" >&2
  exit 1
fi

if [ ! -d "$symphony_dir/.git" ]; then
  mkdir -p "$(dirname "$symphony_dir")"
  git clone --depth 1 https://github.com/openai/symphony "$symphony_dir"
else
  # Keep runtime repo deterministic by always syncing to upstream main.
  git -C "$symphony_dir" remote set-url origin https://github.com/openai/symphony
  git -C "$symphony_dir" fetch origin main
  git -C "$symphony_dir" checkout -B main origin/main
  git -C "$symphony_dir" reset --hard origin/main
  git -C "$symphony_dir" clean -fd
fi

cd "$symphony_dir/elixir"
mise trust
mise install

# Temporary runtime workaround for CA trust on some local environments.
if ! rg -q '\{:castore,\s*"~>\s*1\.0"\}' mix.exs; then
  perl -0777 -i -pe 's/\{\:req, "~> 0\.5"\},\n      \{\:jason/\{:req, "~> 0.5"\},\n      \{:castore, "~> 1.0"\},\n      \{:jason/s' mix.exs
fi

mise exec -- mix deps.get
mise exec -- mix build

echo "Symphony runtime is ready at: $symphony_dir/elixir"
echo "Workflow file: $repo_root/WORKFLOW.md"
