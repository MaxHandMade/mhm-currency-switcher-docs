#!/usr/bin/env bash
# Internal link verifier for the Docusaurus build output.
#
# Earlier versions of this script only inspected hrefs that already started
# with the baseUrl prefix (/mhm-currency-switcher-docs/), and resolved them
# against `build/` directly. That double-blind missed JSX <a href="/docs/...">
# links that are perfectly fine in a "cd build" preview but 404 in production
# (because GitHub Pages serves the site under /mhm-currency-switcher-docs/,
# not /).
#
# This version simulates production layout instead:
#   1. Stages the build under <staging>/mhm-currency-switcher-docs/  (same
#      path as the live site).
#   2. Walks every rendered .html file and extracts EVERY href that starts
#      with "/" (any internal absolute link, prefixed or not).
#   3. Resolves each href against the staging root. A bare /docs/... link
#      now correctly fails because there is no /docs/ at the staging root —
#      only /mhm-currency-switcher-docs/docs/... exists.
#
# Usage:
#   bash scripts/check-links.sh             # uses ./build
#   BUILD_DIR=path/to/build bash scripts/check-links.sh

set -euo pipefail

BUILD_DIR="${BUILD_DIR:-build}"
BASE_URL_SEGMENT="mhm-currency-switcher-docs"

if [ ! -d "$BUILD_DIR" ]; then
  echo "ERROR: build directory not found at '$BUILD_DIR'. Run 'npm run build' first." >&2
  exit 2
fi

# Stage the build the way GitHub Pages serves it: under /<repo-name>/.
STAGING="$(mktemp -d)"
trap 'rm -rf "$STAGING"' EXIT
cp -r "$BUILD_DIR" "$STAGING/$BASE_URL_SEGMENT"

cd "$STAGING"

# Collect every internal href (starts with "/") from every rendered HTML page.
# Strip query strings and fragments before resolving on disk.
#
# The href="..." pattern alone is not enough here: this site builds with
# Docusaurus 3.10.2 (the rentiva-docs reference builds with 3.9.2), and its
# HTML minifier drops the quotes around attribute values that contain no
# spaces, emitting href=/mhm-currency-switcher-docs/tr/ instead of
# href="/mhm-currency-switcher-docs/tr/". A quoted-only pattern matched zero
# hrefs against a real build of this site (verified before changing this
# line), so the quote is now optional. Re-run against the rentiva-docs build
# found the same 734 hrefs before and after this change, so the widening is
# additive, not a behavior change for the reference site.
mapfile -t hrefs < <(
  grep -hroE 'href="?/[^ ">#?]*' "$BASE_URL_SEGMENT" 2>/dev/null \
    | sed -E 's/^href="?//' \
    | sort -u
)

if [ "${#hrefs[@]}" -eq 0 ]; then
  echo "WARNING: no internal hrefs found under $BUILD_DIR. Did the build succeed?" >&2
  exit 2
fi

fail_count=0
pass_count=0
missing_prefix_count=0

for href in "${hrefs[@]}"; do
  [ -z "$href" ] && continue

  # Strip the leading '/' so we can resolve against the staging root.
  rel="${href#/}"
  rel="${rel%/}"

  if [ -f "$rel" ] || [ -f "$rel.html" ] || [ -f "$rel/index.html" ]; then
    pass_count=$((pass_count + 1))
  else
    fail_count=$((fail_count + 1))
    # Diagnose the most common cause: missing baseUrl prefix.
    if [[ "$href" != /$BASE_URL_SEGMENT/* ]]; then
      missing_prefix_count=$((missing_prefix_count + 1))
      echo "BROKEN [missing baseUrl prefix]: $href"
      echo "       fix: use <Link to=\"$href\"> (auto-prefixes) or absolute /$BASE_URL_SEGMENT$href"
    else
      echo "BROKEN [no such file]: $href  →  tried: $rel, $rel.html, $rel/index.html"
    fi
  fi
done

echo ""
echo "Internal link check: ${pass_count} OK, ${fail_count} broken (out of ${#hrefs[@]} unique hrefs)"
if [ "$missing_prefix_count" -gt 0 ]; then
  echo "  → ${missing_prefix_count} of those are JSX <a href> elements missing the baseUrl prefix."
  echo "    Use the Docusaurus <Link> component or <a href={useBaseUrl('/path')}> instead."
fi

[ "$fail_count" -gt 0 ] && exit 1
exit 0
