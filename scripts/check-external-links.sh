#!/usr/bin/env bash
# External link verifier for the authored source of this site.
#
# WHY THIS EXISTS
# ---------------
# scripts/check-links.sh only resolves hrefs that start with "/" — internal
# links, against the build output. Every external link was therefore
# unchecked, and one of them was dead on the live site for weeks: eleven
# pages linked to
#
#     https://wordpress.org/plugins/mhm-currency-switcher/
#
# for the canonical readme.txt, but the plugin is not published on
# WordPress.org yet. The English "FAQ" and "Known limits" pages consist of
# nothing but that pointer, so their content was effectively missing.
#
# THE BLIND SPOT THIS SCRIPT IS BUILT AROUND
# ------------------------------------------
# A naive checker asks "did the request end in 200?" and that is exactly
# what the dead link would have passed. WordPress.org answers an unknown
# plugin slug with 301 -> /plugins/search/<slug>/, and the search page
# returns a perfectly healthy 200. Status alone cannot see it.
#
# So this script compares the FINAL EFFECTIVE URL against the requested one.
# A redirect that only normalises (http -> https, adding or dropping a
# trailing slash, host case) is fine. A redirect that changes the PATH means
# the server sent us somewhere else because the thing we asked for is not
# there — a soft 404 — and that fails.
#
# WHAT IT SCANS
# -------------
# The authored markdown and JSX under docs/, i18n/, src/ and blog/, matching
# only real link syntax: markdown "](url)" and "href=url". Bare URLs printed
# inside code fences (https://siteadiniz.com/..., https://yourstore.com/...)
# are documentation examples for the reader's own site, are not links, and
# are correctly never requested. Scanning the source rather than build/ also
# keeps Docusaurus's own boilerplate links (docusaurus.io, the archived
# webplatform.github.io in its 404 bundle) out of scope without needing an
# exemption list — an exemption list is how a gate stops being a gate.
#
# docusaurus.config.js is scanned too, but only its "href:" entries — the
# navbar and footer links a visitor can actually click. Its "url:" field is
# the site's own identity, not a link, and combines with baseUrl to form the
# real address; requesting it on its own would fail for a reason that is not
# a defect. The first version of this script scanned only the content
# directories and reported "1 unique URL", silently missing the GitHub link
# in the config. Whenever this gate reports a count, compare it against
#     grep -rnoE '\]\(https?://|href="?https?://' --include='*.md' \
#          --include='*.jsx' --include='*.js' . | grep -v node_modules
# before trusting it. A checker that starts in the wrong place reports zero
# problems and is telling the truth about the place it looked.
#
# Usage:
#   bash scripts/check-external-links.sh

set -euo pipefail

SCAN_DIRS=()
for d in docs i18n src blog; do
  [ -d "$d" ] && SCAN_DIRS+=("$d")
done

if [ "${#SCAN_DIRS[@]}" -eq 0 ]; then
  echo "ERROR: none of docs/ i18n/ src/ blog/ found. Run from the repo root." >&2
  exit 2
fi

# Markdown "](https://...)", HTML/JSX 'href="https://..."', and the config's
# navbar/footer "href: 'https://...'" entries.
# Every grep here ends in "|| true". Under `set -e` a grep that matches
# nothing exits 1 and kills the whole group, so the FIRST pattern that found
# no hits would silently prevent the later ones from ever running. That is
# not hypothetical: while this script was being written the JSX href pattern
# matched nothing, the group died there, and the config scan below never
# executed — the gate cheerfully reported "1 unique URL" and a clean scan of
# a place it had never looked.
mapfile -t urls < <(
  {
    grep -rhoE '\]\(https?://[^) ]+\)' "${SCAN_DIRS[@]}" 2>/dev/null \
      | sed -E 's/^\]\(//; s/\)$//' || true
    grep -rhoE 'href="https?://[^"]+"' "${SCAN_DIRS[@]}" 2>/dev/null \
      | sed -E 's/^href="//; s/"$//' || true
    if [ -f docusaurus.config.js ]; then
      grep -hoE "href: *['\"]https?://[^'\"]+['\"]" docusaurus.config.js 2>/dev/null \
        | sed -E "s/^href: *['\"]//; s/['\"]\$//" || true
    fi
  } | sed -E 's/[.,;]+$//' | sort -u
)

if [ "${#urls[@]}" -eq 0 ]; then
  echo "WARNING: no external links found in ${SCAN_DIRS[*]}." >&2
  echo "         Either the site genuinely has none, or the patterns above stopped matching." >&2
  exit 2
fi

# Reduce a URL to host+path for comparison: drop scheme, lowercase the host,
# drop query and fragment, drop a trailing slash. What survives is the thing
# a soft 404 changes and a harmless normalisation does not.
canonical() {
  printf '%s' "$1" \
    | sed -E 's#^https?://##; s/[?#].*$//; s#/+$##' \
    | awk -F/ '{ $1 = tolower($1); OFS="/"; print }'
}

fail_count=0
pass_count=0

for url in "${urls[@]}"; do
  [ -z "$url" ] && continue

  result=""
  for attempt in 1 2 3; do
    # -L follow redirects, GET (some hosts refuse HEAD), body discarded.
    if result="$(curl -sS -L -o /dev/null \
                      --max-time 25 \
                      -A 'mhm-currency-switcher-docs link checker' \
                      -w '%{http_code} %{url_effective}' \
                      "$url" 2>/dev/null)"; then
      break
    fi
    result=""
    [ "$attempt" -lt 3 ] && sleep $((attempt * 2))
  done

  if [ -z "$result" ]; then
    fail_count=$((fail_count + 1))
    echo "UNREACHABLE: $url"
    echo "             three attempts failed at the network level (DNS, TLS or timeout)."
    continue
  fi

  code="${result%% *}"
  effective="${result#* }"

  if [ "$code" != "200" ]; then
    fail_count=$((fail_count + 1))
    echo "BROKEN [HTTP $code]: $url"
    continue
  fi

  want="$(canonical "$url")"
  got="$(canonical "$effective")"

  if [ "$want" != "$got" ]; then
    fail_count=$((fail_count + 1))
    echo "REDIRECTED AWAY [soft 404]: $url"
    echo "                            landed on: $effective"
    echo "                            The status is 200 but the server sent us to a"
    echo "                            different path, which is how a missing page is"
    echo "                            usually served. Point the link at something that"
    echo "                            exists, or remove it."
    continue
  fi

  pass_count=$((pass_count + 1))
done

echo ""
echo "External link check: ${pass_count} OK, ${fail_count} broken (out of ${#urls[@]} unique URLs)"

[ "$fail_count" -gt 0 ] && exit 1
exit 0
