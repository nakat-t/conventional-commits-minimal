---
name: conventional-commits-minimal
description: Write Git commit messages that follow Conventional Commits Minimal, a strict subset of Conventional Commits 1.0.0 with exactly three types (feat, fix, chore), no scope, and "!" for breaking changes. Use whenever asked to commit, write a commit message, or review a commit message in a project that uses Conventional Commits Minimal.
---

# Conventional Commits Minimal

Produce a commit message in this exact shape:

```
<type>[!]: <description>

[optional body]

[optional footer(s)]
```

* `<type>` is exactly one of `feat`, `fix`, `chore`. Lowercase. Nothing else.
* Never write a scope. `feat(api):` is invalid. Use `feat:`.
* Append `!` directly after the type for a breaking change: `feat!:`, `fix!:`, `chore!:`.
* One space after the colon, then a non-empty description.
* If a body or footers are present, exactly one blank line follows the description.
* A `BREAKING CHANGE: <detail>` footer is optional and allowed **only** when the header has `!`.

## Procedure

1. **Inspect the change.** Run `git diff --cached` (or `git diff` if nothing is staged, and stage the intended files). Read the whole diff; do not guess from file names.

2. **Choose the type with one question: what does a user of this project observe?**

   | The change...                                                                                   | Type    |
   |-------------------------------------------------------------------------------------------------|---------|
   | adds a capability a user did not have before (new command, option, API, endpoint, UI element)   | `feat`  |
   | makes existing user-visible behavior correct (bug, crash, wrong output, user-observable perf)    | `fix`   |
   | changes nothing a user can observe (docs, tests, refactor, formatting, CI, build, tooling, deps) | `chore` |

   Rules of thumb:
   * Judge by *effect*, not by *file kind*. A dependency bump that fixes a user-facing bug is `fix`; a routine bump is `chore`.
   * A refactor is `chore` only if behavior is unchanged. If it also changes behavior, it is not a refactor.
   * Performance work is `fix` when users notice, `chore` otherwise.
   * When in doubt between `chore` and something else, ask whether the change would deserve a line in release notes. If yes, it is not `chore`.

3. **Decide whether it is breaking.** Add `!` if an existing user could be broken by upgrading: removed or renamed public API, changed defaults, changed output format, dropped platform/runtime support, changed config schema. `!` can go on any type, including `chore!` (e.g. raising the minimum supported runtime).

4. **If the diff needs more than one type, prefer splitting.** Propose separate commits (`git add -p` when needed), one per type. If splitting is impractical, pick the type with the largest SemVer impact: `feat` > `fix` > `chore`. Breaking (`!`) always wins over a non-breaking type.

5. **Write the description.**
   * Imperative mood, present tense: "add", "prevent", "remove" (not "added", "adds").
   * State what the change does for the user, not how it was implemented.
   * Keep the whole header at or below 72 characters when possible.
   * No trailing period.

6. **Add a body only when the diff does not explain itself.** Explain *why*, constraints, or alternatives rejected. Wrap at 72 columns. Separate from the header with one blank line.

7. **Add footers only when they carry information.** Use git trailer form: `Refs: #123`, `Reviewed-by: Name`, `BREAKING CHANGE: <what breaks and how to migrate>`. The `BREAKING CHANGE:` footer requires `!` in the header.

8. **Self-check before committing.** If the repository contains the hook, pipe the message through it and fix anything it rejects:
   * POSIX: `printf '%s\n' "<message>" | sh hooks/commit-msg.sh`
   * PowerShell: `"<message>" | pwsh -File hooks/commit-msg.ps1`

   If the hook is absent, verify manually against the header regex `^(feat|fix|chore)!?: \S` and the rules above.

9. **Commit.** Use `git commit -m "<header>"` for a header-only message, or `git commit -F <file>` / a heredoc for messages with a body, so blank lines are preserved.

## Examples

Good:

```
feat: add --json flag to the export command
```
```
fix: prevent crash when the config file is empty
```
```
chore: extract request parsing into its own module
```
```
chore: bump eslint to 9.12
```
```
feat!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```
```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Refs: #123
```

Bad, with the fix:

| Bad                                        | Why                                         | Good                                        |
|--------------------------------------------|---------------------------------------------|---------------------------------------------|
| `docs: fix typo in README`                 | `docs` is not a type                        | `chore: fix typo in README`                 |
| `refactor: simplify parser`                | `refactor` is not a type                    | `chore: simplify parser`                    |
| `feat(api): add endpoint`                  | scope is not allowed                        | `feat: add /users endpoint`                 |
| `Feat: add endpoint`                       | type must be lowercase                      | `feat: add endpoint`                        |
| `feat:add endpoint`                        | space required after colon                  | `feat: add endpoint`                        |
| `feat: drop Node 6` + `BREAKING CHANGE:`   | footer without `!`                          | `feat!: drop Node 6` + footer               |
| `fix: update dependencies`                 | routine bump is not user-visible            | `chore: update dependencies`                |
| `chore: add dark mode`                     | user-visible capability                     | `feat: add dark mode`                       |
| `update stuff`                             | no type                                     | `chore: update CI cache key`                |

## Reference

Full specification: `README.md` at the repository root, or
<https://github.com/nakat-t/conventional-commits-minimal>.
