# Claude Code

## Launch

- CLI: `herdr agent start <name> --kind claude --pane <shell-pane-id> -- <flags>`
- App: `hc run --bg --name <name> --cwd <path> <claude-path> --allowedTools "Bash(hc send:*)" <flags> -- "<first task>"`. Variadic flags consume tasks.
- Verify which `claude` binary runs. Flags: `--effort <level>`, `--permission-mode <mode>` (`claude --help`).
- Pass `--add-dir <run>`; without it, each reply-file write asks for approval.
- Omit `--model` to use the configured model. To pin a model, pass an alias such as `opus` or `sonnet`, because a full model ID from memory can fail mid-run. For an exact model, pick it from the `/model` list after start. Read the model in use from the status line.

## Roles

- Writer: the user's normal permission mode. Use `bypassPermissions` only on user request.
- Reviewer: the user's normal mode + the no-edit rule. Do not use `plan` mode; it blocks the reply file and targeted checks.

## Handoff wording

Write every Claude handoff this way:

- Imperatives: `Implement…`, `Review…`, `Fix…`. Do not phrase work as a question ("Can you suggest…"), because Claude then only suggests.
- Plain rules with a reason: `Use X when Y, because Z.` No emphasis (`CRITICAL`, `MUST`, caps), because it causes overuse of the rule.
- Put verbatim inputs (issue text, user decisions) in tags such as `<issue>` and `<decisions>`, so Claude keeps them apart from instructions.
- Omit "think carefully" and generic "verify your work" lines; name only the required checks. Opus 5 verifies its own work, and Opus 5.5 always thinks, so on these models the lines add time and extra checks.
- Reviewer, diff of less than about 400 changed lines: `Review in one pass. Use no sub-agents.`
- Long loops: `Context may compact. Keep state in <run>/; continue from it. Do not stop early for token limits.`
