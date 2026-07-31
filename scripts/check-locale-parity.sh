#!/usr/bin/env bash
# Locale parity for the Turkish translation.
#
# Docusaurus falls back to the source locale silently, so "the build is green"
# says nothing about whether Turkish content exists. This asserts five things
# the build cannot:
#
#   1. every English doc has a Turkish file, and vice versa (recursive)
#   2. i18n/tr/code.json exists, has no message that is empty/whitespace-only
#      for ANY key, and is not identical to English for the keys that must
#      differ
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

# Scratch space for the generated English baseline and node's stderr. Never
# written under i18n/: this repo's .gitignore whitelists i18n/** (`!i18n/`,
# `!i18n/**`), so anything left there is one careless `git add` away from
# being committed. Removed on every exit path, including the non-zero exits
# this script takes most of the time — that's the common case for a gate.
SCRATCH="$(mktemp -d)"
cleanup() {
  rm -rf "$SCRATCH"
  # Safety net only: the code below moves/deletes i18n/en immediately after
  # generating it, so this should normally find nothing. It exists in case
  # the script is interrupted between generation and that cleanup line.
  if [ "${WE_GENERATED_EN:-0}" = "1" ] && [ -d "i18n/en" ]; then
    rm -rf "i18n/en"
  fi
}
trap cleanup EXIT

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

# --- 2. code.json present, no empty messages, actually translated ------
#
# Two checks live here, independent of each other:
#
#   (a) no message is empty or whitespace-only, for EVERY key. An empty
#       string is never a legitimate translation, no matter which key it's
#       on — this is not limited to MUST_TRANSLATE below.
#
#   (b) for MUST_TRANSLATE keys specifically, the Turkish message must not
#       be byte-identical to the English one. An earlier draft asserted only
#       "no empty message values" for this half and nothing else. That could
#       almost never fire: `docusaurus write-translations` fills every
#       message with the ENGLISH source text, so a completely untranslated
#       code.json has no empty values at all and sailed through. Comparing
#       against the English baseline is what actually distinguishes
#       translated from not, for the keys where the two languages must
#       differ.
#
# MUST_TRANSLATE lists keys whose Turkish text cannot legitimately equal the
# English. Proper nouns ("GitHub", the product name) are deliberately absent —
# they are identical in both languages and flagging them would be noise.
MUST_TRANSLATE='theme.SearchBar.label theme.docs.sidebar.collapseButtonTitle theme.NotFound.title'

if [ ! -f "$CODE_JSON" ]; then
  note "$CODE_JSON missing — the landing page and UI chrome will render in English under /tr/."
else
  EN_BASE="i18n/en/code.json"
  WE_GENERATED_EN=0
  if [ ! -f "$EN_BASE" ]; then
    npx docusaurus write-translations --locale en >/dev/null 2>&1 || true
    if [ -f "i18n/en/code.json" ]; then
      # Pull just the file we need out into scratch space, then delete the
      # whole generated i18n/en/ tree immediately — do not wait for the EXIT
      # trap. See the SCRATCH comment above for why it can't live under i18n/.
      WE_GENERATED_EN=1
      cp "i18n/en/code.json" "$SCRATCH/en-code.json"
      rm -rf "i18n/en"
      EN_BASE="$SCRATCH/en-code.json"
    fi
  fi
  if [ ! -f "$EN_BASE" ]; then
    note "could not produce an English code.json baseline; cannot tell translated from untranslated."
  else
    node_err_file="$SCRATCH/node-error.log"
    # `if identical=$(...); then` on purpose, not a bare assignment: a bare
    # `identical=$(node -e ...)` aborts the whole script under
    # `set -euo pipefail` the moment node exits non-zero (e.g. malformed
    # JSON in code.json from a bad merge), skipping assertions 3, 4 and 5
    # with no FAIL: line explaining why — just a stack trace and a red exit
    # code with no attribution. A command tested by `if` is exempt from
    # errexit, so this lets a parse failure be reported and the rest of the
    # gate still run.
    # Paths passed as argv and resolved with path.resolve(), not spliced into
    # the JS source as a string — EN_BASE can be an absolute scratch path
    # (see above), and a hardcoded "./" prefix in front of an absolute path
    # breaks require() outright.
    if identical=$(node -e '
      const path = require("path");
      const tr = require(path.resolve(process.argv[2]));
      const en = require(path.resolve(process.argv[3]));
      const must = process.argv[1].split(" ");
      const problems = [];
      let total = 0, matching = 0;
      for (const k of Object.keys(en)) {
        if (k === "@metadata") continue;
        const a = tr[k] && tr[k].message, b = en[k] && en[k].message;
        if (a === undefined) { problems.push("MISSING " + k); continue; }
        total++;
        if (typeof a === "string" && a.trim() === "") { problems.push("EMPTY " + k); }
        if (a === b) { matching++; if (must.includes(k)) problems.push("UNTRANSLATED " + k); }
      }
      process.stdout.write(problems.join("\n") + "\n---\n" + matching + "/" + total);
    ' "$MUST_TRANSLATE" "$CODE_JSON" "$EN_BASE" 2>"$node_err_file"); then
      problems="${identical%%$'\n'---$'\n'*}"
      ratio="${identical##*---$'\n'}"
      if [ -n "${problems//[[:space:]]/}" ]; then
        note "$CODE_JSON has translation problems:"
        echo "$problems" | sed 's/^/       /'
      fi
      echo "NOTE: $ratio code.json messages are still identical to English (proper nouns are expected here)." >&2
    else
      node_status=$?
      note "could not parse $CODE_JSON or the English baseline (node exited $node_status): $(tr '\n' ' ' <"$node_err_file" | cut -c1-300)"
    fi
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
    #
    # '<a[ >]', not '<a[^>]*' — the tag-name boundary matters: '<a[^>]*href='
    # also matches '<area href=…>' (an image-map element, not a link a
    # reader clicks in this page), since '[^>]*' doesn't require anything
    # between 'a' and the next character. Requiring a space or '>' right
    # after 'a' restricts the match to the <a> tag itself.
    grep -qE '<a[ >][^>]*href=[^ >]*/tr/' "$landing" \
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
