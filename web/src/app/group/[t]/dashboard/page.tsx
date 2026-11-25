import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

const metrics = [
  en.cooperative.poolBalance,
  en.cooperative.memberSavings,
  en.cooperative.shareCapital,
  en.cooperative.loansOut,
  en.cooperative.guarantorLocked,
  en.cooperative.arrears,
];

export default async function CooperativeDashboard({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="dashboard" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.dashboard}</h1>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>
        <section className="metric-grid" aria-label={en.cooperative.dashboard}>
          {metrics.map((label) => (
            <article className="metric-card" key={label}>
              <h2>{label}</h2>
              <p className="metric-value" aria-label={en.cooperative.noDashboardData}>&mdash;</p>
            </article>
          ))}
        </section>
        <section className="dashboard-lower-grid">
          <article className="panel chart-panel">
            <div className="panel-heading"><h2>{en.cooperative.contributionsOverTime}</h2></div>
            <div className="empty-chart" role="status">
              <span className="empty-icon" aria-hidden="true">&hellip;</span>
              <p>{en.cooperative.noChartData}</p>
            </div>
          </article>
          <article className="panel approvals-panel">
            <div className="panel-heading"><h2>{en.cooperative.pendingApprovals}</h2></div>
            <div className="empty-compact" role="status">{en.cooperative.noApprovals}</div>
          </article>
          <article className="panel activity-panel">
            <div className="panel-heading"><h2>{en.cooperative.recentActivity}</h2></div>
            <div className="empty-compact" role="status">{en.cooperative.noActivity}</div>
          </article>
        </section>
      </section>
    </main>
  );
}
