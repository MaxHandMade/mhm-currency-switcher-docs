#!/usr/bin/env bash
# Absence probe: what did the plugin ship that no page mentions?
#
# The two claim gates both ask DOCS -> SOURCE ("is what we teach real?"). That
# direction cannot see a feature that shipped and was never written about. Both
# times this repository was bitten, the missing thing was invisible to every
# green check:
#   · 2.1.0 added two `cache-notice/snooze-*` routes; nothing noticed.
#   · `mhmcs_should_convert` has existed for releases; no page names it.
#
# 🔴 THIS IS NOT A CI GATE, DELIBERATELY, AND MUST NOT BECOME ONE.
#    Absence is a judgement: some surface is internal on purpose. A hard gate
#    on this question produces exactly two bad outcomes — documenting internals
#    to get green, or an ever-growing pardon list that hides the real answer.
#    House rule: wp-knowledge/standards/wporg-submission-guidelines.md, KANUN 0
#    ("yokluk kusurları için ayrı araç yaz … CI kapısı olmasın").
#    Run it when the anchor moves. Read the output. Decide.
#
# 🔴 IT PRINTS WHAT IT CANNOT SEE. A coverage number that hides its own scope
#    reads as "everything is documented" when it means "everything I looked at".
#
# Usage:
#   bash scripts/check-docs-coverage.sh              # report
#   bash scripts/check-docs-coverage.sh --self-test  # extractors only
#
# Exit: 0 fully covered · 1 gaps found (informational) · 2 scope missing
#       · 3 probe broken

set -uo pipefail

PLUGIN_SRC="${PLUGIN_SRC:-.plugin-src}"
DOC_DIRS=(docs i18n)

[ -d "$PLUGIN_SRC" ] || { echo "ERROR: plugin tree not found at $PLUGIN_SRC — see scripts/check-plugin-claims.sh for how it is created" >&2; exit 2; }
for d in "${DOC_DIRS[@]}"; do
  [ -d "$d" ] || { echo "ERROR: documentation directory missing: $d" >&2; exit 2; }
done

# ─── Extractors ──────────────────────────────────────────────────────────────
# 🔴 Every list is DERIVED from the tree. A hand-written inventory only ever
#    contains what its author already remembered — which is the same blind spot
#    that produced the gap this tool exists to find.

extract_shortcodes() {
  grep -rhoE "add_shortcode\(\s*'[a-z_]+'" "$PLUGIN_SRC/src" 2>/dev/null \
    | grep -oE "'[a-z_]+'" | tr -d "'" | sort -u
}

extract_cli() {
  # WP-CLI turns a command class's public methods into subcommands, `_` -> `-`.
  [ -f "$PLUGIN_SRC/src/CLI/Commands.php" ] || return 0
  grep -oE "public function [a-z_]+\(" "$PLUGIN_SRC/src/CLI/Commands.php" 2>/dev/null \
    | sed 's/public function //; s/($//; s/(//' | grep -v '^__' | tr '_' '-' | sort -u
}

extract_hooks() {
  # -A2: a long apply_filters() call wraps, and the hook name is not always on
  # the same line as the function call.
  grep -rhA2 -E "apply_filters\(|do_action\(" "$PLUGIN_SRC/src" "$PLUGIN_SRC/mhm-currency-switcher.php" 2>/dev/null \
    | grep -oE "'mhmcs?_[a-z_]+'" | tr -d "'" | sort -u
}

extract_routes() {
  grep -rhoE "'/[a-z-]+(/[a-z-]+)*'" \
      "$PLUGIN_SRC/src/Admin/RestAPI.php" \
      "$PLUGIN_SRC/src/Core/CacheCompatDiagnostic.php" \
      "$PLUGIN_SRC/src/Rest/ConvertController.php" 2>/dev/null \
    | tr -d "'" | sort -u
}

