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
      copyright: `Copyright © ${new Date().getFullYear()} MaxHandMade. GPL-2.0-or-later.`,
    },
    prism: { theme: prismThemes.github, darkTheme: prismThemes.dracula },
  },

  themes: ['@docusaurus/theme-mermaid'],
  plugins: [
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      { hashed: true, language: ['en', 'tr'] },
    ],
  ],
};

export default config;
