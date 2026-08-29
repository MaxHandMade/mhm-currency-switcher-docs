#!/usr/bin/env bash
# Does the anchor still name the latest published release?
#
# 🔴 The anchor is a TAG. `gh release view` returns a tag; a SHA anchor would
#    never match, go permanently red, and train everyone to ignore the alarm.
#
# 🔴 A failed `gh` call must NOT read as "no drift". Network trouble that exits
#    0 kills this gate silently.
#
# Exit: 0 in sync · 1 drifted · 2 could not measure

set -uo pipefail

REPO="${REPO:-MaxHandMade/mhm-currency-switcher}"
REF_FILE="${REF_FILE:-plugin-ref.txt}"

[ -f "$REF_FILE" ] || { echo "ERROR: $REF_FILE missing" >&2; exit 2; }
ANCHOR="$(tr -d '[:space:]' < "$REF_FILE")"
[ -n "$ANCHOR" ] || { echo "ERROR: $REF_FILE is empty" >&2; exit 2; }

command -v gh >/dev/null || { echo "ERROR: gh not found" >&2; exit 2; }

if ! LATEST="$(gh release view --repo "$REPO" --json tagName -q .tagName 2>&1)"; then
  echo "ERROR: could not read the latest release — NOT the same as 'no drift'." >&2
  echo "$LATEST" >&2
  exit 2
fi
[ -n "$LATEST" ] || { echo "ERROR: empty tag from gh" >&2; exit 2; }

echo "→ Anchor: $ANCHOR · latest published release: $LATEST"
[ "$ANCHOR" = "$LATEST" ] && { echo "✅ In sync."; exit 0; }
echo "⚠️  DRIFT: the documentation describes $ANCHOR while $LATEST is published."
exit 1
