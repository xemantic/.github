#!/bin/bash
set -e

# Updates profile/README.md with language statistics from stdin
# Reads a markdown table from stdin and inserts it between markers
#
# Usage: ./count-loc.sh | ./update-stats.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
README="$SCRIPT_DIR/../profile/README.md"

if [[ ! -f "$README" ]]; then
  echo "Error: $README not found" >&2
  exit 1
fi

if ! grep -q "<!-- loc -->" "$README"; then
  echo "Error: README.md does not contain <!-- loc --> marker" >&2
  exit 1
fi

# Read markdown table from stdin into temp file
TABLE_FILE=$(mktemp)
cat > "$TABLE_FILE"

# Build new README:
# 1. Everything up to and including <!-- loc --> marker
# 2. The table
# 3. <!-- /loc --> marker and everything after

{
  # Part 1: up to and including start marker
  sed -n '1,/<!-- loc -->/p' "$README"

  # Part 2: the table
  cat "$TABLE_FILE"

  # Part 3: end marker and everything after
  sed -n '/<!-- \/loc -->/,$p' "$README"
} > "$README.tmp"

mv "$README.tmp" "$README"
rm -f "$TABLE_FILE"

echo "Updated $README"