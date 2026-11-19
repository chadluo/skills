# Codex CLI

## Launch

- CLI: `herdr agent start <name> --kind codex --pane <shell-pane-id> -- <flags>`
- App: `hc run --bg --name <name> --cwd <path> codex --no-daemon <flags> "<first task>"`. Always pass `--no-daemon`, because without it Codex runs its commands outside Herdr.
- Flags: `-s <sandbox>`, `-c model_reasoning_effort=<level>`, `--add-dir <path>`.
- Omit `-m` to use the model in `~/.codex/config.toml`. Never pass a model name from memory, because the backend rejects retired names and the turn is lost. For an exact model, pick it from the `/model` list after start. Read the model in use from the status line.
- Status: Codex can show `idle` while it works. Wait for the reply file and status line.
- Effort levels differ by model; pick one from the `/model` effort list. GPT-6.2 rejects `none`; map `none` and `minimal` to `low`.
- Models: GPT-6.2 Astra for the most demanding work (default reviewer), GPT-6.2 Sol for everyday work at lower cost (writer on small tasks). OpenAI documents no behavior difference between them; the handoff wording below applies to both.

## Roles

- Writer: `-s workspace-write`. This sandbox can block Git metadata writes (also in a worktree with `--add-dir`), the remote, the GitHub API, and some build and test tools. Tell the writer to check these with read-only commands first and to report each failure without a workaround. Run each blocked step (build, test, commit, push, PR) yourself or in a Claude Code agent.
- Reviewer: `-s workspace-write` + the no-edit rule. Do not use `read-only`; it blocks builds and tests. Use `--add-dir` for output paths outside the repo.
- `codex review` is optional: only with `--base <pinned merge-base>`, after you confirm the checkout is at the pinned head. `--commit` covers one commit only.

## Handoff wording

Add to every Codex handoff:

- `Act on this handoff without asking. Infer missing details from the repo. Make reasonable, reversible assumptions and state them in the reply file. Ask only when an authorized action is blocked.`
- `Do not end the turn while authorized work in scope remains. Do not stop after you describe what you could do or offer to do it.`
- `Add no warnings or approval steps for hypothetical risk.`
- `A person may read your messages and reply files. Put normal spaces between words and numbers.`
- `Make the reply file self-contained. Do not use shorthand or abbreviations from your reasoning or tool calls.`
- Writer: `Run the checks that fit this change: <list>. Widen only after a failure or an open concern.`
- Writer: `Reuse existing logic in the repo. Add no indirection or abstraction that the task does not need. Add tests only when the repo requires them or to catch a specific regression that existing tests miss.`
- Do not add "be concise" lines, because GPT-6.2 is concise by default.
- Reviewer, diff of about 400 or more changed lines: `Split the review into sub-agents by subsystem.`
