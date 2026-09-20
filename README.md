# Conventional Commits Minimal 1.0.0-beta.1

## Summary

Conventional Commits Minimal is a strict subset of
[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).
It keeps the parts of Conventional Commits that matter for everyday commits and
removes the parts that make people hesitate while writing a commit message:
the open-ended list of _types_ and the _optional scope_.

Every message that conforms to Conventional Commits Minimal also conforms to
Conventional Commits 1.0.0, so existing Conventional Commits parsers and tools
accept it without modification.

The commit message should be structured as follows:

---

```
<type>[!]: <description>

[optional body]

[optional footer(s)]
```
---

The commit contains the following structural elements, to communicate intent to the
consumers of your project:

1. **feat:** a commit of the _type_ `feat` introduces a new capability that is
   visible to the users of the project (this correlates with
   [`MINOR`](http://semver.org/#summary) in Semantic Versioning).
1. **fix:** a commit of the _type_ `fix` corrects behavior that is visible to
   the users of the project (this correlates with
   [`PATCH`](http://semver.org/#summary) in Semantic Versioning).
1. **chore:** a commit of the _type_ `chore` does not change any behavior
   visible to the users of the project. Documentation, tests, refactoring,
   formatting, build and CI configuration, and dependency maintenance are all
   `chore` (this correlates with _no version change_ in Semantic Versioning).
1. **!:** a commit that appends `!` after the type introduces a breaking change
   (correlating with [`MAJOR`](http://semver.org/#summary) in Semantic
   Versioning). A breaking change can be part of commits of any _type_.
1. _footers_ may be provided and follow a convention similar to
   [git trailer format](https://git-scm.com/docs/git-interpret-trailers).
   A `BREAKING CHANGE:` footer may be used to describe a breaking change in
   detail, but only together with `!`.

No other _types_ are allowed. A _scope_ is not allowed.

## Examples

### Commit message with a new feature
```
feat: add --json flag to the export command
```

### Commit message with a bug fix
```
fix: prevent crash when the config file is empty
```

### Commit message with a change that users do not see
```
chore: extract request parsing into its own module
```

### Commit message with `!` to draw attention to a breaking change
```
feat!: send an email to the customer when a product is shipped
```

### Commit message with both `!` and a `BREAKING CHANGE` footer
```
feat!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```

### Commit message with multi-paragraph body and multiple footers
```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
```

## Specification

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

1. Commits MUST be prefixed with a type, followed by an OPTIONAL `!`, and the
   REQUIRED terminal colon and space.
1. The type MUST be exactly one of `feat`, `fix`, or `chore`, written in
   lowercase. No other type is allowed.
1. The type `feat` MUST be used when a commit adds a new capability that is
   visible to the users of the project.
1. The type `fix` MUST be used when a commit corrects behavior that is visible
   to the users of the project.
1. The type `chore` MUST be used when a commit does not change any behavior
   visible to the users of the project. This includes, but is not limited to,
   documentation, tests, refactoring, formatting, build configuration,
   CI configuration, and dependency updates that do not alter user-visible
   behavior.
1. A scope MUST NOT be provided. The character immediately following the type
   MUST be either `!` or `:`.
1. A description MUST immediately follow the colon and space after the
   type/`!` prefix. The description is a short summary of the code changes,
   e.g., _fix: array parsing issue when multiple spaces were contained in string_.
1. A longer commit body MAY be provided after the short description, providing
   additional contextual information about the code changes. The body MUST
   begin one blank line after the description.
1. A commit body is free-form and MAY consist of any number of newline
   separated paragraphs.
1. One or more footers MAY be provided one blank line after the body. Each
   footer MUST consist of a word token, followed by either a `:<space>` or
   `<space>#` separator, followed by a string value (this is inspired by the
   [git trailer convention](https://git-scm.com/docs/git-interpret-trailers)).
1. A footer's token MUST use `-` in place of whitespace characters, e.g.,
   `Acked-by` (this helps differentiate the footer section from a
   multi-paragraph body). An exception is made for `BREAKING CHANGE`, which
   MAY also be used as a token.
1. A footer's value MAY contain spaces and newlines, and parsing MUST terminate
   when the next valid footer token/separator pair is observed.
1. Breaking changes MUST be indicated by appending `!` immediately before the
   `:` in the type prefix, e.g., `feat!: drop support for Node 6`.
1. A `BREAKING CHANGE:` footer MAY be included to describe the breaking change
   in detail. If it is included, `!` MUST also be present in the type prefix.
   A `BREAKING CHANGE:` footer MUST NOT appear in a commit whose type prefix
   does not contain `!`.
1. `BREAKING CHANGE` MUST be uppercase when used as a footer token.
   `BREAKING-CHANGE` MUST be synonymous with `BREAKING CHANGE`.
1. The type MUST be lowercase. The description, body, and footer values MAY
   use any casing.
1. A commit SHOULD contain changes of only one type. When a set of changes
   would require more than one type, it SHOULD be split into multiple commits.
   When splitting is not practical, the type with the greatest Semantic
   Versioning impact MUST be chosen, in the order `feat` > `fix` > `chore`.
1. Conventional Commits Minimal is a subset of Conventional Commits 1.0.0. A
   commit message that conforms to Conventional Commits Minimal MUST also
   conform to Conventional Commits 1.0.0.

## Why Use Conventional Commits Minimal

Conventional Commits is the most widely used commit message convention, but
two of its features cause hesitation on almost every commit:

* **Open-ended types.** The specification allows any type. Recommended sets
  such as `build`, `ci`, `docs`, `style`, `refactor`, `perf`, and `test` still
  leave gaps, and every gap forces a decision: add another type, or force the
  change into a category that does not quite fit. Over time the type list
  grows, and its meaning drifts between contributors.
* **Optional scopes.** There is no guidance on when to add a scope or how to
  name one. In practice this produces an unplanned, inconsistent collection of
  scopes that nobody maintains.

Conventional Commits Minimal removes both sources of hesitation:

* There are exactly three types, and they map one-to-one onto the Semantic
  Versioning outcomes that a maintainer actually needs to know:
  `feat` → MINOR, `fix` → PATCH, `chore` → no release. Choosing a type
  becomes a single question: _what does this change mean to a user?_
* Scopes are removed entirely. Most projects do not need them, and those that
  do are better served by a dedicated tool than by ad-hoc parentheses in a
  commit subject.

Because the result is a strict subset of Conventional Commits 1.0.0, it works
with every tool built for Conventional Commits: automated versioning, commit
linters, and structured history exploration continue to function without
changes.

## FAQ

### Which type do I use for documentation, tests, refactoring, or CI changes?

`chore`. None of these changes alter behavior that a user of the project can
observe. The distinction that matters in Conventional Commits Minimal is not
_what kind of file changed_ but _whether a user notices_.

### Does a `chore` commit ever trigger a release?

No. A `chore` commit has no Semantic Versioning impact. If a change that you
were about to label `chore` actually alters user-visible behavior, it is not a
`chore`; it is a `feat`, a `fix`, or a breaking change.

### I updated a dependency. Is that `chore` or `fix`?

It depends on the effect, not on the mechanism. If the update is routine
maintenance with no user-visible effect, use `chore`. If the update fixes a bug
that users could observe, use `fix`. If it adds a user-visible capability, use
`feat`. If it changes behavior in an incompatible way, add `!`.

### What about performance improvements?

If users can observe the difference (faster responses, lower memory use, a
previously failing workload now succeeding), use `fix`. Otherwise use `chore`.

### Are the types in the commit title uppercase or lowercase?

Lowercase only. `Feat:` and `FIX:` are not valid.

### What do I do if the commit conforms to more than one of the commit types?

Go back and make multiple commits whenever possible. If splitting is not
practical, pick the type with the greatest Semantic Versioning impact:
`feat` over `fix`, and `fix` over `chore`.

### Can I still use a scope for a monorepo?

No. Scopes are not part of Conventional Commits Minimal. If your project needs
per-package classification, derive it from the changed paths with tooling
rather than from the commit subject.

### Can I use `BREAKING CHANGE:` without `!`?

No. `!` is the single source of truth for breaking changes in the subject
line, so it is always visible in a one-line log. The `BREAKING CHANGE:` footer
is optional additional detail and is only valid when `!` is present.

### Does this work with existing Conventional Commits tooling?

Yes. Every valid Conventional Commits Minimal message is also a valid
Conventional Commits 1.0.0 message. Tools such as commitlint,
semantic-release, and release-please parse it as they would any other
Conventional Commit, with `feat`, `fix`, and `!` having their usual meaning.

### What do I do if I accidentally use the wrong commit type?

Prior to merging or releasing the mistake, we recommend using `git rebase -i`
to edit the commit history. After release, the cleanup will be different
according to what tools and processes you use.

### Do all my contributors need to use Conventional Commits Minimal?

No. If you use a squash based workflow on Git, lead maintainers can clean up
the commit messages as they are merged, adding no workload to casual
committers.

### How should I deal with commit messages in the initial development phase?

We recommend that you proceed as if you've already released the product.
Typically _somebody_, even if it's your fellow software developers, is using
your software. They'll want to know what's fixed, what breaks, etc.

## Tooling

* [`hooks/`](./hooks/README.md) — a `commit-msg` hook that validates messages
  against this specification, available as POSIX `sh` and PowerShell scripts.
* [`skills/`](./skills/README.md) — an Agent Skill that teaches AI coding
  agents to write commit messages that follow this specification.

## License

[MIT](./LICENSE)
