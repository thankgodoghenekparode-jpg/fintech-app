import Link from 'next/link';
import { en } from '@/i18n/en';

export default async function AjoOrganizerDashboard({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <aside className="dashboard-sidebar" aria-label="Ajo menu">
        <Link className="dashboard-brand" href="/">{en.app.title}</Link>
        <p className="sidebar-label">{en.products.ajo}</p>
        <nav className="dashboard-nav">
          <Link aria-current="page" className="nav-link nav-link-active" href={'/group/' + encodeURIComponent(t) + '/ajo'}>
            Circle management
          </Link>
        </nav>
      </aside>
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.ajo}</p>
            <h1>Circle management</h1>
            <p className="intro">Track contributions and payout rounds for your circle.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>The circle detail response is not defined yet. Status, pot, protection, member and round data are unavailable.</span>
        </div>

        <section className="ajo-summary-grid" aria-label="Circle summary">
          {['Circle status', 'Group pot', 'Protection mode'].map((label) => (
            <article className="metric-card" key={label}>
              <h2>{label}</h2>
              <p className="metric-value">Unavailable</p>
            </article>
          ))}
        </section>

        <section className="panel ajo-web-panel" aria-labelledby="rounds-heading">
          <div className="panel-heading"><h2 id="rounds-heading">Payout rounds</h2></div>
          <div className="table-empty" role="status">
            <strong>Round data is unavailable</strong>
            <span>The API does not define round fields or paid-count values. No round records are shown.</span>
          </div>
        </section>

        <section className="panel ajo-web-panel" aria-labelledby="members-heading">
          <div className="panel-heading"><h2 id="members-heading">Members</h2></div>
          <div className="table-empty" role="status">
            <strong>Member data is unavailable</strong>
            <span>Member status and trust fields are not defined in the circle detail response.</span>
          </div>
        </section>

        <div className="ajo-actions">
          <button className="button-secondary" disabled type="button">Invite members</button>
          <button className="button-secondary" disabled type="button">View terms</button>
          <span className="intro">Actions will be enabled when the service provides a circle ID and invite details.</span>
        </div>
      </section>
    </main>
  );
}
