#!/usr/bin/env bash
# Slug parity between English and Turkish doc pages.
#
# WHY THIS EXISTS
# ----------------
# This branch established a house rule: every locale gets an ENGLISH URL
# slug, even when the source filename is Turkish (docs/kurulum.md renders
# at /docs/installation, not /docs/kurulum). Before this rename, the rule
# was enforced by hand, and that is exactly how the original defect
# survived: a Turkish filename (kurulum.md) silently drove the English
# locale's URL because nothing compared the two sides' `slug:` frontmatter.
# check-locale-parity.sh checks that EN/TR files exist in pairs and that
# theme/UI strings are translated — it never looks at `slug:` at all. This
# script closes that specific gap, and only that gap.
#
# WHAT IT ASSERTS, per EN/TR page pair (same relative filename under
# docs/ and i18n/tr/docusaurus-plugin-content-docs/current/):
#
#   1. If EITHER side declares `slug:` in its YAML frontmatter, BOTH must
#      declare it, and the values must be byte-identical.
#   2. If NEITHER side declares one, that is only allowed when the shared
#      filename is already locale-neutral (English/technical, e.g. "css",
#      "rest-api") — otherwise Docusaurus's filename-derived route puts the
#      Turkish word straight into the URL again, silently.
#
# "Locale-neutral" is a maintained ALLOWLIST (LOCALE_NEUTRAL_FILENAMES
# below), not a character-set heuristic. An ASCII Turkish word like
# "kurulum" or "sss" is indistinguishable from an English one by charset
# alone — "no slug needed here" has to be a reviewed, named decision per
# file, the same way MUST_TRANSLATE in check-locale-parity.sh is an
# explicit list rather than an inferred one.
#
# A pair missing its counterpart entirely (Turkish file absent, or Turkish
# file with no English source) is check-locale-parity.sh's assertion #1,
# not this script's — this script only ever compares pairs where both
# files already exist, and reports how many that was.
#
# Usage: bash scripts/check-slug-parity.sh

set -euo pipefail

EN_DIR="docs"
TR_DIR="i18n/tr/docusaurus-plugin-content-docs/current"

LOCALE_NEUTRAL_FILENAMES=(
  "intro.md"
  "css.md"
  "rest-api.md"
  "wp-cli.md"
)

is_locale_neutral() {
  local f="$1" n
  for n in "${LOCALE_NEUTRAL_FILENAMES[@]}"; do
    [ "$f" = "$n" ] && return 0
  done
  return 1
}

# Prints the `slug:` value from a file's YAML frontmatter (the text between
# the first two "---" lines), or nothing if the key is absent. Anchored to
# the frontmatter block on purpose, so a line like "slug:" appearing in a
# code fence or prose body is never mistaken for the real key.
extract_slug() {
  awk '
    NR==1 && $0=="---" { infm=1; next }
    infm && $0=="---" { exit }
    infm && $0 ~ /^slug:[[:space:]]*/ {
      v=$0
      sub(/^slug:[[:space:]]*/, "", v)
      gsub(/^["'"'"']|["'"'"']$/, "", v)
      sub(/[[:space:]]+$/, "", v)
      print v
      exit
    }
  ' "$1"
}

if [ ! -d "$EN_DIR" ]; then
  echo "ERROR: $EN_DIR not found — run from the repository root." >&2
  exit 2
fi
if [ ! -d "$TR_DIR" ]; then
  echo "ERROR: $TR_DIR not found — run from the repository root." >&2
  exit 2
fi

fail=0
checked=0
note() { echo "FAIL: $*"; fail=$((fail + 1)); }

en_list="$(cd "$EN_DIR" && find . -type f \( -name '*.md' -o -name '*.mdx' \) | sed 's#^\./##' | sort)"

while IFS= read -r f; do
  [ -z "$f" ] && continue
  en_file="$EN_DIR/$f"
  tr_file="$TR_DIR/$f"
  # A missing Turkish counterpart is check-locale-parity.sh's finding, not
  # this script's — nothing to compare slugs against.
  [ -f "$tr_file" ] || continue

  checked=$((checked + 1))
  en_slug="$(extract_slug "$en_file")"
  tr_slug="$(extract_slug "$tr_file")"

  if [ -n "$en_slug" ] || [ -n "$tr_slug" ]; then
    if [ "$en_slug" != "$tr_slug" ]; then
      note "slug mismatch for $f: EN='${en_slug:-<none>}' ($en_file) vs TR='${tr_slug:-<none>}' ($tr_file)"
    fi
  else
    if ! is_locale_neutral "$f"; then
      note "$f declares no slug: on either side, and \"$f\" is not on the locale-neutral allowlist in $0 — the Turkish filename would silently drive the URL. Add matching slug: frontmatter to both $en_file and $tr_file, or add \"$f\" to LOCALE_NEUTRAL_FILENAMES if the bare filename is genuinely English/neutral."
    fi
  fi
done <<<"$en_list"

echo ""
echo "Slug parity: $checked pair(s) checked."
if [ "$fail" -gt 0 ]; then
  echo "Slug parity: $fail problem(s)."
  exit 1
fi
echo "Slug parity: OK"
exit 0
