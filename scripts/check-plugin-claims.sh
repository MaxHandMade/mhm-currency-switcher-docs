#!/usr/bin/env bash
# Docs-to-source claim probe.
#
# The question this answers: does any page TEACH a token that the plugin tree
# at plugin-ref.txt does not contain?
#
# 🔴 DIRECTION: docs propose, source rules. A gate that starts from a
#    hand-written pattern list only ever sees what its author thought of.
#    Tokens are EXTRACTED from the documentation, then asked of the source.
#
# 🔴 THE PROBE SINS ITS OWN BLIND SPOT FIRST. A negative tripping means the
#    probe is TOO WIDE; a positive escaping means it is BLIND. Either: exit 3.
#
# Usage:
#   bash scripts/check-plugin-claims.sh              # scan
#   bash scripts/check-plugin-claims.sh --self-test  # fixtures only
#
# Exit: 0 clean · 1 claims not found in source · 2 scope missing · 3 probe broken

set -uo pipefail

# ─── Candidate text ──────────────────────────────────────────────────────────
# Only code context counts. Prose that happens to contain "currency switcher"
# is not a claim about an identifier. Three shapes carry code:
#   · fenced code blocks       (measured: css.md lines 15·25·35·45 are bare
#                               selectors inside a fence — a backtick-only
#                               extractor is blind to every one of them)
#   · inline backtick spans
#   · markdown table cells     (the placement tables name shortcodes)
candidate_text() {
  awk '
    BEGIN { infence = 0 }
    /^[[:space:]]*```/ { infence = 1 - infence; next }
    infence { print; next }
    /^[[:space:]]*\|/ { print; next }
    {
      line = $0
      while (match(line, /`[^`]+`/)) {
        print substr(line, RSTART + 1, RLENGTH - 2)
        line = substr(line, RSTART + RLENGTH)
      }
    }
  '
}

# ─── Shapes ──────────────────────────────────────────────────────────────────
# What a "claim about the plugin" looks like once it is in code context.
SHAPE_PREFIXED='(mhmcs|mhm-cs|mhm_cs)[A-Za-z0-9_-]*'
SHAPE_LEGACY='mhm_currency[A-Za-z0-9_]*'
# 🔴 There is NO separate shortcode shape, deliberately. `[mhmcs_switcher]`
#    is already caught by SHAPE_PREFIXED — the bracket adds nothing. A shape
#    like '\[[a-z][a-z0-9_]*\]' would additionally match ordinary markdown
#    links: in a table cell stripped of backticks, `[kurulum](/docs/kurulum)`
#    reads as a shortcode named "kurulum". One mechanism, no false positives.
SHAPE_CLI='wp[[:space:]]+mhmcs[[:space:]]+[a-z][a-z-]*'
SHAPE_REST='/mhmcs/v[0-9]+(/[A-Za-z0-9_-]+)+'
SHAPE_HOST='[a-z0-9-]+(\.[a-z0-9-]+)*\.(com|dev|org|eu|net|io)'
SHAPES_RE="$SHAPE_REST|$SHAPE_CLI|$SHAPE_PREFIXED|$SHAPE_LEGACY|$SHAPE_HOST"

# ─── Hosts that are never endpoints ──────────────────────────────────────────
# Documentation and placeholder hosts. Not "findings we tolerate": asking the
# plugin source to contain `yourstore.com` would be asking the wrong question.
KEEP_RE='github\.com|yourstore\.com|example\.com|example\.org|wordpress\.org|woocommerce\.com|maxhandmade\.github\.io|gnu\.org'

extract_tokens() {   # stdin: candidate text · stdout: one token per line
  grep -oE "$SHAPES_RE" 2>/dev/null | grep -vE "^($KEEP_RE)$" || true
}

scan_text() {   # stdin: markdown (one or many lines) · stdout: tokens
  candidate_text | extract_tokens
}

