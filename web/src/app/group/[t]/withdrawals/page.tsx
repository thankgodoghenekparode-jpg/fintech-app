import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeWithdrawals({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="withdrawals" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.withdrawals}</h1>
            <p className="intro">Request and review cooperative account withdrawals.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>Withdrawal actions require verified destination and PIN authorization. The API does not define destination lookup or pending/history list responses.</span>
        </div>

        <section className="panel withdrawal-request-panel" aria-labelledby="new-withdrawal-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="new-withdrawal-title">Request a withdrawal</h2>
              <p className="intro">A second administrator must approve the request.</p>
            </div>
          </div>
          <form className="withdrawal-form">
            <label>Amount<input disabled inputMode="decimal" /></label>
            <label>Verified destination<input disabled /></label>
            <label className="withdrawal-reason">Reason<textarea disabled rows={3} /></label>
            <button className="button-secondary" disabled type="button">Submit request</button>
          </form>
          <p className="intro">No request is sent until a verified destination can be selected and PIN authorization is connected.</p>
        </section>

        <section className="panel admin-arrears-panel" aria-labelledby="pending-withdrawals-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="pending-withdrawals-title">Pending approvals</h2>
              <p className="intro">First/second approver and cooling-off status</p>
            </div>
            <span className="status-pill">Data unavailable</span>
          </div>
          <div className="contract-empty" role="status">
            <strong>Pending requests are unavailable</strong>
            <span>The API defines how to create and approve a withdrawal, but no pending-withdrawals list or cooling-off state.</span>
            <button className="button-secondary" disabled type="button">Approve selected</button>
          </div>
        </section>

        <section className="panel admin-arrears-panel" aria-labelledby="withdrawal-history-title">
          <div className="panel-heading"><h2 id="withdrawal-history-title">Withdrawal history</h2></div>
          <div className="contract-empty" role="status">
            <strong>History is unavailable</strong>
            <span>No withdrawal-history read operation is defined.</span>
          </div>
        </section>
      </section>
    </main>
  );
}
