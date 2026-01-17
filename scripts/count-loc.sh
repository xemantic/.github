#!/bin/bash
set -e

# Analyzes lines of code across all xemantic repositories
# Outputs a markdown table to stdout
#
# Requires: gh (authenticated), jq, cloc, git
#
# Usage:
#   ./count-loc.sh              # uses default org 'xemantic'
#   ./count-loc.sh myorg        # uses specified org

ORG="${1:-xemantic}"

for cmd in gh jq cloc git; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "Error: $cmd is required but not installed" >&2
    exit 1
  fi
done

echo "Fetching repositories for $ORG..." >&2
REPOS=$(gh repo list "$ORG" --no-archived --source --visibility public --json name,defaultBranchRef --limit 1000)

if [[ -z "$REPOS" || "$REPOS" == "[]" ]]; then
  echo "Error: No repositories found or not authenticated" >&2
  exit 1
fi

WORK_DIR=$(mktemp -d)
trap "rm -rf $WORK_DIR" EXIT

echo "Cloning repositories..." >&2
cd "$WORK_DIR"

echo "$REPOS" | jq -r '.[] | "\(.name) \(.defaultBranchRef.name)"' | while read -r NAME BRANCH; do
  echo "  $NAME ($BRANCH)" >&2
  gh repo clone "$ORG/$NAME" -- --quiet --branch "$BRANCH" --single-branch 2>/dev/null || echo "  Failed to clone $NAME" >&2
done

echo "Running cloc analysis..." >&2
CLOC_JSON=$(cloc . --json)

# Output markdown table
echo "| Language | Files | Lines of Code |"
echo "|----------|------:|--------------:|"

echo "$CLOC_JSON" | jq -r '
  to_entries
  | map(select(.key != "header" and .key != "SUM"))
  | sort_by(-.value.code)
  | .[]
  | "| \(.key) | \(.value.nFiles) | \(.value.code) |"
'

TOTAL_FILES=$(echo "$CLOC_JSON" | jq '.SUM.nFiles // 0')
TOTAL_CODE=$(echo "$CLOC_JSON" | jq '.SUM.code // 0')
echo "| **Total** | **$TOTAL_FILES** | **$TOTAL_CODE** |"