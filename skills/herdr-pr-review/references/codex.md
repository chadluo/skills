# Codex CLI

## Launch

- CLI: `herdr agent start <name> --kind codex --pane <shell-pane-id> -- <flags>`
- App: `hc run --bg --name <name> --cwd <path> codex --no-daemon <flags> "<first task>"`. Always pass `--no-daemon`, because without it Codex runs its commands outside Herdr.
- Flags: `-s <sandbox>`, `-c model_reasoning_effort=<level>`, `--add-dir <path>`.
- Omit `-m`; Codex then uses the model in `~/.codex/config.toml`. Never pass a model name from memory, because the backend rejects retired names and the turn is lost. For an exact model version, start Codex first, open `/model`, and pick a name from that list. Read the model in use from the status line.
- Effort levels differ by model. Pick a level from the `/model` effort list. Map `minimal` to `low`.
- App: to change model or effort, type `/model` with `hc keys` (see Herdr mode in SKILL.md). In the effort list, press `s` to set the level for this session only; Enter saves it as the default.
- Blocked by sandbox or approvals → report the blocker. Keep sandbox and approvals on.

## Roles

- Writer: `-s workspace-write`. This sandbox can block Git metadata writes (also in a worktree with `--add-dir`), the remote, the GitHub API, and some build and test tools. Tell the writer to check these with read-only commands first and to report each failure without a workaround. Run each blocked step (build, test, commit, push, PR) yourself or in a Claude Code agent.
- Reviewer: `-s workspace-write` + the no-edit rule. Do not use `read-only`; it blocks builds and tests. Use `--add-dir` for output paths outside the repo and temp dirs.
- Use the interactive session. `codex review` is optional: only with `--base <pinned merge-base>`, after you confirm the checkout is at the pinned head. `--commit` covers one commit only.

## Status

- Root review summary shorter than its sub-agent replies → read the sub-agent replies yourself.

## Handoff wording

Add to every Codex handoff:

- `Act on this handoff without asking. Infer missing details from the repo. Ask only when an authorized action is blocked.`
- `Add no warnings or approval steps for hypothetical risk.`
- `A person may read your messages and reply files. Put normal spaces between words and numbers.`
- Writer: `Run the checks that fit this change: <list>. Widen only after a failure or an open concern.`
- Reviewer, diff of about 400 or more changed lines: `Split the review into sub-agents by subsystem.`
