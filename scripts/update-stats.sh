#!/bin/bash
set -e

# Updates profile markdown files with language statistics from stdin
# Reads a markdown table from stdin and inserts it between markers
#
# Usage: ./count-loc.sh | ./update-stats.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="$SCRIPT_DIR/../profile"

FILES=(
  "$PROFILE_DIR/ABOUT.md"
)

# Read markdown table from stdin into temp file
TABLE_FILE=$(mktemp)
cat > "$TABLE_FILE"

# Extract total stars count embedded by count-loc.sh
TOTAL_STARS=$(grep '<!-- total-stars:' "$TABLE_FILE" | sed 's/.*<!-- total-stars: \([0-9]*\) -->.*/\1/' || true)

# Remove stars line from table so only the LOC table remains
grep -v '<!-- total-stars:' "$TABLE_FILE" > "$TABLE_FILE.clean"
mv "$TABLE_FILE.clean" "$TABLE_FILE"

for FILE in "${FILES[@]}"; do
  if [[ ! -f "$FILE" ]]; then
    echo "Warning: $FILE not found, skipping" >&2
    continue
  fi

  if ! grep -q "<!-- loc -->" "$FILE"; then
    echo "Warning: $FILE does not contain <!-- loc --> marker, skipping" >&2
    continue
  fi

  # Build new file:
  # 1. Everything up to and including <!-- loc --> marker
  # 2. The table
  # 3. <!-- /loc --> marker and everything after

  {
    # Part 1: up to and including start marker
    sed -n '1,/<!-- loc -->/p' "$FILE"

    # Part 2: the table
    cat "$TABLE_FILE"

    # Part 3: end marker and everything after
    sed -n '/<!-- \/loc -->/,$p' "$FILE"
  } > "$FILE.tmp"

  mv "$FILE.tmp" "$FILE"
  echo "Updated $FILE (LOC section)"

  # Update stars section if marker exists and total stars was found
  if [[ -n "$TOTAL_STARS" ]] && grep -q "<!-- stars -->" "$FILE"; then
    {
      # Part 1: up to and including start marker
      sed -n '1,/<!-- stars -->/p' "$FILE"

      # Part 2: the stars count
      echo "Stars across all Xemantic open source repositories: **$TOTAL_STARS**"

      # Part 3: end marker and everything after
      sed -n '/<!-- \/stars -->/,$p' "$FILE"
    } > "$FILE.tmp"

    mv "$FILE.tmp" "$FILE"
    echo "Updated $FILE (stars section)"
  fi
done

rm -f "$TABLE_FILE"