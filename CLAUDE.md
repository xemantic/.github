# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the `.github` special repository for the Xemantic GitHub organization. It serves two purposes:

1. **Organization Profile**: The `profile/README.md` file is displayed on the organization's GitHub page (github.com/xemantic)
2. **Code Statistics Automation**: A GitHub Actions workflow that counts lines of code across all Xemantic repositories and updates the README

## Repository Structure

- `profile/README.md` - Organization profile displayed on GitHub
- `profile/ABOUT.md` - Detailed about page with code statistics
- `README.md` - Repository documentation
- `.github/workflows/code-statistics.yml` - GitHub Actions workflow for LOC counting
- `scripts/count-loc.sh` - Script that clones repos and counts lines of code
- `scripts/update-stats.sh` - Script that updates profile ABOUT.md with statistics

## Workflow Details

The `code-statistics.yml` workflow:
- Runs weekly on Sundays at midnight UTC, on push to main, or via manual trigger
- Clones all non-fork public repos from the xemantic organization
- Uses `cloc` to count lines of code
- Updates `profile/ABOUT.md` between `<!-- loc -->` and `<!-- /loc -->` markers

## Secrets Required

- `WORKFLOW_SECRET` - Used for fetching organization repositories and pushing updates