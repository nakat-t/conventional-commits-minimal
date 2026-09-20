# Agent Skill: conventional-commits-minimal

`conventional-commits-minimal/SKILL.md` is an
[Agent Skill](https://agentskills.io/) that teaches an AI coding agent to write
commit messages that follow [Conventional Commits Minimal](../README.md).

The skill contains the complete decision procedure (what counts as `feat`,
`fix`, `chore`, and `!`), the exact header grammar, worked examples, and a
self-check step that runs the `commit-msg` hook from `../hooks/` when it is
available.

## Install

Install the skill from this GitHub repository with
[`npx skills`](https://github.com/vercel-labs/skills), the CLI for the open
Agent Skills ecosystem. It supports Claude Code, Cline, and many other agents.

```sh
npx skills add nakat-t/conventional-commits-minimal
```

This repository contains a single skill, so the command above installs it
directly. You can also point at the skill directory explicitly:

```sh
npx skills add https://github.com/nakat-t/conventional-commits-minimal/tree/main/skills/conventional-commits-minimal
```

`npx skills` writes the skill into the location your agent expects (for
example `.claude/skills/` for Claude Code or `.cline/skills/` for Cline). See
the [`skills` CLI documentation](https://github.com/vercel-labs/skills) for
flags such as choosing the target agent or installing at the user level.

### Manual install (alternative)

If you already have this repository cloned locally, you can instead copy or
symlink the `conventional-commits-minimal/` directory into the skills
location of your agent:

```sh
mkdir -p .claude/skills
cp -r skills/conventional-commits-minimal .claude/skills/
```

The skill is self-contained: it does not require the hook to be installed,
but it will use `hooks/commit-msg.sh` or `hooks/commit-msg.ps1` for
verification when either is present in the repository. It also bundles a full
copy of the specification in `conventional-commits-minimal/reference/`, so
the AI agent can consult the original text even when only the skill directory
is installed.

## Configure the commit message language

The commit message grammar is fixed, but the natural language of the
*description* and *body* is chosen per repository. Without any configuration
the skill writes in English.

### Shared across the repository

Create `.conventional-commits-minimal` at the repository root and commit it, so
every contributor's agent uses the same language:

```toml
language = "ja"
```

The value is a BCP 47 language tag (`en`, `ja`, `fr`, `pt-BR`, `zh-Hant`) or a
plain language name (`Japanese`).

### Personal override for one clone

```sh
git config --local conventional-commits-minimal.language ja
```

This takes precedence over `.conventional-commits-minimal`, and is useful when
the repository has no shared setting or you need a different language locally.
An explicit instruction in the conversation overrides both, for that request
only.

### What the setting does and does not change

Only the description and the body prose are affected. The types `feat`, `fix`,
`chore`, the `!`, the ASCII colon and space, and footer tokens such as
`BREAKING CHANGE` or `Refs` are never translated, which keeps every message a
valid Conventional Commits 1.0.0 message.

The `commit-msg` hook in `../hooks/` validates only structure and accepts any
language, so no hook change is needed when you set this.
