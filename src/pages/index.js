import React from 'react';
import clsx from 'clsx';
import Layout from '@theme/Layout';
import Link from '@docusaurus/Link';
import Heading from '@theme/Heading';
import Translate, { translate } from '@docusaurus/Translate';
import styles from './index.module.css';

const CARDS = [
  {
    img: 'img/shot-currencies.webp',
    alt: translate({
      id: 'home.card.currencies.alt',
      message:
        'The Manage Currencies tab, listing euro, Turkish lira and pound sterling with their own rate, fee and rounding controls',
    }),
    title: <Translate id="home.card.currencies.title">Rates, fees and rounding</Translate>,
    body: (
      <Translate id="home.card.currencies.body">
        Every currency carries its own exchange rate, fee and rounding step, and
        the panel shows the price a customer would actually see.
      </Translate>
    ),
  },
  {
    img: 'img/shot-placement.webp',
    alt: translate({
      id: 'home.card.placement.alt',
      message:
        "A site's navigation menu with the currency switcher's dropdown open, listing Turkish lira, US dollar, euro and pound sterling",
    }),
    title: <Translate id="home.card.placement.title">Five ways to place it</Translate>,
    body: (
      <Translate id="home.card.placement.body">
        Two shortcodes, two Elementor widgets or a navigation menu item — each
        one documented with copyable code.
      </Translate>
    ),
  },
  {
    img: 'img/shot-cache.webp',
    alt: translate({
      id: 'home.card.cache.alt',
      message: 'A product grid with every price converted to Turkish lira, the switcher above it',
    }),
    title: <Translate id="home.card.cache.title">It survives a page cache</Translate>,
    body: (
      <Translate id="home.card.cache.body">
        Anonymous pages stay cached in the base currency and prices are converted
        after they load — which is where most currency switchers break.
      </Translate>
    ),
  },
];

export default function Home() {
  return (
    <Layout
      title={translate({ id: 'home.title', message: 'MHM Currency Switcher Documentation' })}
      description={translate({
        id: 'home.description',
        message: 'Multi-currency for WooCommerce that survives a page cache',
      })}>
      <header className={clsx('hero', styles.heroBanner)}>
        <div className="container">
          <Heading as="h1" className={styles.heroTitle}>
            <Translate id="home.hero.title">MHM Currency Switcher Documentation</Translate>
          </Heading>
          <p className="hero__subtitle">
            <Translate id="home.hero.subtitle">
              Multi-currency for WooCommerce, from installation to the REST API
            </Translate>
          </p>
          <Link className="button button--secondary button--lg" to="/docs/intro">
            <Translate id="home.hero.cta">Get started</Translate>
          </Link>
          <div className={styles.heroBannerFrame}>
            <img
              className={styles.heroBannerImage}
              src="img/banner.webp"
              alt={translate({
                id: 'home.hero.bannerAlt',
                message:
                  'MHM Currency Switcher — multi-currency support for WooCommerce',
              })}
            />
          </div>
        </div>
      </header>
      <main>
        <div className={styles.cards}>
          {CARDS.map((c) => (
            <div className={styles.card} key={c.img}>
              <img src={c.img} alt={c.alt} />
              <div className={styles.cardBody}>
                <Heading as="h3">{c.title}</Heading>
                <p>{c.body}</p>
              </div>
            </div>
          ))}
        </div>
      </main>
    </Layout>
  );
}
