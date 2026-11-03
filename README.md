# Skills

## herdr-pr-review

Agents pair programming with one writer and one reviewer. Uses [Herdr](https://herdr.dev/) to orchestrate, requiring
herdr runtime and skill installed.

## Local development

`./install.sh` links each skill in `skills/` into `~/.agents/skills` (Codex) and `~/.claude/skills` (Claude Code), so
edits here are live in both agents. Others install with `npx skills add chadluo/skills`.
