# Codex CLI

## Launch

- CLI: `herdr agent start <name> --kind codex --pane <shell-pane-id> -- <flags>`
- App: `hc run --bg --name <name> --cwd <path> codex --no-daemon <flags> "<first task>"`. Always pass `--no-daemon`.
- Flags: `-s <sandbox>`, `-c model_reasoning_effort=<level>`, `--add-dir <path>`.
- Omit `-m`; Codex then uses the model in `~/.codex/config.toml`. Never pass a model name from memory. For an exact model version, start Codex first, open `/model`, and pick a name from that list. Read the model in use from the status line.
- Effort levels (GPT-6 Sol): `low`, `medium` (default), `high`, `xhigh`, `max`. Confirm that the CLI accepts `xhigh`/`max` before use. Map `minimal` to `low`.
- App: to change model or effort, type `/model` with `hc keys` (see Herdr mode). In the effort list, press `s` to set the level for this session only; Enter saves it as the default.
- Blocked by sandbox or approvals → report the blocker. Keep sandbox and approvals on.

## Roles

- Writer: `-s workspace-write`. Check network, Git metadata, external caches, remote, and `gh` auth with read-only commands; push only real work.
- Reviewer: `-s workspace-write` + the no-edit rule. Do not use `read-only`; it blocks builds and tests. Use `--add-dir` for output paths outside the repo and temp dirs.
- Use the interactive session. `codex review` is optional: only with `--base <pinned merge-base>`, after you confirm the checkout is at the pinned head. `--commit` covers one commit only.

## Status

- CLI: treat Herdr `idle` for Codex as inconclusive. Read the pane, wait again, keep the prompt unsent. Act only on a complete status line or reply file.
- Root review summary shorter than its sub-agent replies → read the sub-agent replies yourself.

## Handoff wording

Add to every Codex handoff:

- `Act on this handoff without asking. Infer missing details from the repo. Ask only when an authorized action is blocked.`
- `Add no warnings or approval steps for hypothetical risk.`
- Writer: `Run the checks that fit this change: <list>. Widen only after a failure or an open concern.`
- Reviewer, diff ≥ ~400 changed lines: `Split the review into sub-agents by subsystem.`
