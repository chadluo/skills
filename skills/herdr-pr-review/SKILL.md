---
name: herdr-pr-review
description: Coordinate a writer and an independent reviewer through Herdr to implement work, create or update a PR, and repeat review and fixes until unblocked. Use when the user requests this Herdr workflow, including continuing an existing PR review loop or a review-only run.
---

# Herdr PR Review

Two agents: the writer implements and owns the PR; a separate reviewer reviews. Codex or Claude can take either role. Prefer different models.

<!--
Prompting rules distilled from https://developers.openai.com/api/docs/guides/latest-model.md and
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices.md.
Runtime notes in references/ checked against Codex CLI 0.162.1 and Claude Code 2.1.296; prompting sections refreshed
Oct 2026 (GPT-6 family, Claude 5 family); installed now Codex CLI 0.163.0, Claude Code 2.1.302, not re-verified.
Recheck when models or CLIs change; do not fetch at run time.
-->

## Authorization

- Precedence: system/developer/platform > user's explicit instructions > repository instructions > this skill. Sandbox, approval policy, and permission mode always bind.
- Implement-and-PR request authorizes commits, pushes, PR creation, and task-related review comments and replies. Review-only request authorizes review only. Editing this skill authorizes nothing.
- Merge, auto-merge, force-push: only with explicit user authorization for that PR or branch.

## Setup

1. Read the installed `herdr` skill first; follow it for panes, prompts, reads, and blocked agents. `HERDR_ENV=1` not set → report it and stop.
2. Pin: task or PR, repo path, base, merge-base SHA, head SHA, working-tree status, repo instructions, required verification. Preserve unrelated work. Continuation → read existing reviews and checks first.
3. Per agent, record runtime + version, model, effort, permission policy, authorized actions. Mark a value verified only from visible status or config, else `unknown`.
4. Assignments: honor the user's; else different models, preferably different families; disclose any fallback. Reviewer effort, unless the user set it:
   - medium or higher: concurrency, persistence, migrations, capture or media pipelines, purchases, large refactors.
   - low: small UI, copy, configuration.
     Reason: low effort gave more invalid findings and missed the race and state bugs that medium found.
5. Reuse idle agents with known assignments, or start sibling panes. One writer per branch; never edit during a review. Same checkout by default; isolated worktree when requested or when unrelated changes could be mistaken for the PR.
6. Create a run directory outside the repo, e.g. `/tmp/herdr-<task>/`. All handoffs, replies, and the ledger live there.

## Token budget

Each message between agents costs a full turn for both sides. Rules:

- File handoffs: write the handoff to `<run>/writer.md` or `<run>/reviewer.md`; prompt only `Read <path> and follow it.` Later rounds: write `<run>/round-N.md`; prompt with that path only.
- File replies: each agent writes its full reply to `<run>/<role>-rN.md` and prints one status line in the pane: `<role> rN <verdict|done> head=<sha> blockers=<n> file=<path>`. The coordinator waits, reads the status line, and opens the file only when it must act on the content.
- Pass paths, not copies. Point the writer at `reviewer-rN.md`; do not paste or restate findings.
- One message per agent per round. Send all findings at once; the writer answers all of them in one turn (fix, or dispute with evidence). No acknowledgements, readiness pings, or "are you done" prompts. Get model and effort from status, not by asking.
- Keep both sessions alive across rounds; do not restart or `/clear` mid-loop. Re-review sends the incremental diff `<prev>..<new>`, not the full PR.
- Writer self-check: before the first handoff, the writer checks its own diff against the reviewer rules below. It is cheaper than a review round.
- Reviewer sub-agents only for a large or multi-subsystem diff (roughly 400+ changed lines). Small diffs: one pass.
- Optional suggestions and P3 findings: the writer records a disposition in its reply file; no extra round for them alone.

## Rules for every handoff