# ─── Locales ─────────────────────────────────────────────────────────────────
# 🔴 "Mentioned somewhere" IS NOT COVERAGE, and the mutation test is what said
#    so: renaming the token in docs/rest-api.md changed nothing, because the
#    Turkish copy still carried it. A member documented in one locale and
#    missing from the other would have reported as covered — which is the exact
#    shape of the two defects found on 2026-09-02 (the English FAQ was missing
#    a rate-update interval, then a whole cache/sync sentence, that the Turkish
#    FAQ had). Ask each locale separately.
LOCALE_NAME=(en)
LOCALE_ROOT=(docs)
for d in i18n/*/docusaurus-plugin-content-docs/current; do
  [ -d "$d" ] || continue
  loc="${d#i18n/}"; loc="${loc%%/*}"
  LOCALE_NAME+=("$loc"); LOCALE_ROOT+=("$d")
done

documented_in() {   # $1 = locale root · $2 = member · 0 when that locale names it
  grep -rqF -- "$2" "$1" 2>/dev/null
}

documented() {   # $1 = member · 0 when ANY locale names it
  local i
  for i in "${!LOCALE_ROOT[@]}"; do
    documented_in "${LOCALE_ROOT[$i]}" "$1" && return 0
  done
  return 1
}

missing_locales() {   # $1 = member · stdout: locales that do NOT name it
  local i
  for i in "${!LOCALE_ROOT[@]}"; do
    documented_in "${LOCALE_ROOT[$i]}" "$1" || printf '%s ' "${LOCALE_NAME[$i]}"
  done
}

# ─── The probe sins its own blind spot first ─────────────────────────────────
# 🔴 An extractor that silently returns nothing reports PERFECT coverage. That
#    is the failure mode of every reverse probe: zero members, zero gaps, green.
#    Each extractor must find at least one member, or this tool is lying.
self_test() {
  local rc=0 n
  for pair in "shortcodes:$(extract_shortcodes | grep -c .)" \
              "cli:$(extract_cli | grep -c .)" \
              "hooks:$(extract_hooks | grep -c .)" \
              "routes:$(extract_routes | grep -c .)"; do
    n="${pair##*:}"
    if [ "$n" -eq 0 ]; then
      echo "  ❌ EXTRACTOR FOUND NOTHING: ${pair%%:*} — the registration shape moved." >&2
      rc=1
    fi
  done
  # And `documented()` must be able to answer NO. A grep that always matches
  # (an over-broad pattern, a stray path) would mark every member covered.
  if documented "mhmcs_this_token_must_not_exist_anywhere"; then
    echo "  ❌ documented() matched a token that cannot exist — the search is too wide." >&2
    rc=1
  fi
  [ $rc -eq 0 ] && echo "  probe: 4/4 extractors non-empty · negative lookup correctly returns NO"
  return $rc
}

echo "→ Probing its own blind spot first…"
if ! self_test; then echo "⛔ PROBE BROKEN — no report was produced." >&2; exit 3; fi
[ "${1:-}" = "--self-test" ] && { echo "✅ Probe sound."; exit 0; }

# ─── Report ──────────────────────────────────────────────────────────────────
total=0; missing=0; partial=0

report_surface() {   # $1 = label · stdin = members
  local label="$1" m gaps
  while IFS= read -r m; do
    [ -n "$m" ] || continue
    total=$((total+1))
    gaps="$(missing_locales "$m")"
    gaps="${gaps% }"
    [ -n "$gaps" ] || continue
    if documented "$m"; then
      echo "$label	$m	MISSING FROM: $gaps (present in another locale)"
      partial=$((partial+1))
    else
      echo "$label	$m	NOT MENTIONED IN ANY PAGE"
      missing=$((missing+1))
    fi
  done
}

report_surface "shortcode" < <(extract_shortcodes)
report_surface "wp-cli"    < <(extract_cli)
report_surface "hook"      < <(extract_hooks)
report_surface "rest"      < <(extract_routes)

echo "→ Plugin tree measured: $PLUGIN_SRC"
echo "→ Locales asked separately: ${LOCALE_NAME[*]} (${#LOCALE_ROOT[@]})"
echo "→ Public surface members found: $total · unmentioned anywhere: $missing · missing from one locale: $partial"

# 🔴 Say what was NOT asked. Coverage over four surfaces is not coverage.
cat <<'BLIND'
→ Out of scope — this tool does NOT measure:
    · CSS classes — css.md documents front-end classes only, by design, and a
      whole-tree class sweep would be mostly admin-panel noise.
    · Hook and route ARGUMENTS. It sees that a name is mentioned somewhere; it
      cannot tell whether the contract around it is described or correct. The
      `mhmcs_fallback_rates_url` source argument was documented nowhere while
      the hook name itself appeared on two pages.
    · Option names, cookie names, database storage, admin screen labels.
    · Whether a mention is ACCURATE. That is the other direction — the two
      claim gates — and neither direction can see a sentence that is merely
      out of date in prose.
BLIND

if [ "$missing" -eq 0 ] && [ "$partial" -eq 0 ]; then
  echo "✅ Every extracted surface member is named in every locale."
  exit 0
fi
echo "⚠️  $missing shipped without any mention · $partial named in one locale only."
echo "   This is a prompt to decide, not a failure. Some surface is internal on purpose."
exit 1
