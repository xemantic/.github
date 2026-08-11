# Xemantic .github Repository

This is the special `.github` repository for the [Xemantic](https://github.com/xemantic) GitHub organization.
It supplies the public organization profile, the contributor documents that apply to every Xemantic project,
and the reusable GitHub Actions workflows that the other repositories call.

## Contents

### Organization profile

- [profile/README.md](profile/README.md) — rendered publicly on [github.com/xemantic](https://github.com/xemantic)
- [profile/ABOUT.md](profile/ABOUT.md) — about page; the region between the `<!-- loc -->` markers is generated, see [Code statistics](#code-statistics)

### Contributor documents

These apply to every repository in the organization, not just this one.

- [CONTRIBUTING.md](CONTRIBUTING.md) — how to contribute
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — adapted from [Contributor Covenant 3.0](https://www.contributor-covenant.org/version/3/0/)
- [CLA.md](CLA.md) — Individual Contributor License Agreement, signed via [CLA Assistant](https://cla-assistant.io/)

### Reusable workflows

Called from other repositories — see [Using the reusable workflows](#using-the-reusable-workflows).

- [build-gradle.yml](.github/workflows/build-gradle.yml) — configurable Gradle build, publishing and release
- [claude-code.yml](.github/workflows/claude-code.yml) — responds to `@claude` mentions in issues and pull requests
- [claude-code-review.yml](.github/workflows/claude-code-review.yml) — automated Claude review of pull requests

### Workflows local to this repository

- [code-statistics.yml](.github/workflows/code-statistics.yml) — updates the statistics in `profile/ABOUT.md`
- [action-version-updater.yml](.github/workflows/action-version-updater.yml) — keeps action versions current
- [claude.yml](.github/workflows/claude.yml) — applies `claude-code.yml` to this repository
- [review.yml](.github/workflows/review.yml) — applies `claude-code-review.yml` to this repository

The last two are the smallest working examples of calling the reusable workflows.

### Scripts

- [scripts/count-loc.sh](scripts/count-loc.sh) — clones the organization's repositories and counts lines of code
- [scripts/update-stats.sh](scripts/update-stats.sh) — writes those counts into `profile/ABOUT.md`

## Using the reusable workflows

Reference them by path and ref, and pass `secrets: inherit`:

```yaml
jobs:
  build:
    uses: xemantic/.github/.github/workflows/build-gradle.yml@main
    secrets: inherit
    with:
      gradle_args: build
```

`secrets: inherit` is required rather than optional.
`build-gradle.yml` reads publishing, signing and announcement secrets directly from the calling repository's context
instead of declaring them as workflow inputs,
so without `inherit` they resolve to empty strings and the build fails late, during publication.

### Build Gradle

| Input | Required | Default | Purpose |
| --- | --- | --- | --- |
| `gradle_args` | yes | — | Arguments passed to `./gradlew`, for example `build` or `build publishToMavenCentral` |
| `java_distribution` | no | org variable `DEFAULT_JAVA_DISTRIBUTION` | Java distribution |
| `java_version` | no | org variable `DEFAULT_JAVA_VERSION` | Java version |
| `runs_on` | no | `ubuntu-latest` | Runner |
| `env` | no | — | Plain environment variables, one `KEY=value` per line |
| `maven_central` | no | `false` | Supply Maven Central credentials and signing key |
| `jreleaser` | no | `false` | Supply JReleaser announcement credentials |
| `anthropic` | no | `false` | Supply `ANTHROPIC_API_KEY` |
| `moonshot` | no | `false` | Supply Moonshot API credentials |
| `artifact_path` | no | — | Glob of build artifact(s) to upload; nothing is uploaded when empty |
| `artifact_name` | no | `build-artifact` | Name of the uploaded artifact |

The single declared secret is `env_secrets`, taking secret environment variables as `KEY=value` lines.
The boolean inputs above gate additional secrets that are read from the caller's context:

- `maven_central` — `MAVEN_CENTRAL_USERNAME`, `MAVEN_CENTRAL_PASSWORD`, `SIGNING_KEY`, `SIGNING_PASSWORD`
- `jreleaser` — `DISCORD_ANNOUNCEMENTS_WEBHOOK`, `LINKEDIN_ACCESS_TOKEN`, `LINKEDIN_OWNER`, `BLUESKY_PASSWORD`, and the `BLUESKY_HOST` and `BLUESKY_HANDLE` variables
- `anthropic` — `ANTHROPIC_API_KEY`
- `moonshot` — `MOONSHOT_API_KEY`, and the `MOONSHOT_API_BASE_URL` and `MOONSHOT_DEFAULT_MODEL` variables

The workflow file is authoritative; consult it when in doubt.

### Claude Code

Requires the `CLAUDE_CODE_OAUTH_TOKEN` secret.
The calling workflow supplies the triggers, and the job runs only when the comment, issue title or issue body contains `@claude`.
See [claude.yml](.github/workflows/claude.yml) for the triggers this repository uses.

### Claude Code Review

Requires the `CLAUDE_CODE_OAUTH_TOKEN` secret.
Reviews pull requests for code quality, bugs, performance, security and test coverage,
using the calling repository's `CLAUDE.md` for conventions, and posts the review as a pull request comment.
See [review.yml](.github/workflows/review.yml).

## Repository automation

### Code statistics

[code-statistics.yml](.github/workflows/code-statistics.yml) runs weekly on Sundays at midnight UTC, or on manual trigger.
It clones every public non-fork repository in the organization,
counts lines of code with `cloc`, which detects languages automatically,
and rewrites the table between the `<!-- loc -->` markers in `profile/ABOUT.md`.

Because `main` is protected, the workflow opens or updates a pull request rather than pushing directly.
Hand-edits inside the markers are overwritten on the next run.

### Action version updater

[action-version-updater.yml](.github/workflows/action-version-updater.yml) runs daily at midnight UTC, or on manual trigger,
and raises updates for outdated action versions.

## Secrets and variables

| Name | Kind | Used by |
| --- | --- | --- |
| `WORKFLOW_SECRET` | secret | `code-statistics.yml` and `action-version-updater.yml`; needs the `workflow` scope, and permission to open pull requests |
| `CLAUDE_CODE_OAUTH_TOKEN` | secret | `claude-code.yml` and `claude-code-review.yml` |
| `DEFAULT_JAVA_DISTRIBUTION` | variable | `build-gradle.yml`, when `java_distribution` is omitted |
| `DEFAULT_JAVA_VERSION` | variable | `build-gradle.yml`, when `java_version` is omitted |

Repositories calling `build-gradle.yml` with `maven_central`, `jreleaser`, `anthropic` or `moonshot` enabled
additionally need the secrets and variables listed under [Build Gradle](#build-gradle).
