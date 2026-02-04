# Xemantic .github Repository

This is the special `.github` repository for the [Xemantic](https://github.com/xemantic) GitHub organization.

## Contents

```
.github/
├── .github/workflows/
│   ├── action-version-updater.yml  # Keeps GitHub Action versions up to date
│   ├── build-gradle.yml            # Reusable Gradle build workflow
│   ├── claude-code-review.yml      # Reusable Claude Code PR review workflow
│   ├── claude-code.yml             # Reusable Claude Code integration workflow
│   ├── claude.yml                  # This repo's Claude Code workflow
│   ├── code-statistics.yml         # Updates code stats in profile ABOUT.md
│   └── review.yml                  # This repo's Claude Code review workflow
├── profile/
│   ├── README.md            # Organization profile displayed on github.com/xemantic
│   └── ABOUT.md             # Detailed about page with code statistics
├── scripts/
│   ├── count-loc.sh         # Clones repos and counts lines of code
│   └── update-stats.sh      # Updates profile ABOUT.md with statistics
└── README.md                # This file
```

## Workflows

This repository contains both local workflows (for this repository) and reusable workflows (templates for other Xemantic repositories).

### Local Workflows

#### Claude Code (`claude.yml`)

Responds to `@claude` mentions in this repository's issues and PR comments. Uses the reusable `claude-code.yml` workflow.

#### Claude Code Review (`review.yml`)

Automatically reviews pull requests in this repository. Uses the reusable `claude-code-review.yml` workflow.

### Reusable Workflows

#### Claude Code (`claude-code.yml`)

Reusable workflow for Claude Code integration. Responds to `@claude` mentions in:
- Issue comments
- PR comments and reviews
- Issue titles and bodies

**Required secrets:** `CLAUDE_CODE_OAUTH_TOKEN`

#### Claude Code Review (`claude-code-review.yml`)

Reusable workflow for automated PR code reviews by Claude. Reviews PRs for:
- Code quality and best practices
- Potential bugs or issues
- Performance and security concerns
- Test coverage

**Required secrets:** `CLAUDE_CODE_OAUTH_TOKEN`

#### Build Gradle (`build-gradle.yml`)

Reusable Gradle build workflow with configurable options:
- Custom Gradle arguments
- Java distribution and version selection
- Maven Central publishing support
- JReleaser announcement integration
- Anthropic API key injection

#### Code Statistics (`code-statistics.yml`)

Updates code statistics in `profile/ABOUT.md`. Runs:
- Weekly on Sundays at midnight UTC
- On push to main branch
- Via manual trigger

Clones all public non-fork repositories, counts lines of code using `cloc`, and updates the statistics table between `<!-- loc -->` markers.

Languages are automatically detected by `cloc`.

#### Action Version Updater (`action-version-updater.yml`)

Automatically updates GitHub Action versions. Runs weekly on Sundays.

**Required secrets:** `WORKFLOW_SECRET`

## Secrets Required

- `WORKFLOW_SECRET` - For fetching organization repositories and pushing updates
- `CLAUDE_CODE_OAUTH_TOKEN` - For Claude Code integration workflows