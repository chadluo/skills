# Claude Code

## Launch

- `herdr agent start <name> --kind claude --pane <shell-pane-id> -- <flags>`
- Verify which `claude` binary runs. Flags: `--effort`, permission mode (`claude --help`).
- Omit `--model`; Claude Code then uses its configured model. Reason: model names go stale (see the Codex note). To get an exact model version, start Claude Code first, open `/model`, and pick from that list. Read the model in use from the status line.

## Roles

- Writer: the user's normal permission mode. Use `bypassPermissions` or `--dangerously-skip-permissions` only on user request.
- Reviewer: the user's normal mode + the no-edit rule. `plan` mode blocks targeted checks and does not guarantee a read-only filesystem; use it only for a review with no execution.

## Status

- Prompts and questions usually show as Herdr `blocked`; detection can miss or show `unknown`. Inspect the UI. Leave approval dialogs for the user.

## Handoff wording

Claude 5 models follow words literally and over-react to emphasis. Write every Claude handoff this way:

- Imperatives: `Implement…`, `Review…`, `Fix…`. "Can you suggest…" gets suggestions only.
- Plain rules with a reason: `Use X when Y, because Z.` Emphasis (`CRITICAL`, `MUST`, caps) causes over-application.
- Reviewer, diff < ~400 changed lines: `Review in one pass. Use no sub-agents.` Claude spawns sub-agents readily.
- Opus 5 writer: omit generic "verify your work" lines; it self-verifies, and extra lines cause over-verification. Name the required checks only.
- Long loops: `Context may compact. Keep state in <run>/; continue from it. Do not stop early for token limits.`
