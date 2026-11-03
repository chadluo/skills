# Claude Code

## Launch

- CLI: `herdr agent start <name> --kind claude --pane <shell-pane-id> -- <flags>`
- App: `hc run --bg --name <name> --cwd <path> <claude-path> <flags> "<first task>"`.
- Verify which `claude` binary runs. Flags: `--effort <level>`, `--permission-mode <mode>` (`claude --help`).
- Omit `--model`; Claude Code then uses its configured model. To pin a model, pass an alias such as `opus` or `sonnet`, not a full model ID, because a full ID from memory can fail mid-run. For an exact model version, start Claude Code first, open `/model`, and pick from that list. Read the model in use from the status line.

## Roles

- Writer: the user's normal permission mode. Use `bypassPermissions` or `--dangerously-skip-permissions` only on user request.
- Reviewer: the user's normal mode + the no-edit rule. Use `plan` mode only for a review with no execution; it blocks targeted checks and does not guarantee a read-only filesystem.

## Handoff wording

Write every Claude handoff this way:

- Imperatives: `Implement…`, `Review…`, `Fix…`. Do not phrase work as a question ("Can you suggest…"), because Claude then only suggests.
- Plain rules with a reason: `Use X when Y, because Z.` No emphasis (`CRITICAL`, `MUST`, caps), because it causes overuse of the rule.
- Put verbatim inputs (issue text, user decisions) in tags such as `<issue>` and `<decisions>`, so Claude keeps them apart from instructions.
- Omit "think carefully" and generic "verify your work" lines; name only the required checks. Opus 5 and later models think and verify by default, so these lines add time and extra checks.
- Reviewer, diff of less than about 400 changed lines: `Review in one pass. Use no sub-agents.`
- Long loops: `Context may compact. Keep state in <run>/; continue from it. Do not stop early for token limits.`
