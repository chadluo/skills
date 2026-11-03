---
name: herdr-pr-review
description: Coordinate a writer and an independent reviewer through Herdr (the desktop app with `hc`, or the CLI with `herdr`) to implement work, create or update a PR, and repeat review and fixes until unblocked. Use when the user requests this Herdr workflow, including continuing an existing PR review loop or a review-only run.
---

# Herdr PR Review

Terms:

- **Coordinator**: you. You start the agents, pass files, and report to the user. You do not write or review the change. You may run steps that the writer's sandbox blocks (build, test, commit, push, PR).
- **Writer**: the agent that implements the change. It owns the branch and the PR.
- **Reviewer**: a separate agent that reviews the writer's head. It changes no repository files.
- **Head**: the commit SHA under review.
- **Round N**: the writer's turn (`writer-rN`), then the reviewer's turn (`reviewer-rN`).
- **Blocker**: a P1 or P2 finding, or required verification that is missing.
- **Run directory** (`<run>`): a unique directory outside the repo. It holds all handoffs, reply files, and the ledger.

## Authorization

- Precedence: system/developer/platform > user's explicit instructions > repository instructions > this skill. Sandbox, approval policy, and permission mode always bind.
- Implement-and-PR request authorizes commits, pushes, PR creation, and task-related review comments and replies. Review-only request authorizes review only.
- Merge, auto-merge, force-push: only with explicit user authorization for that PR or branch.

## Herdr mode

Find the mode first:

- `HC_TERMINAL_ID` is set → **Herdr app** (herdr-core). Run `hc --skill` and follow it. Do not require `HERDR_ENV`, and do not use `herdr` commands.
- Else `HERDR_ENV=1` → **Herdr CLI**. Run `herdr --skill` and follow it.
- Neither → report that this session is not inside Herdr and stop.

App-mode rules:

- Start agents with `hc run --bg --name <name> --cwd <path> <command> "<first task>"`. If `first_message.sent` is not `true`, read the screen. Send the task only at an empty prompt, turn 0.
- Write your `$HC_TERMINAL_ID` value into each handoff's report command: `hc send <id> "<status line>"`.
- Wait with `hc wait --children any`.
- Type agent slash commands as single keys: `hc keys <name> / m o d e l enter`. `hc send` wraps the text, so the command does not run. In a `/model` list, `s` sets this session only; Enter saves a global default.
- Use an `hc templates` role only when it fits the runtime notes below.

## Agent status

- `idle` or `done` does not prove that a turn ended; Codex can show `idle` while it works. A turn ended only when the reply file exists and its status line arrived. Status lines can wrap or be cut off, so match only the prefix `<role> rN`.
- Never send keys or text to an agent that can still be working. A key such as `esc` interrupts the turn, and the lost work costs a full round.
- Read the screen before any retry. A first message can take 30 seconds or more to appear, and a blind resend makes a duplicate.
- Leave approval dialogs for the user. Exception: you may accept the folder-trust dialog at start for the pinned repo path.

## Setup

1. Pin: task or PR, repo path, base, merge-base SHA, head SHA, working-tree status, repo instructions, required verification. Continuation → read existing reviews and checks first; do not redo finished work.
2. Per agent, record runtime + version, model, effort, permission policy, authorized actions. Mark a value verified only from visible status or config, else `unknown`.
3. Assignments: honor the user's. Else give the reviewer the strongest model tier available, because a weaker reviewer misses defects. Prefer a different model family from the writer. Disclose any fallback. Reviewer effort, unless the user set it:
   - medium or higher: concurrency, persistence, migrations, capture or media pipelines, purchases, large refactors.
   - low: small UI, copy, configuration.
4. Agents:
   - Reuse idle agents with known assignments, or start new ones.
   - Start each agent from a fresh shell, because a changed environment (for example an edited `PATH`) can break agent login.
   - Use one writer per branch. The writer does not edit during a review.
   - Use the same checkout. Use an isolated worktree when the user asks, or when unrelated changes could look like part of the PR.
