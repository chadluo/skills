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

## web-brutalism

Build UIs with browser-native default styles. The browser renders form controls, typography and interactive elements
with no custom styles. You change only spacing and layout. The result follows the user's OS theme, font size, contrast
and accessibility settings.

The skill covers:

- **Philosophy**: form follows function. Spacing and alignment are the primary design tools.
- **Design brief**: set the purpose, feel and typographic voice before you write CSS.
- **Style presets**: Swiss International, Bauhaus, Editorial, Technical and Minimalist. Each preset maps to system font
  stack categories.
- **System font stacks**: all 14 categories from
  [modern-font-stacks.md](skills/web-brutalism/modern-font-stacks.md). No web font downloads.
- **Minimal CSS baseline**: `color-scheme: light dark`, `box-sizing: border-box`, `font-size: inherit` on form elements.
- **Allowed overrides**: spacing and layout (flex and grid), system color keywords, `line-height` on body, `font-weight`
  on labels.
- **Prohibited overrides**: custom `color` and `background-color` values, web fonts, `font-size` on semantic elements,
  `border-radius`, `:focus { outline: none }`.
- **HTML element catalog**: native interactive elements, form structure (`fieldset`, `legend`, `label`), typography,
  sectioning and media.
- **Settings panel pattern**: `fieldset`, `legend`, `details` and `summary`, with no custom components.
- **Accessibility foundation**: native elements give a head start. Each project must still meet its own requirements,
  such as touch targets, ARIA and `lang`.

Examples: [examples/web-brutalism](examples/web-brutalism), live at <https://adluo.ch/skills/web-brutalism/>. The
prompt that made them is in [PROMPTS.md](examples/web-brutalism/PROMPTS.md).

## Local development

`./install.sh` links each skill in `skills/` into `~/.agents/skills` (Codex) and `~/.claude/skills` (Claude Code), so
edits here are live in both agents. Others install with `npx skills add chadluo/skills`.
