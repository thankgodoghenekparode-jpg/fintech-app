import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeAudit({ params }: { params: Promise<{ t: string }> }) {
  const { t } = await params;
  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="audit" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div><p className="eyebrow">{en.products.cooperatives}</p><h1>Audit trail</h1><p className="intro">Review recorded administrative activity.</p></div>
          <span className="tenant-chip">{t}</span>
        </header>
        <div className="notice notice-info" role="status"><span className="notice-mark" aria-hidden="true">i</span><span>The API contract does not define an audit event list or export format. Filters and export are unavailable until those contracts are published.</span></div>
        <section className="panel admin-arrears-panel" aria-labelledby="audit-events-title">
          <div className="admin-section-heading"><div><h2 id="audit-events-title">Administrative events</h2><p className="intro">Actor, action, time, and before/after details</p></div><button className="button-secondary" disabled type="button">Export</button></div>
          <div className="report-filters"><label>From<input disabled type="date" /></label><label>To<input disabled type="date" /></label><label>Action<input disabled placeholder="All actions" /></label><button className="button-secondary" disabled type="button">Filter</button></div>
          <div className="contract-empty" role="status"><strong>Audit events are unavailable</strong><span>No cooperative audit-list response or export contract is documented.</span></div>
        </section>
      </section>
    </main>
  );
}
