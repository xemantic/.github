# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the `.github` special repository for the Xemantic GitHub organization. It serves multiple purposes:

1. **Organization Profile**: The `profile/README.md` file is displayed on the organization's GitHub page (github.com/xemantic)
2. **Reusable Workflows**: Shared GitHub Actions workflows used across all Xemantic repositories
3. **Code Statistics Automation**: A workflow that counts lines of code across all Xemantic repositories

## Repository Structure

- `profile/README.md` - Organization profile displayed on GitHub
- `profile/ABOUT.md` - Detailed about page with code statistics
- `README.md` - Repository documentation
- `.github/workflows/` - Reusable workflow templates
  - `claude-code.yml` - Claude Code integration for issues and PRs
  - `claude-code-review.yml` - Automated Claude PR code reviews
  - `build-gradle.yml` - Reusable Gradle build workflow
  - `code-statistics.yml` - LOC counting workflow
  - `action-version-updater.yml` - Keeps action versions current
- `scripts/count-loc.sh` - Script that clones repos and counts lines of code
- `scripts/update-stats.sh` - Script that updates profile ABOUT.md with statistics

## Reusable Workflows

### Claude Code (`claude-code.yml`)
Responds to `@claude` mentions in issues and PRs. Grants write permissions for contents, PRs, and issues so Claude can make changes.

### Claude Code Review (`claude-code-review.yml`)
Automated PR reviews triggered on pull requests. Reviews code quality, bugs, performance, security, and test coverage.

### Build Gradle (`build-gradle.yml`)
Configurable Gradle build with support for:
- Custom Gradle arguments and Java version
- Maven Central publishing
- JReleaser announcements
- Anthropic API integration

### Code Statistics (`code-statistics.yml`)
- Runs weekly on Sundays at midnight UTC, on push to main, or via manual trigger
- Clones all non-fork public repos from the xemantic organization
- Uses `cloc` to count lines of code
- Updates `profile/ABOUT.md` between `<!-- loc -->` and `<!-- /loc -->` markers

## Secrets Required

- `WORKFLOW_SECRET` - For fetching organization repositories and pushing updates
- `CLAUDE_CODE_OAUTH_TOKEN` - For Claude Code integration workflows