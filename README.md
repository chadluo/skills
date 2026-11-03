# Skills

## herdr-pr-review

Agents pair programming with one writer and one reviewer. Uses [Herdr](https://herdr.dev/) to orchestrate. Works in
both forms of Herdr:

- **Herdr app**: a desktop terminal app, at the same level as Terminal.app or iTerm2. Agents run as `hc` (herdr-core)
  terminals. The app sets `HC_TERMINAL_ID`, but not `HERDR_ENV`. `hc --skill` prints the current instructions.
- **Herdr CLI**: a terminal multiplexer that runs inside another terminal. Agents run in `herdr` panes. It sets
  `HERDR_ENV=1`. `herdr --skill` prints the current instructions.

The skill finds the form from these variables, then reads the instructions that the installed binary prints.

Prompting rules come from the
[OpenAI latest-model guide](https://developers.openai.com/api/docs/guides/latest-model.md) and the
[Claude prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices.md)
(GPT-6 and Claude 5 families, Oct 2026). Checked against Codex CLI 0.163.0, Claude Code 2.1.302, hc 0.1.17 and herdr
0.9.5. Recheck when models or CLIs change.

## Local development

`./install.sh` links each skill in `skills/` into `~/.agents/skills` (Codex) and `~/.claude/skills` (Claude Code), so
edits here are live in both agents. Others install with `npx skills add chadluo/skills`.
