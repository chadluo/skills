# Codex CLI

## Launch

- CLI: `herdr agent start <name> --kind codex --pane <shell-pane-id> -- <flags>`
- App: `hc run --bg --name <name> --cwd <path> codex --no-daemon <flags> "<first task>"`. Always pass `--no-daemon`, because without it Codex runs its commands outside Herdr.
- Flags: `-s <sandbox>`, `-c model_reasoning_effort=<level>`, `--add-dir <path>`.
- Omit `-m` to use the model in `~/.codex/config.toml`. Never pass a model name from memory, because the backend rejects retired names and the turn is lost. For an exact model, pick it from the `/model` list after start. Read the model in use from the status line.
- Effort levels differ by model; pick one from the `/model` effort list. Map `minimal` to `low`. In that list, `s` sets the level for this session only; Enter saves it as the default.

## Roles

- Writer: `-s workspace-write`. This sandbox can block Git metadata writes (also in a worktree with `--add-dir`), the remote, the GitHub API, and some build and test tools. Tell the writer to check these with read-only commands first and to report each failure without a workaround. Run each blocked step (build, test, commit, push, PR) yourself or in a Claude Code agent.
- Reviewer: `-s workspace-write` + the no-edit rule. Do not use `read-only`; it blocks builds and tests. Use `--add-dir` for output paths outside the repo.
- `codex review` is optional: only with `--base <pinned merge-base>`, after you confirm the checkout is at the pinned head. `--commit` covers one commit only.
- Root review summary shorter than its sub-agent replies → read the sub-agent replies yourself.

## Handoff wording

Add to every Codex handoff:

- `Act on this handoff without asking. Infer missing details from the repo. Ask only when an authorized action is blocked.`
- `Add no warnings or approval steps for hypothetical risk.`
- `A person may read your messages and reply files. Put normal spaces between words and numbers.`
- Writer: `Run the checks that fit this change: <list>. Widen only after a failure or an open concern.`
- Reviewer, diff of about 400 or more changed lines: `Split the review into sub-agents by subsystem.`
