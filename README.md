# MHM Currency Switcher — Documentation

Source for <https://maxhandmade.github.io/mhm-currency-switcher-docs/>.

The plugin itself lives at
<https://github.com/MaxHandMade/mhm-currency-switcher>.

## Local development

```bash
npm ci
npm start          # English, http://localhost:3110
npm run start:tr   # Turkish
```

## Gates

CI runs these on every push; they fail the build.

```bash
npm run build
npm run check:parity
npm run check:links
npm run check:external
```

`check:external` has one context-dependent rule. A bad status or a soft 404 is
always fatal — everywhere, with no opt-out. "Nobody answered, three times" is
fatal too **except** on the push that follows a merge, where those same links
passed on the pull request minutes earlier and a network failure can only be a
third party's outage; blocking there leaves merged work unpublished. The script
fails closed, so a local run is strict. Link rot is caught by the daily strict
run in `.github/workflows/release-drift.yml` (workflow **Drift watch**, job
`external-links`), not by the deploy path.

The two claim gates need the plugin tree checked out at `plugin-ref.txt` into
`.plugin-src/`, which `deploy.yml` does for itself:

```bash
git -C ../mhm-currency-switcher archive "$(cat plugin-ref.txt)" | tar -x -C .plugin-src
bash scripts/check-plugin-claims.sh       # do the docs teach anything the source lacks?
bash scripts/check-external-services.sh   # is every endpoint the plugin calls documented?
```

## Report — not a gate

```bash
npm run report:coverage
```

Asks the opposite question the gates ask: *what shipped that no page mentions?*
It is deliberately **not** wired into CI. Absence is a judgement — some surface
is internal on purpose — and a hard gate on it produces either documented
internals or a growing pardon list. Run it when `plugin-ref.txt` moves, read the
output, decide. It prints the surfaces it does **not** measure; read that part too.

Licence: GPL-2.0-or-later.
