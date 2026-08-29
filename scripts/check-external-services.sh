#!/usr/bin/env bash
# Reverse probe: does the documentation name every endpoint the plugin calls?
#
# The token gate answers "is what docs teach in the source?". This answers the
# other direction — a source that grew a second rate provider while the docs
# kept describing one is invisible to the first question.
#
# 🔴 Endpoints are the BACKTICKED urls under "== External services ==".
#    The plain ones are terms-of-service and documentation links; requiring the
#    currency page to mention woocommerce.com would be a dead gate.
#
# Exit: 0 clean · 1 an endpoint host is undocumented · 2 scope missing

set -uo pipefail

PLUGIN_SRC="${PLUGIN_SRC:-.plugin-src}"
PAGES=(docs/para-birimleri.md i18n/tr/docusaurus-plugin-content-docs/current/para-birimleri.md)

README="$PLUGIN_SRC/readme.txt"
[ -f "$README" ] || { echo "ERROR: $README not found" >&2; exit 2; }
for p in "${PAGES[@]}"; do
  [ -f "$p" ] || { echo "ERROR: rate-source page missing: $p" >&2; exit 2; }
done

mapfile -t HOSTS < <(
  awk '/^== External services ==/{f=1} f&&/^== /&&!/External services/{f=0} f' "$README" \
    | grep -oE '`https?://[^`]+`' \
    | sed -E 's#`https?://##; s#[/`].*##' \
    | sort -u
)
[ "${#HOSTS[@]}" -gt 0 ] || { echo "ERROR: no backticked endpoints found — has the readme section moved?" >&2; exit 2; }

miss=0
for h in "${HOSTS[@]}"; do
  for p in "${PAGES[@]}"; do
    if ! grep -qF -- "$h" "$p"; then
      echo "$p	$h	ENDPOINT NOT DOCUMENTED"
      miss=$((miss+1))
    fi
  done
done

echo "→ Endpoint hosts declared by readme: ${#HOSTS[@]} (${HOSTS[*]})"
echo "→ Pages checked: ${#PAGES[@]}"
echo "→ Undocumented: $miss"
[ "$miss" -eq 0 ] && { echo "✅ Clean."; exit 0; }
exit 1