self_test() {
  local rc=0 pc=0 pt=0 nt=0 ntrip=0 t
  # 🔴 A new SHAPE_* needs a fixture reachable ONLY through that shape. Twice
  #    now, a fixture caught by a different rule left its own rule unexercised
  #    and silently green (the table rule; the two-label host).
  # Every positive is a claim the probe MUST surface for judging.
  local -a POS=(
    '```
.mhmcs-price { color: red; }
```'
    '| [mhmcs_switcher] | Places the dropdown |'
    'The legacy filter was `mhm_currency_switcher_output`.'
    'Call `/mhmcs/v1/rates` to read the table.'
    'Run `wp mhmcs rates-sync` from the command line.'
    'Rates come from `api.exchangerate-api.com`.'
    'Rates come from `frankfurter.dev` when the primary is down.'
  )
  # Every negative is text the probe must LEAVE ALONE.
  local -a NEG=(
    'The currency switcher keeps working behind a page cache.'
    'See [readme.txt on GitHub](https://github.com/MaxHandMade/mhm-currency-switcher).'
    'Point your browser at `https://yourstore.com/wp-json/`.'
    'Each currency can carry its own fee and rounding step.'
    '| [kurulum](/docs/kurulum) | Installation guide |'
  )
  for t in "${POS[@]}"; do
    pt=$((pt+1))
    if [ -n "$(printf '%s\n' "$t" | scan_text)" ]; then pc=$((pc+1)); else
      echo "  ❌ POSITIVE ESCAPED: ${t:0:60}" >&2; rc=1; fi
  done
  for t in "${NEG[@]}"; do
    nt=$((nt+1))
    if [ -n "$(printf '%s\n' "$t" | scan_text)" ]; then
      ntrip=$((ntrip+1))
      echo "  ❌ NEGATIVE TRIPPED (probe too wide): ${t:0:60} -> $(printf '%s\n' "$t" | scan_text | tr '\n' ' ')" >&2
      rc=1; fi
  done
  echo "  probe: positive $pc/$pt caught · negative $ntrip/$nt tripping (0 expected)"
  return $rc
}

echo "→ Probing its own blind spot first…"
if ! self_test; then echo "⛔ PROBE BROKEN — no scan was performed." >&2; exit 3; fi
[ "${1:-}" = "--self-test" ] && { echo "✅ Probe sound."; exit 0; }

# ─── Source side ─────────────────────────────────────────────────────────────
PLUGIN_SRC="${PLUGIN_SRC:-.plugin-src}"
ALLOW_FILE="${ALLOW_FILE:-scripts/plugin-claims-allowlist.tsv}"
REF_FILE="${REF_FILE:-plugin-ref.txt}"

[ -d "$PLUGIN_SRC" ] || { echo "ERROR: plugin tree not found at $PLUGIN_SRC" >&2; exit 2; }
[ -f "$REF_FILE" ]   || { echo "ERROR: $REF_FILE missing (is it whitelisted in .gitignore?)" >&2; exit 2; }
REF="$(tr -d '[:space:]' < "$REF_FILE")"
[ -n "$REF" ] || { echo "ERROR: $REF_FILE is empty" >&2; exit 2; }

# Registered REST routes, in full. Built once, matched exactly.
# 🔴 Exact segments, never substrings: /rates was removed while /rates/sync
#    lives, and a substring search finds the dead one inside the living one.
#
# 🔴 THE EXTRACTOR WAS MEASURED AGAINST v2.0.0, NOT ASSUMED. Two registration
#    shapes exist and a naive quoted-string grep sees NEITHER:
#      (1) The call spans four lines — `register_rest_route(` / namespace /
#          '/rates/sync' / array(…). A single-line pattern matches nothing.
#      (2) ConvertController registers through a class constant
#          (`self::ROUTE`, defined as '/convert' at ConvertController.php:84).
#          No literal-argument search can reach it — 1 of v2.0.0's 6 routes.
#    An empty route list is the dangerous failure: it turns every REST token
#    in the docs into a finding, and the gate looks busy while being useless.
registered_routes() {
  {
    grep -rhA5 "register_rest_route(" "$PLUGIN_SRC/src" 2>/dev/null \
      | grep -oE "'/[A-Za-z0-9_/-]*'"
    grep -rhoE "const[[:space:]]+[A-Z_]*ROUTE[A-Z_]*[[:space:]]*=[[:space:]]*'/[A-Za-z0-9_/-]*'" \
      "$PLUGIN_SRC/src" 2>/dev/null | grep -oE "'/[A-Za-z0-9_/-]*'"
  } | tr -d "'" | sed -E 's#\(\?P<[^>]+>[^)]*\)#*#g' | sort -u
}

ROUTES="$(registered_routes)"
ROUTE_COUNT=$(printf '%s\n' "$ROUTES" | grep -c .)
# Measured floor: v2.0.0 registers 6 (/convert /currencies /rates
# /rates/preview /rates/sync /settings). Falling under 4 means the
# registration shape moved and the list can no longer be trusted.
[ "$ROUTE_COUNT" -ge 4 ] || {
  echo "ERROR: only $ROUTE_COUNT REST route(s) extracted from $PLUGIN_SRC — the registration shape moved." >&2
  exit 2
}

source_has() {   # $1 = token · 0 when the source backs the claim
  local tok="$1"
  case "$tok" in
    /mhmcs/v*/*)
      # /mhmcs/v1/rates/sync  ->  /rates/sync
      local route="/${tok#/*/*/}"
      printf '%s\n' "$ROUTES" | grep -qxF -- "$route"
      ;;
    "wp "*|"wp	"*)
      # `wp mhmcs rates-sync` -> the subcommand name must exist in source
      local sub="${tok##* }"
      grep -rqF -- "$sub" "$PLUGIN_SRC/src" 2>/dev/null
      ;;
    *)
      grep -rqF -- "$tok" "$PLUGIN_SRC/src" "$PLUGIN_SRC/assets" \
        "$PLUGIN_SRC/admin-app/src" "$PLUGIN_SRC/readme.txt" \
        "$PLUGIN_SRC/mhm-currency-switcher.php" 2>/dev/null
      ;;
  esac
}