- State the authorized actions and precedence. Finish authorized work before asking questions; when you deviate or stop, cite the exact instruction or blocker.
- Scope: the task only. No extra files, abstractions, unrequested refactors, or code special-cased to pass tests.
- Read the relevant code before you claim a defect or a fix.
- Give a reason for any constraint that can look arbitrary.
- Reply files: short plain bullets, no tables. Return the requested fields, then end the turn; the coordinator sends the next step.
- Unknown runtime → apply these rules and identify the runtime before sending launch or permission instructions.

## Writer handoff

Include: task, acceptance criteria, repo path, branch and base, repo instructions, model, authorized actions. Tell the writer to:

- Implement the scoped change; run verification that fits the repo and risk.
- Create or update the PR: final behavior, validation, material limits. Follow repo commit conventions.
- Reply: PR URL, branch, head SHA, change summary, verification results, known gaps.
- Change nothing more until findings arrive. The writer owns all later fixes.

Continuation: send unresolved findings to the relevant agent; do not redo finished work.

## Reviewer handoff

Include: task and acceptance criteria, repo instructions, repo path, PR URL, merge-base..head SHAs, the writer's verification evidence, and:

- The issue or task text verbatim, or the command to read it, never only a summary.
- User decisions that settle scope: approved exclusions, accepted limits, deferred work. Reason: past invalid findings came from summaries that dropped these.
- Verification permissions (see Reviewer verification) and whether it may post on the PR.
- No repository changes: no edits to tracked or untracked files, no commits. Reason: the writer owns the branch; reviewer edits change the reviewed tree.

First review is independent: the reviewer reads the full diff and related code before it sees the writer's explanations.

## Reviewer rules

- Trace values in code; comments and names can be stale. Report defects introduced or worsened by the diff. Unchanged base behavior is a finding only if the task covers it; else a follow-up note.
- Evidence: label each finding `reproduced`, `trace`, or `hypothesis`. `trace` = complete code path or calculation demonstrating the failure. `hypothesis` = verification note, not a confirmed defect.
- Before reporting: check relevant guards, callers, accepted decisions, base behavior, and evidence that could refute the claim. Verify platform assumptions against SDK/docs or a focused probe.
- Severity: user impact + realistic likelihood. Timing windows, termination, and fix cost do not determine severity by themselves. Only P1/P2 block.
  - P1: major correctness, data-loss, security, or availability failure.
  - P2: concrete user-visible defect on a plausible path.
  - P3: minor impact.
- Fix: name the broken invariant and smallest correction. Check that the recommendation preserves related behavior: geometry, orientation, Undo, media retention, gesture ownership, accessibility, as applicable. Implementation is a suggestion; an equivalent correction is acceptable. No new abstractions, persistence layers, or defensive code for P3.
- Style: one brief pass for redundant work, duplication, unclear naming, and inconsistency with surrounding code/UI. Use the existing three optional slots; state the concrete benefit. Zero suggestions is valid.
- Tests: follow repo/user test policy; request coverage for a named regression or non-trivial invariant. Before recommending removal, identify the protected behavior and explain why protection is unnecessary or covered elsewhere. No seams made only for a test. A missing test alone never blocks.
- Sub-agents: merge every sub-agent finding into the reply; list each dropped one with a one-line reason. Reason: dropped sub-agent findings have shipped as bugs.
- Device-only behavior (hardware, OS state, store sandbox, real camera, orientation, presentation feel): list it as not cleared by code review.

## Finding format

- Findings, blockers first: ID; P1/P2/P3; `file:line`; evidence label; trigger -> failure; broken invariant; fix direction.
- Optional: at most three. Hypotheses: suspected failure + smallest confirming/refuting check.
- Dropped sub-agent findings with reasons.
- Verdict: `clear` | `changes required` | `blocked`; exact head; required gaps as one short list. No boilerplate about checks that were never in scope.
- Withdraw disproved findings explicitly. A clear trace needs no runtime reproduction. Missing required acceptance evidence still blocks clearance.

