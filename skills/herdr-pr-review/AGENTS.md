# Maintaining herdr-pr-review

## Where instructions go

- `SKILL.md`: instructions that apply to all models and runtimes, including the coordinator, which can be a Claude or an OpenAI model. Do not name a model or runtime here, except in the links to the runtime files.
- `references/claude-code.md` and `references/codex.md`: launch flags, roles, handoff wording, and model notes for one runtime.
- Write a separate note for each model only when the models of one provider behave significantly differently (for example Opus and Fable). Otherwise, write one note that applies to all of the provider's models.

## When a new model is released

1. Read the provider's latest prompting guide:
   - Claude: <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices.md>, and the guide for each new model.
   - OpenAI and Codex: <https://developers.openai.com/api/docs/guides/latest-model.md>
2. Update the runtime file: effort levels and defaults, model roles, handoff wording, and behavior that differs from the previous model. Remove notes about retired models.
3. Check `SKILL.md` against the guides. Move to a runtime file any instruction that applies to only one model.
4. Report the guidance that the guides do not give. Do not fill those gaps from memory.

## Writing rules

- Write in ASD-STE100 Simplified Technical English.
- Write plain rules with a reason: `Do X when Y, because Z.` Use no emphasis such as caps, `CRITICAL`, or `MUST`.
- Give each prohibition its scope and reason. Do not write a bare `never`.
- Do not write model IDs or names from memory into launch commands, because a retired name fails the run.
- Keep the files short. Add a rule only for a behavior that the guides document or that a real run showed.
