#!/usr/bin/env bash
# Locale parity for the Turkish translation.
#
# Docusaurus falls back to the source locale silently, so "the build is green"
# says nothing about whether Turkish content exists. This asserts five things
# the build cannot:
#
#   1. every English doc has a Turkish file, and vice versa (recursive)
#   2. i18n/tr/code.json exists and has no empty "message" values
#   3. the theme-classic translation files exist
#   4. the built site links to /tr/ from the landing page
#   5. the English landing page is not a stub
#
# LIMIT, deliberately recorded: an existing-but-untranslated Turkish file (an
# English copy) passes. This proves a Turkish FILE exists for every page, not
# that its content is Turkish.
#
# Usage: bash scripts/check-locale-parity.sh   (BUILD_DIR overridable)

set -euo pipefail

EN_DIR="docs"
TR_DIR="i18n/tr/docusaurus-plugin-content-docs/current"
THEME_DIR="i18n/tr/docusaurus-theme-classic"
CODE_JSON="i18n/tr/code.json"
BUILD_DIR="${BUILD_DIR:-build}"

fail=0
note() { echo "FAIL: $*"; fail=$((fail + 1)); }

# --- 1. two-way, recursive file-list diff -------------------------------
if [ ! -d "$EN_DIR" ]; then
  echo "ERROR: $EN_DIR not found — run from the repository root." >&2
  exit 2
fi
if [ ! -d "$TR_DIR" ]; then
  note "$TR_DIR does not exist. Turkish docs are entirely absent."
else
  en_list="$(cd "$EN_DIR" && find . -type f \( -name '*.md' -o -name '*.mdx' \) | sort)"
  tr_list="$(cd "$TR_DIR" && find . -type f \( -name '*.md' -o -name '*.mdx' \) | sort)"

  while IFS= read -r f; do
    [ -z "$f" ] && continue
    grep -qxF "$f" <<<"$tr_list" || note "no Turkish file for $EN_DIR/${f#./}"
  done <<<"$en_list"

  while IFS= read -r f; do
    [ -z "$f" ] && continue
    grep -qxF "$f" <<<"$en_list" || note "Turkish file has no English counterpart (it will never be built): $TR_DIR/${f#./}"
  done <<<"$tr_list"
fi

# --- 2. code.json present and actually translated ----------------------
#
# An earlier draft asserted "no empty message values". That assertion could
# almost never fire: `docusaurus write-translations` fills every message with
# the ENGLISH source text, so a completely untranslated code.json has no empty
# values at all and sailed through. This compares against the English baseline
# instead, which is the thing that distinguishes translated from not.
#
# MUST_TRANSLATE lists keys whose Turkish text cannot legitimately equal the
# English. Proper nouns ("GitHub", the product name) are deliberately absent —
# they are identical in both languages and flagging them would be noise.
MUST_TRANSLATE='theme.SearchBar.label theme.docs.sidebar.collapseButtonTitle theme.NotFound.title'

if [ ! -f "$CODE_JSON" ]; then
  note "$CODE_JSON missing — the landing page and UI chrome will render in English under /tr/."
else
  EN_BASE="i18n/en/code.json"
  if [ ! -f "$EN_BASE" ]; then
    npx docusaurus write-translations --locale en >/dev/null 2>&1 || true
  fi
  if [ ! -f "$EN_BASE" ]; then
    note "could not produce $EN_BASE; cannot tell translated from untranslated."
  else
    identical=$(node -e '
      const tr = require("./'"$CODE_JSON"'");
      const en = require("./'"$EN_BASE"'");
      const must = process.argv[1].split(" ");
      const same = [];
      let total = 0, matching = 0;
      for (const k of Object.keys(en)) {
        if (k === "@metadata") continue;
        const a = tr[k] && tr[k].message, b = en[k] && en[k].message;
        if (a === undefined) { same.push("MISSING " + k); continue; }
        total++;
        if (a === b) { matching++; if (must.includes(k)) same.push("UNTRANSLATED " + k); }
      }
      process.stdout.write(same.join("\n") + "\n---\n" + matching + "/" + total);
    ' "$MUST_TRANSLATE")
    problems="${identical%%$'\n'---$'\n'*}"
    ratio="${identical##*---$'\n'}"
    if [ -n "${problems//[[:space:]]/}" ]; then
      note "$CODE_JSON is not translated where it must be:"
      echo "$problems" | sed 's/^/       /'
    fi
    echo "NOTE: $ratio code.json messages are still identical to English (proper nouns are expected here)." >&2
  fi
fi

# --- 3. theme translations present -------------------------------------
if [ ! -d "$THEME_DIR" ] || [ -z "$(find "$THEME_DIR" -name '*.json' -print -quit)" ]; then
  note "$THEME_DIR has no translation files — navbar and footer stay English under /tr/."
fi

# --- 4 & 5. built-output assertions ------------------------------------
#
# An earlier draft asserted "at least N bytes" as the not-a-stub check. That
# was picked blind and it was vacuous: a page whose entire body is
# <Redirect to="/docs/intro" /> builds to 3681 bytes of framework boilerplate
# and sailed past a 1200-byte floor. Bytes do not distinguish a page from a
# redirect. The navbar does — a redirect renders none — and the navbar is also
# what carries the locale dropdown, so this is the same fact assertion 5 needs.
if [ -d "$BUILD_DIR" ]; then
  landing="$BUILD_DIR/index.html"
  if [ ! -f "$landing" ]; then
    note "$landing not found — cannot check the landing page."
  else
    # Quote-agnostic on purpose. Docusaurus minifies the built HTML and strips
    # quotes from attribute values containing no spaces, so the real markup is
    # href=/mhm-currency-switcher-docs/tr/ — an `href="…"` pattern matches ZERO
    # times on a perfectly correct build. Measured on the first real build:
    # quoted pattern 0 matches, unquoted 2.
    grep -qE 'class=[^ >]*navbar' "$landing" \
      || note "the English landing page renders no navbar — it is a redirect or a stub, not a page."
    # Anchored to an <a ...> element on purpose. Docusaurus always emits
    # <link data-rh=true rel=alternate href=…/tr/ hreflang=tr-TR /> in <head>
    # for SEO regardless of navbar content, so a bare 'href=…/tr/' pattern
    # matches that tag even with the locale dropdown removed from
    # navbar.items and never fails. Measured: with the dropdown removed,
    # the <link rel=alternate> is the ONLY remaining /tr/ href in the page.
    # Requiring the match start at '<a' targets the clickable link a reader
    # can actually use, which is what disappears when the dropdown is cut.
    grep -qE '<a[^>]*href=[^ >]*/tr/' "$landing" \
      || note "the English landing page does not link to /tr/. Turkish readers cannot find their language."
  fi
else
  echo "NOTE: $BUILD_DIR not found; skipping built-output assertions. Run 'npm run build' first to check all five." >&2
fi

echo ""
if [ "$fail" -gt 0 ]; then
  echo "Locale parity: $fail problem(s)."
  exit 1
fi
echo "Locale parity: OK"
exit 0
