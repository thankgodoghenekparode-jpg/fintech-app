import { en } from '@/i18n/en';
import Link from 'next/link';

const products = [
  { name: en.products.cooperatives, href: '/group/sample-cooperative/dashboard' },
  { name: en.products.ajo, href: '/group/sample-cooperative/ajo' },
  { name: en.products.targetSavings, href: null },
  { name: en.products.revenue, href: '/collector/sample-organization/dashboard' },
  { name: en.products.agents, href: '/backoffice/agents' },
];

export default function HomePage() {
  return (
    <main className="page-shell">
      <header className="topbar"><span className="brand">{en.app.title}</span></header>
      <section className="welcome">
        <p className="eyebrow">{en.app.workspace}</p>
        <h1>{en.app.headline}</h1>
        <p className="intro">{en.app.intro}</p>
        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>{en.app.previewWorkspaceNotice}</span>
        </div>
      </section>
      <section aria-label="Products" className="product-grid">
        {products.map(({ name, href }) => (
          <article className="product-card" key={name}>
            <h2>{name}</h2>
            <p>{href ? <Link href={href}>{en.app.productWorkspace}</Link> : 'Mobile screens are available in this workspace.'}</p>
            {href ? <Link aria-label={en.app.preview + ' ' + name} className="product-card-link" href={href}>{en.app.preview} <span aria-hidden="true">&rarr;</span></Link> : null}
          </article>
        ))}
      </section>
      {process.env.DEVELOPER_TWO_DESIGN_DEMO === 'true' ? (
        <p><Link href="/demo-preview">Browse the 26 supplied web design previews</Link></p>
      ) : null}
    </main>
  );
}