5. Create the run directory with `mktemp -d /tmp/herdr-<task>-XXXXXX`, because a fixed name can collide with another run.
6. Run heavy builds and test suites one at a time per machine, across all runs, because parallel heavy runs cause timeouts and launch failures.

## Messages and files

- Handoffs: write `<run>/writer.md` and `<run>/reviewer.md`, then `<run>/round-N-<role>.md`. Prompt only `Read <path> and follow it.`
- Replies: each agent writes its full reply to `<run>/<role>-rN.md` and gives one status line: `<role> rN <verdict|done> head=<sha> blockers=<n> file=<path>`. CLI: in its pane; app: also with `hc send <id>`. Open the file only when you must act on it.
- Point the writer at `reviewer-rN.md`; do not paste or restate findings.
- One message per agent per round. The writer answers all findings in one turn: fix, or dispute with evidence.
- Keep both sessions alive across rounds; do not restart or `/clear` them. A replacement agent gets the ledger, criteria, verification results, and latest head.
- Before its first reply, the writer checks its diff against the Reviewer rules.

## Rules for every handoff

- State the authorized actions and precedence. Finish authorized work before asking questions; when you deviate or stop, cite the exact instruction or blocker.
- State what done means and when to stop. Agents ask only the coordinator, which answers from the pinned task and decisions or asks the user. Reviewers record open questions about the writer's code as `hypothesis`; the writer answers in its next turn.
- Scope: the task only. No extra files, abstractions, unrequested refactors, or code special-cased to pass tests.
- Reply files: short plain bullets, no tables. Return the requested fields, then end the turn.

## Writer handoff

Include: task, acceptance criteria, repo path, branch and base, repo instructions, authorized actions. Tell the writer to:

- Implement the scoped change; run verification that fits the repo and risk.
- Create or update the PR: final behavior, validation, material limits.
- Stacked PRs: after the lower PR is squash-merged into its base (usually `main`), merge that base into the next branch and set the next PR's base to the same branch. Do not rebase or force-push.
- Reply: PR URL, branch, head SHA, change summary, verification results, known gaps.
- Change nothing more until findings arrive. The writer owns all later fixes.

## Reviewer handoff

Include: task and acceptance criteria, repo instructions, repo path, PR URL, merge-base..head SHAs, the writer's verification evidence, and:

- The issue or task text verbatim, or the command to read it, because a summary can change a rule and cause invalid findings.
- User decisions that settle scope: approved exclusions, accepted limits, deferred work. Without them, the reviewer reports accepted behavior as defects.
- Verification permissions (see Reviewer verification) and whether it may post on the PR.
- No repository changes: no edits to tracked or untracked files, no commits, because an edit changes the tree under review.

First review is independent: the reviewer reads the full diff and related code before it sees the writer's explanations.

## Reviewer rules

- Trace values in code; comments and names can be stale. Report defects introduced or worsened by the diff. Unchanged base behavior is a finding only if the task covers it; else a follow-up note.
- Evidence: label each finding `reproduced`, `trace`, or `hypothesis`. `trace` = complete code path or calculation demonstrating the failure. `hypothesis` = verification note, not a confirmed defect.
- Before reporting: check guards, callers, accepted decisions, base behavior, and evidence that could refute the claim. Verify platform assumptions against SDK/docs or a focused probe.
- Severity: user impact + realistic likelihood. Timing windows, termination, and fix cost do not determine severity by themselves. Only P1/P2 block.
  - P1: major correctness, data-loss, security, or availability failure.
  - P2: concrete user-visible defect on a plausible path.
  - P3: minor impact.
