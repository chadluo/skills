# Codex CLI

## Launch

- `herdr agent start <name> --kind codex --pane <shell-pane-id> -- <flags>`
- Flags: `-s <sandbox>`, `-c model_reasoning_effort=<level>`, `--add-dir <path>`.
- Omit `-m`; Codex then uses the model in `~/.codex/config.toml`. Reason: model names go stale. On 2026-10-18 a remembered name (`codex/gpt-6.1-sol`) that worked hours earlier failed with a 400 error and lost a turn. To get an exact model version, start Codex first, open `/model`, and pick a name from that list. Read the model in use from the status line.
- Effort levels (GPT-6 Sol): `low`, `medium` (default), `high`, `xhigh`, `max`. Source is API docs; confirm the CLI accepts `xhigh`/`max` before use. Map `minimal` to `low`.
- Blocked by sandbox or approvals → report the blocker. Keep sandbox and approvals on.

## Roles

- Writer: `-s workspace-write`. It may not cover network, Git metadata, or external caches. Check remote and `gh` auth with read-only commands; push only real work.
- Reviewer: `-s workspace-write` + the no-edit rule, so targeted checks run. `read-only` blocks builds and tests. Temp dirs are writable; `--add-dir` for other output paths.
- Use the interactive session. `codex review` is optional: only with `--base <pinned merge-base>`, after you confirm the checkout is at the pinned head. `--commit` covers one commit only.

## Status

- Herdr `idle` is inconclusive for Codex. Read the pane, wait again, keep the prompt unsent. Act only on a complete status line or reply file.
- Codex often splits a review into spec and standards sub-agents. Root summary shorter than the sub-agent replies → read the sub-agent replies yourself.

## Handoff wording

GPT-6 models stop to ask, delegate too little, and over-test. Add to every Codex handoff:

- `Act on this handoff without asking. Infer missing details from the repo. Ask only when an authorized action is blocked.`
- `Add no warnings or approval steps for hypothetical risk.`
- Writer: `Run the checks that fit this change: <list>. Widen only after a failure or an open concern.`
- Reviewer, diff ≥ ~400 changed lines: `Split the review into sub-agents by subsystem.`
