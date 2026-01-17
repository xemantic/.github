# Xemantic .github Repository

This is the special `.github` repository for the [Xemantic](https://github.com/xemantic) GitHub organization.

## Contents

```
.github/
├── .github/workflows/
│   ├── code-statistics.yml  # Updates code stats in profile README
│   └── ...                  # Reusable workflow templates for other repos
├── profile/README.md        # Organization profile displayed on github.com/xemantic
├── scripts/
│   ├── count-loc.sh         # Clones repos and counts lines of code
│   └── update-stats.sh      # Updates profile README with statistics
└── README.md                # This file
```

## Code Statistics Workflow

The `code-statistics.yml` workflow runs:
- Weekly on Sundays at midnight UTC
- On push to main branch
- Via manual trigger

It clones all public non-fork repositories, counts lines of code using `cloc`, and updates the statistics table in `profile/README.md` between the `<!-- loc -->` markers.

### Languages Tracked

Kotlin, Java, JavaScript, TypeScript, JSX, Vue, PHP, C#