- Fix: name the broken invariant and smallest correction. Check that it preserves related behavior (for example layout, Undo, accessibility, data that other code reads). An equivalent correction is acceptable. No new abstractions, persistence layers, or defensive code for P3.
- Style: one brief pass for redundant work, duplication, unclear naming, and inconsistency with surrounding code or UI. Report these as optional suggestions with a concrete benefit; zero is valid.
- Tests: follow repo/user test policy; request coverage only for a named regression or non-trivial invariant. Recommend test removal only with the behavior it protects and why that is covered or unnecessary. No seams made only for a test. A missing test alone never blocks.
- Sub-agents (the reviewer's own in-session helpers, not Herdr agents): use them only for a diff of about 400 or more changed lines or several subsystems. Merge every sub-agent finding into the reply; list each dropped one with a one-line reason.
- Device-only behavior (hardware, OS state, store sandbox, camera, presentation feel): list it as not cleared by code review. A screenshot shows only an end state; check animation and timing defects with video frames.

## Finding format

- Findings, blockers first: ID; P1/P2/P3; `file:line`; evidence label; trigger -> failure; broken invariant; fix direction.
- Optional: at most three. Hypotheses: suspected failure + smallest confirming/refuting check.
- Verdict: `clear` | `changes required` | `blocked`; exact head; required gaps as one short list. No boilerplate about checks that were never in scope.
- Withdraw disproved findings explicitly. A clear trace needs no runtime reproduction.

If a formal GitHub review is impossible (e.g. shared author account), keep the agent verdict and report the platform approval need separately.

## Reviewer verification

- The reviewer may run targeted checks: a focused test, a build of the affected target, or a scratch script outside the repo, to confirm or refute one finding or fix. The writer owns full-suite and acceptance runs; the reviewer checks that their evidence matches the head and the claim.
- Keep reviewer build output, caches, simulators, devices, and scratch files outside the repo and apart from the writer's.
- Runtime cannot run a check (sandbox, simulator, network) → the reviewer writes the exact command and expected result. The coordinator runs it in a permitted pane or asks the writer, and returns the output in the next round file.
- A check that cannot run makes the verdict `blocked` only if acceptance requires it; else it is a gap.

## Runtime notes

Before you launch an agent or write its handoff, read its runtime file. Apply its Launch and Roles rules; add its Handoff wording to every handoff and round file for that agent.

- Codex: [references/codex.md](references/codex.md)
- Claude Code: [references/claude-code.md](references/claude-code.md)

## Review and fix loop

1. Collect the reviewer reply plus all PR comments, unresolved threads, review states, and checks, from people and automation. Keep the ledger in `<run>/ledger.md`: ID or thread, requested change, disposition, fix commit or evidence, reviewer confirmation. Include dropped and deferred findings. If the PR merges before the review ends, still collect the verdict and report every finding to the user for follow-up.
2. Writer turn: each blocker needs a fix or an evidence-backed dispute, plus relevant verification, the new head, and PR replies where authorized. Optional and P3 items need only a disposition in the reply file; they get no extra round and do not widen scope.
3. Reviewer turn (round 2 and later): send the new head, the `<prev>..<new>` diff, and the ledger path. The reviewer checks the original failure, fix completeness, fix regressions, and its own earlier recommendations, as strictly as writer code. The writer's claim alone never clears a blocker. Resolve threads only after reviewer confirmation, following repo ownership rules.
   - Scope: incremental diff + affected callers/invariants. New unrelated findings become follow-ups unless P1. Incomplete fixes and fix regressions remain blocking at P1/P2.
   - Downgrade severity only when evidence changes the assessed impact or likelihood.
4. After round 3 (two fix rounds): checkpoint. Continue only for an existing blocker or fix regression, with demonstrated progress and a concrete next check. Else stop.
5. Report to the user and continue independent work when a finding stays disputed, checks need unavailable infrastructure, permissions block progress, or a round makes no progress. Never manufacture `clear` or weaken acceptance criteria.

## Completion

Refresh the head, threads, review states, and required checks (review-only without a PR: the pinned comparison and its verification). Report unblocked only when:

- The reviewer cleared the current head and tree. Any later change, including docs, config, assets, or dependencies, needs another review.
- Every blocker has a confirmed disposition; no outstanding change requests or required approvals.
- Required checks pass and acceptance criteria are met. A gap in required verification keeps the run blocked.

Report: PR link, writer and reviewer runtimes, models, efforts (or `unknown`), final reviewed SHA, verification outcome, remaining optional suggestions or blockers, deferred and dropped findings, and device or runtime checks the review did not clear. Leave the PR open unless the user explicitly asked for a merge. When the user accepts the result, stop the agent terminals you started (app: `hc kill <name>; hc rm <name>`); never touch other terminals.
