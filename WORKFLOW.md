---
tracker:
  kind: linear
  api_key: $LINEAR_API_KEY
  project_slug: "symphony-learning-948c6fe756ec"
  active_states:
    - Todo
    - In Progress
    - Human Review
    - Rework
    - Merging
  terminal_states:
    - Done
    - Closed
    - Cancelled
    - Canceled
    - Duplicate
polling:
  interval_ms: 5000
workspace:
  root: $SYMPHONY_WORKSPACE_ROOT
hooks:
  after_create: |
    git clone --depth 1 https://github.com/ryz310/symphony-learning .
    "$HOME/.rbenv/shims/bundle" install
    "$HOME/.rbenv/shims/bundle" exec rails db:prepare
agent:
  max_concurrent_agents: 5
  max_turns: 20
codex:
  command: codex app-server
  turn_sandbox_policy:
    type: workspaceWrite
    writable_roots:
      - /var/run/docker.sock
---

You are working on a Linear issue `{{ issue.identifier }}`.

Issue context:

- Identifier: {{ issue.identifier }}
- Title: {{ issue.title }}
- Status: {{ issue.state }}
- URL: {{ issue.url }}

Description:
{% if issue.description %}
{{ issue.description }}
{% else %}
No description provided.
{% endif %}

Execution policy:

1. This is an unattended run. Do not ask humans for follow-up actions.
2. Work only inside the assigned workspace.
3. Keep changes scoped to the issue and maintain a clean commit history.
4. Run validations relevant to your change before handoff.
5. In the final message, report only what was completed and what was blocked.

Linear workpad requirements:

1. Before any code change, find or create a single Linear comment with header `## Codex Workpad`.
2. Reuse the same comment throughout the run. Do not create multiple progress comments.
3. Keep this comment updated at each milestone with:
   - Plan (checklist)
   - Acceptance Criteria (checklist)
   - Validation (commands and outcomes)
   - Blockers (if any)
4. Update the workpad immediately after:
   - initial investigation,
   - meaningful implementation progress,
   - each validation run,
   - final handoff.
5. If Linear comment update tooling is unavailable, report it as a blocker and stop.
