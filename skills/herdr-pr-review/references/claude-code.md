# Claude Code

## Launch

- CLI: `herdr agent start <name> --kind claude --pane <shell-pane-id> -- <flags>`
- App: `hc run --bg --name <name> --cwd <path> <claude-path> <flags> "<first task>"`.
- Verify which `claude` binary runs. Flags: `--effort`, permission mode (`claude --help`).
- Omit `--model`; Claude Code then uses its configured model. Never pass a model name from memory. For an exact model version, start Claude Code first, open `/model`, and pick from that list. Read the model in use from the status line.

## Roles

- Writer: the user's normal permission mode. Use `bypassPermissions` or `--dangerously-skip-permissions` only on user request.
- Reviewer: the user's normal mode + the no-edit rule. Use `plan` mode only for a review with no execution; it blocks targeted checks and does not guarantee a read-only filesystem.

## Status

- On `blocked` or `unknown`, and when the agent does not move, inspect the UI. Leave approval dialogs for the user.

## Handoff wording

Write every Claude handoff this way:

- Imperatives: `Implement…`, `Review…`, `Fix…`. Do not phrase work as a question ("Can you suggest…").
- Plain rules with a reason: `Use X when Y, because Z.` No emphasis (`CRITICAL`, `MUST`, caps).
- Reviewer, diff < ~400 changed lines: `Review in one pass. Use no sub-agents.`
- Opus 5 writer: name the required checks only; omit generic "verify your work" lines.
- Long loops: `Context may compact. Keep state in <run>/; continue from it. Do not stop early for token limits.`
- Reviewer: add these reasons to the matching rules:
  - Scope decisions: `A summary that drops a user decision causes invalid findings.`
  - No repository changes: `The writer owns the branch; your edits change the tree under review.`
  - Merge sub-agent findings: `A dropped finding can ship as a bug.`
  - Targeted checks: `A check confirms or refutes a finding before the writer acts on it.`
