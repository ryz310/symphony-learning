#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
symphony_dir="${SYMPHONY_DIR:-/tmp/openai-symphony}"
workflow_file="${1:-$repo_root/WORKFLOW.md}"

if [ ! -f "$workflow_file" ]; then
  echo "Workflow file not found: $workflow_file" >&2
  exit 1
fi

if [ -z "${LINEAR_API_KEY:-}" ]; then
  echo "LINEAR_API_KEY is not set." >&2
  echo "Example: export LINEAR_API_KEY=lin_api_xxx" >&2
  exit 1
fi

if rg -q 'project_slug:\s*"replace-with-your-linear-project-slug"' "$workflow_file"; then
  echo "WORKFLOW.md still has placeholder project_slug." >&2
  echo "Update tracker.project_slug before starting Symphony." >&2
  exit 1
fi

"$script_dir/setup_symphony_runtime.sh"

cd "$symphony_dir/elixir"
WORKFLOW_FILE="$workflow_file" \
  mise exec -- mix run --no-halt -e '
    :ok = SymphonyElixir.Workflow.set_workflow_file_path(System.fetch_env!("WORKFLOW_FILE"))
    {:ok, _} = Application.ensure_all_started(:symphony_elixir)
    Process.sleep(:infinity)
  '