# ─── Scope ───────────────────────────────────────────────────────────────────
# 🔴 blog/ is excluded on purpose and the count is PRINTED: a dated release
#    post is a record of what that version shipped. (Faz A has no blog yet;
#    the rule is written now so Faz B does not have to rediscover it.)
IN_SCOPE_RE='^(docs/|i18n/[^/]+/docusaurus-plugin-content-docs/|src/|README\.md)'
EXCLUDED_RE='^(blog/|i18n/[^/]+/docusaurus-plugin-content-blog/)'

command -v git >/dev/null || { echo "ERROR: git not found" >&2; exit 2; }
mapfile -t ALL < <(git ls-files | grep -vE '^(build|node_modules)/')
[ "${#ALL[@]}" -gt 0 ] || { echo "ERROR: no tracked files — run from the repository root." >&2; exit 2; }

IN=(); EX=0
for f in "${ALL[@]}"; do
  if   [[ "$f" =~ $EXCLUDED_RE ]]; then EX=$((EX+1))
  elif [[ "$f" =~ $IN_SCOPE_RE ]]; then IN+=("$f"); fi
done
[ "${#IN[@]}" -gt 0 ] || { echo "ERROR: scope matched 0 files — the layout moved." >&2; exit 2; }

# ─── Deliberate mentions ─────────────────────────────────────────────────────
# An entry is a claim about ONE SENTENCE, not about a file: the third column is
# the anchor text. A page may name a removed endpoint on purpose, because the
# sentence is about its removal.
allow_program() {   # $1 = path · stdout: sed program blanking spared tokens
  [ -f "$ALLOW_FILE" ] || return 0
  awk -F'\t' -v p="$1" '!/^#/ && NF>=3 && $1==p { gsub(/[|]/, "\\|", $2); print "/" $3 "/ s|" $2 "||g" }' "$ALLOW_FILE"
}

# ─── Branch-link rule ────────────────────────────────────────────────────────
# A link into mhm-currency-switcher/(blob|raw)/<ref> must name the anchor.
# Sweeping the current 12 is not enough: tomorrow's page links to develop again
# and check:external stays green, because the URL resolves.
branch_link_hits() {   # $1 = path
  grep -oE "mhm-currency-switcher/(blob|raw)/[A-Za-z0-9._/-]+" "$1" 2>/dev/null \
    | awk -F'/' -v ref="$REF" '$3 != ref' || true
}

hits=0; files=0; skipped=0; occ=0; blinks=0
declare -A DISTINCT=()
for f in "${IN[@]}"; do
  prog="$(allow_program "$f")"
  if [ -n "$prog" ]; then
    before=$(candidate_text <"$f" | extract_tokens | wc -l)
    body="$(sed "$prog" <"$f")"
    after=$(printf '%s\n' "$body" | candidate_text | extract_tokens | wc -l)
    skipped=$((skipped + before - after))
  else
    body="$(cat "$f")"
  fi
  fhit=0
  while IFS= read -r tok; do
    [ -n "$tok" ] || continue
    occ=$((occ+1)); DISTINCT["$tok"]=1
    if ! source_has "$tok"; then
      hits=$((hits+1)); fhit=1
      printf '%s\t%s\tNOT IN %s\n' "$f" "$tok" "$REF"
    fi
  done < <(printf '%s\n' "$body" | candidate_text | extract_tokens | sort -u)
  while IFS= read -r bl; do
    [ -n "$bl" ] || continue
    blinks=$((blinks+1)); fhit=1
    printf '%s\t%s\tBRANCH LINK (anchor is %s)\n' "$f" "$bl" "$REF"
  done < <(branch_link_hits "$f")
  [ "$fhit" -eq 1 ] && files=$((files+1))
done

echo "→ Anchor: $REF · plugin tree: $PLUGIN_SRC · registered routes: $(printf '%s\n' "$ROUTES" | grep -c .)"
echo "→ Scope: ${#IN[@]} files scanned · $EX excluded (blog archive)"
echo "→ Tokens extracted: $occ occurrence(s) · ${#DISTINCT[@]} distinct"
echo "→ Deliberate mentions spared by $ALLOW_FILE: $skipped"
echo "→ Claims not backed by source: $hits · branch links off anchor: $blinks · in $files file(s)"
[ $((hits + blinks)) -eq 0 ] && { echo "✅ Clean."; exit 0; }
exit 1
