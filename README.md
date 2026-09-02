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
