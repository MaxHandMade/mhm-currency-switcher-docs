import React from 'react';
import Layout from '@theme/Layout';
import Link from '@docusaurus/Link';

export default function Home() {
  return (
    <Layout description="Multi-currency for WooCommerce that survives a page cache">
      <main style={{ maxWidth: 760, margin: '0 auto', padding: '3rem 1rem' }}>
        <h1>MHM Currency Switcher</h1>
        <p>
          Multi-currency support for WooCommerce. Visitors browse, add to cart and
          check out in the currency they choose, and it keeps working behind a page
          cache — which is where most currency switchers break.
        </p>
        <p>
          <Link className="button button--primary" to="/docs/intro">Get started</Link>
        </p>
      </main>
    </Layout>
  );
}
