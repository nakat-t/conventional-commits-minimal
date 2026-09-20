# Agent Skill: conventional-commits-minimal

`conventional-commits-minimal/SKILL.md` is an
[Agent Skill](https://agentskills.io/) that teaches an AI coding agent to write
commit messages that follow [Conventional Commits Minimal](../README.md).

The skill contains the complete decision procedure (what counts as `feat`,
`fix`, `chore`, and `!`), the exact header grammar, worked examples, and a
self-check step that runs the `commit-msg` hook from `../hooks/` when it is
available.

## Install

Copy or symlink the `conventional-commits-minimal/` directory into the skills
location of your agent. Common locations:

| Agent              | Project-level                          | User-level                       |
|--------------------|----------------------------------------|----------------------------------|
| Claude Code        | `.claude/skills/`                      | `~/.claude/skills/`              |
| Cline              | `.cline/skills/`                       | `~/.cline/skills/`               |
| Other Agent Skills | consult your agent's documentation     |                                  |

Example (project-level, Claude Code):

```sh
mkdir -p .claude/skills
cp -r skills/conventional-commits-minimal .claude/skills/
```

The skill is self-contained: it does not require the hook to be installed,
but it will use `hooks/commit-msg.sh` or `hooks/commit-msg.ps1` for
verification when either is present in the repository.
