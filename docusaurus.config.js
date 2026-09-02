// @ts-check
import { themes as prismThemes } from 'prism-react-renderer';

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'MHM Currency Switcher',
  tagline: 'Multi-currency for WooCommerce that survives a page cache',
  favicon: 'img/favicon.ico',

  future: { v4: true },

  url: 'https://MaxHandMade.github.io',
  baseUrl: '/mhm-currency-switcher-docs/',

  organizationName: 'MaxHandMade',
  projectName: 'mhm-currency-switcher-docs',

  onBrokenLinks: 'throw',
  markdown: {
    mermaid: true,
    hooks: { onBrokenMarkdownLinks: 'throw' },
  },

  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'tr'],
    localeConfigs: {
      en: { label: 'English', htmlLang: 'en-US' },
      tr: { label: 'Türkçe', htmlLang: 'tr-TR' },
    },
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
          routeBasePath: 'docs',
        },
        blog: false,
        theme: { customCss: './src/css/custom.css' },
      }),
    ],
  ],

  themeConfig: {
    navbar: {
      title: 'MHM Currency Switcher',
      items: [
        { type: 'docSidebar', sidebarId: 'docsSidebar', position: 'left', label: 'Docs' },
        { type: 'localeDropdown', position: 'right' },
        {
          href: 'https://github.com/MaxHandMade/mhm-currency-switcher',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Documentation',
          items: [
            { label: 'Installation', to: '/docs/installation' },
            { label: 'Placing the switcher', to: '/docs/placing-the-switcher' },
            { label: 'REST API', to: '/docs/rest-api' },
          ],
        },
        {
          title: 'Reference',
          items: [
            { label: 'FAQ', to: '/docs/faq' },
            { label: 'Known limits', to: '/docs/known-limits' },
            { label: 'CSS classes', to: '/docs/css' },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub Repository',
              href: 'https://github.com/MaxHandMade/mhm-currency-switcher',
            },
            {
              label: 'Report an Issue',
              href: 'https://github.com/MaxHandMade/mhm-currency-switcher/issues',
            },
            {
              label: 'Official Website',
              href: 'https://wpalemi.com/currency-switcher/',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} MaxHandMade. GPL-2.0-or-later.`,
    },
    prism: { theme: prismThemes.github, darkTheme: prismThemes.dracula },
  },

  themes: ['@docusaurus/theme-mermaid'],
  plugins: [
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      // indexBlog defaults to true (validateOptions.js), so the plugin scans
      // blog/ and warns twice per build — once per locale — for a directory
      // that cannot exist: the preset above sets `blog: false`. Flip this back
      // to true in the same change that creates the blog (Faz B, Şerit 6);
      // leaving it false with a blog present would silently drop release posts
      // out of search.
      { hashed: true, language: ['en', 'tr'], indexBlog: false },
    ],
    [
      require.resolve('@docusaurus/plugin-client-redirects'),
      /** @type {import('@docusaurus/plugin-client-redirects').Options} */
      ({
        // The Turkish-filename-derived slugs (kurulum, yerlestirme, ...)
        // were the live URLs from this site's first deploy (2026-07-31)
        // until the slug rename on this branch (English slugs in every
        // locale). sitemap.xml has been live since day one, so ten pages x
        // two locales = twenty already-bookmarked/crawled URLs would 404 the
        // moment this branch ships, without this plugin.
        //
        // `from` paths below are locale-NEUTRAL ('/docs/...', never
        // '/tr/docs/...'). `docusaurus build` runs one full build pass per
        // locale (root build/ for en, build/tr/ for tr) and this plugin
        // re-resolves against whichever locale is current in each pass, so
        // a bare '/docs/kurulum' becomes a redirect stub at BOTH
        // build/docs/kurulum/ and build/tr/docs/kurulum/. Verified against
        // the actual built output, not assumed — see redirects-report.md.
        // A '/tr/docs/kurulum' entry would be wrong: in the tr pass it
        // would resolve to /tr/tr/docs/kurulum, a path nobody requests.
        redirects: [
          { to: '/docs/installation', from: '/docs/kurulum' },
          { to: '/docs/placing-the-switcher', from: '/docs/yerlestirme' },
          { to: '/docs/managing-currencies', from: '/docs/para-birimleri' },
          { to: '/docs/display-options', from: '/docs/goruntuleme' },
          { to: '/docs/advanced-settings', from: '/docs/gelismis' },
          { to: '/docs/fixed-prices', from: '/docs/sabit-fiyat' },
          { to: '/docs/currency-detection', from: '/docs/algilama' },
          { to: '/docs/currency-conversion', from: '/docs/donusturme' },
          { to: '/docs/faq', from: '/docs/sss' },
          { to: '/docs/known-limits', from: '/docs/bilinen-sinirlar' },
        ],
      }),
    ],
  ],
};

export default config;