If a formal GitHub review is impossible (e.g. shared author account), keep the agent verdict and report the platform approval need separately.

## Reviewer verification

Default: the reviewer may run targeted checks, not the full suite. Reason: reviews that ran a check had no invalid findings and caught a bug that a passed device check missed.

- Allowed: a focused test, a build of the affected target, a throwaway script, or a scratch test outside the repo, to confirm or refute one suspected defect or to verify one fix.
- Not the reviewer's job: full suite and acceptance runs. The writer owns them; the reviewer checks that the evidence matches the head and the claim.
- Isolation: reviewer-only build output, caches, simulators, scratch files, all outside the repo. Never share a running simulator, device, or build directory with the writer.
- Runtime cannot run it (sandbox, simulator, network) → the reviewer writes the exact command and expected result; the coordinator runs it in a permitted pane or asks the writer, and returns the output in the next round file.
- A check that cannot run makes the verdict `blocked` only if acceptance requires it; else it is a gap.

## Runtime notes

Before you launch an agent or write its handoff, read its runtime file. Apply its Launch and Roles flags; add its Handoff wording to every handoff and round file for that agent.

- Codex: [references/codex.md](references/codex.md)
- Claude Code: [references/claude-code.md](references/claude-code.md)

## Review and fix loop

1. Collect the reviewer reply plus all PR comments, unresolved threads, review states, and checks, including from humans and other automation. Keep the ledger in `<run>/ledger.md`: ID or thread, requested change, disposition, fix commit or evidence, reviewer confirmation. Include dropped and deferred findings. If the PR merges before the review ends, still collect the verdict and report every finding to the user for follow-up.
2. Writer round: point the writer at the reviewer reply. Each blocker needs a fix or an evidence-backed dispute, plus relevant verification, the new head, and PR replies where authorized. Optional and P3 items need only a disposition; they do not widen scope.
3. Re-review round: new head, `<prev>..<new>` diff, ledger path. Check the original failure, completeness of the fix, and fix regressions. Scrutinize your own previous recommendations as carefully as writer code. The writer's claim alone never clears a blocker. Resolve threads only after reviewer confirmation, following repo ownership rules.
   - Scope: incremental diff + affected callers/invariants. New unrelated findings become follow-ups unless P1. Incomplete fixes and fix regressions remain blocking at P1/P2.
   - Request a smaller fix when warranted. Downgrade severity only when evidence changes the assessed impact or likelihood.
4. After two fix rounds: coordinator checkpoint. Continue only for an existing blocker or fix regression, with demonstrated progress and a concrete next check. Stop on no progress or scope growth; report unresolved findings. Never manufacture clearance.
5. Report to the user and continue independent work when a finding stays disputed, checks need unavailable infrastructure, permissions block progress, or a round makes no progress. Never manufacture `clear` or weaken acceptance criteria.

Wait through Herdr in bounded intervals; give the user short progress updates. Lifecycle states show readiness, not success. On timeout, stall, `blocked`, or `unknown`: read state and output before any retry; never resend blindly. Keep the same agents across rounds; a replacement gets the ledger, criteria, verification results, and latest head.

## Completion

Refresh the head, threads, review states, and required checks (review-only without a PR: the pinned comparison and its verification). Report unblocked only when:

- The reviewer cleared the current head and tree. Any later change, including docs, config, assets, or dependencies, needs another review.
- Every blocker has a confirmed disposition; no outstanding change requests or required approvals.
- Required checks pass and acceptance criteria are met. A gap in required verification keeps the run blocked.

Report: PR link, writer and reviewer runtimes, models, efforts (or `unknown`), final reviewed SHA, verification outcome, remaining optional suggestions or blockers, deferred and dropped findings, and device or runtime checks the review did not clear. Leave the PR open unless the user explicitly asked for a merge.
