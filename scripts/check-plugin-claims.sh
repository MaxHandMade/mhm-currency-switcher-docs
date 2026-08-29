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

echo "TODO: scan half arrives in Task 3" >&2
exit 2
