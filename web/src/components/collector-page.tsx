import Link from 'next/link';
import { en } from '@/i18n/en';

const sections = [
  ['dashboard', 'Dashboard'],
  ['items', 'Revenue items'],
  ['payers', 'Payers'],
  ['collections', 'Collections'],
  ['field', 'Field collectors'],
  ['settlement', 'Settlement and fees'],
  ['reports', 'Reports'],
  ['verification', 'Verification and team'],
] as const;

const columns = ['Reference', 'Payer', 'Amount', 'Status', 'Updated'];

export function CollectorPage({
  tenant,
  active,
  title,
  description,
  detail,
}: {
  tenant: string;
  active: string;
  title: string;
  description: string;
  detail: string;
}) {
  const actionLabel = active === 'reports' ? 'Export report' : active === 'items' ? 'Create revenue item' : active === 'payers' ? 'Import payers' : 'Add';
  return (
    <main className="dashboard-layout">
      <aside className="dashboard-sidebar" aria-label="Revenue menu">
        <Link className="dashboard-brand" href="/">{en.app.title}</Link>
        <p className="sidebar-label">Revenue</p>
        <nav className="dashboard-nav">{sections.map(([slug, label]) => active === slug ? <Link aria-current="page" className="nav-link nav-link-active" href={'/collector/' + encodeURIComponent(tenant) + '/' + slug} key={slug}>{label}</Link> : <Link className="nav-link" href={'/collector/' + encodeURIComponent(tenant) + '/' + slug} key={slug}>{label}</Link>)}</nav>
      </aside>
      <section className="dashboard-content">
        <header className="dashboard-header"><div><p className="eyebrow">Revenue · Collector</p><h1>{title}</h1><p className="intro">{description}</p></div><span className="tenant-chip">{tenant}</span></header>
        <div className="notice notice-info" role="status"><span className="notice-mark" aria-hidden="true">i</span><span>Revenue API responses do not define the records or figures for this view. Data and actions stay unavailable until typed response and session contracts are integrated.</span></div>
        {active === 'dashboard' ? <div className="metric-grid"><article className="panel metric-card"><h2>Collected</h2><p className="metric-value">Unavailable</p></article><article className="panel metric-card"><h2>Outstanding</h2><p className="metric-value">Unavailable</p></article><article className="panel metric-card"><h2>Exceptions</h2><p className="metric-value">Unavailable</p></article></div> : null}
        <section className="panel admin-arrears-panel">
          <div className="admin-section-heading"><div><h2>{detail}</h2><p className="intro">Revenue records and their current status</p></div><button className="button-secondary" disabled type="button">{actionLabel}</button></div>
          <div className="member-toolbar"><label className="member-search"><span className="visually-hidden">Search revenue records</span><input disabled placeholder="Search records" /></label><button className="button-secondary" disabled type="button">Filter</button></div>
          <div className="member-table-wrap"><table className="member-table"><thead><tr>{columns.map((column) => <th scope="col" key={column}>{column}</th>)}</tr></thead><tbody><tr><td colSpan={columns.length}><div className="contract-empty" role="status"><strong>Records are unavailable</strong><span>No response schema or data source is available for {detail.toLowerCase()}.</span></div></td></tr></tbody></table></div>
        </section>
        {active === 'items' || active === 'field' || active === 'settlement' ? <section className="panel rules-form-panel"><div className="panel-heading"><h2>{active === 'items' ? 'Revenue item details' : active === 'field' ? 'Collector assignment' : 'Settlement details'}</h2></div><form className="share-policy-form"><label>Name or reference<input disabled /></label><label>Amount<input disabled /></label><label>Status<input disabled /></label><button className="button-secondary" disabled type="button">Save changes</button></form></section> : null}
      </section>
    </main>
  );
}
