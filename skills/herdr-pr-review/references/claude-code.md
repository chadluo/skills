# Claude Code

## Launch

- CLI: `herdr agent start <name> --kind claude --pane <shell-pane-id> -- <flags>`
- App: `hc run --bg --name <name> --cwd <path> <claude-path> --allowedTools "Bash(hc send:*)" <flags> -- "<first task>"`. Variadic flags consume tasks.
- Verify which `claude` binary runs. Flags: `--effort <level>`, `--permission-mode <mode>` (`claude --help`).
- Pass `--add-dir <run>`; without it, each reply-file write asks for approval.
- Omit `--model` to use the configured model. To pin a model, pass an alias such as `opus` or `fable`, because a full model ID from memory can fail mid-run. For an exact model, pick it from the `/model` list after start. Read the model in use from the status line.

## Roles

- Writer: the user's normal permission mode. Use `bypassPermissions` only on user request.
- Reviewer: the user's normal mode + the no-edit rule. Do not use `plan` mode; it blocks the reply file and targeted checks.

## Handoff wording

Write every Claude handoff this way:

- Imperatives: `Implement…`, `Review…`, `Fix…`. Do not phrase work as a question ("Can you suggest…"), because Claude then only suggests.
- Plain rules with a reason: `Use X when Y, because Z.` No emphasis (`CRITICAL`, `MUST`, caps), because it causes overuse of the rule.
- Give each prohibition its scope and reason (`Ask the coordinator before you delete files, because…`), not a bare `never`. Claude treats `never` as absolute, and broad prohibitions make it hold back routine work.
- Put verbatim inputs (issue text, user decisions) in tags such as `<issue>` and `<decisions>`, so Claude keeps them apart from instructions.
- Omit "think carefully", "answer directly", and generic "verify your work" lines; name only the required checks. Thinking follows the effort level, not prompt text, so set `--effort` instead.
- Omit token budgets from the handoff, because a visible budget increases spend.
- Do not tell the writer that it owns the codebase or its design, because that wording causes unrequested refactors, tests, and docs, and a scope rule does not cancel it.
- Reviewer, diff of less than about 400 changed lines: `Review in one pass. Use no sub-agents.`
- Long loops: `Context may compact. Keep state in <run>/; continue from it. Do not stop early for token limits.`
- Writer, to prevent early stops: `Do not end the turn with a plan, an offer to continue, or a list of non-blocking decisions. Do the next step. Stop only for a real blocker or a decision that needs the coordinator.`

## Model notes

Opus 5.5:

- Always thinks. Default effort is `medium`, which matches Opus 5 at `high`. Use `xhigh` or `max` only for work with a measured quality gain.
- Catches more bugs with fewer false alarms than Opus 5. A good default reviewer.
- Can end a turn with a summary that announces the next step, but makes no tool call. Handle it with the early-stop rule in Agent status.

Fable 5.2:

- Default effort is `high`, and at `high` and above it thinks before almost every reply. Use `medium` for small writer tasks.
- At `low` and `medium` it stops early more often: it lists the remaining work and stops, offers to continue, or stops at an ordinary error. Always add the early-stop line to writer handoffs at these levels.
- In Claude Code it starts sub-agents readily, and at `xhigh` and `max` it uses them to review its own work. Sub-agents add cost, so keep the one-pass line for small reviews.
- Its PR summaries can leave out small changes. The reviewer reads the full diff and does not trust the summary.
