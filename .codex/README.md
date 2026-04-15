# Codex Skills

This directory integrates [OpenAI Codex](https://github.com/openai/codex) with the same skills used by Claude Code.

## Setup

Skills live in `.claude/skills/`. Create a symlink so Codex picks them up automatically:

```bash
ln -s ../.claude/skills .codex/skills
```

Run this once after cloning. After that, any skill added via `npx skills add` is immediately available to both Claude Code and Codex — no extra steps needed.

## Installing skills

```bash
npx skills add https://github.com/edutrul/drupal-ai --skill SKILL_NAME
```

See [SKILL.md](../SKILL.md) for the full list of available skills.
