# CLAUDE.md

This file captures only what cannot be inferred from the codebase itself.

## Rules for editing this file

Both developers and AI agents are expected to add entries as they encounter surprises.

- **Add an entry** when you encounter something unexpected: a build quirk, a non-obvious constraint, a dependency gotcha, or any behavior that would surprise the next agent or developer.
- **Add an entry** when a developer flags an anti-pattern produced by AI — describe the anti-pattern and the preferred alternative.
- **Do not** add codebase overviews, directory listings, or anything discoverable by reading the source.
- Keep entries concise: one line per lesson, grouped under a heading if a theme emerges.

## Conventions

### Markdown authoring

Markdown files use [semantic line breaks](https://sembr.org/):
break a line after a sentence,
and optionally at clause boundaries within a long sentence,
so that diffs stay meaningful and reviewable.

There is no column width limit —
never reflow or hard-wrap a paragraph to fit some character count.

`CODE_OF_CONDUCT.md` and `CLA.md` are exempt.
They are kept diffable against their upstream or original wording,
so their existing line structure must be preserved rather than reflowed.

## Known gotchas

- `main` is protected by a repository *ruleset*, not classic branch protection,
  so `gh api repos/xemantic/.github/branches/main/protection` reports `Branch not protected` while direct pushes still fail —
  automation must open a pull request instead, which is why `code-statistics.yml` calls `gh pr create`.
- The reusable workflows here are called from roughly a dozen other repositories in the organization,
  so renaming an input, secret, or job is a breaking change outside this repo —
  search the org for `xemantic/.github/.github/workflows` before changing one.
- The region between the `<!-- loc -->` markers in `profile/ABOUT.md` is regenerated weekly by `code-statistics.yml`; hand-edits there are overwritten.
- `profile/README.md` renders publicly on github.com/xemantic, so edits are immediately visible org-wide rather than scoped to this repository.
- Action versions are managed by Dependabot because it preserves floating major tags like `@v7`;
  `saadmk11/github-actions-version-updater` cannot semver-parse such tags,
  which made it bypass its own `release_types: major` filter and pin actions to exact patch releases.

## Anti-patterns to avoid

- Do not add content to this file that is already discoverable by reading the source or build scripts — that inflates context without adding signal, reducing AI agent task success rates (see [arxiv 2602.11988](https://arxiv.org/abs/2602.11988)).
- Do not reword `CODE_OF_CONDUCT.md`.
  It is adapted from Contributor Covenant 3.0 and deliberately kept close to upstream,
  so prose "improvements" create silent divergence — the few deviations that exist are intentional.
- Do not lowercase `You` / `Your` in `CLA.md` — they are defined terms introduced in section 1, not typos.
