import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeSharesAdmin({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="shares" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.shares}</h1>
            <p className="intro">Manage share settings, review holdings, and run dividends.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>Share holdings and policy cannot be loaded yet. The API has no holdings list or policy-read response, and the web app has no shared session/API adapter.</span>
        </div>

        <section className="panel admin-plan-panel" aria-labelledby="share-policy-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="share-policy-title">Share policy</h2>
              <p className="intro">Set the unit price and share limits for the cooperative.</p>
            </div>
            <span className="status-pill">Policy unavailable</span>
          </div>
          <form className="share-policy-form">
            <label>Unit price<input disabled inputMode="decimal" /></label>
            <label>Minimum shares<input disabled inputMode="numeric" /></label>
            <label>Maximum shares<input disabled inputMode="numeric" /></label>
            <button className="button-secondary" disabled type="button">Save policy</button>
          </form>
          <p className="intro">The API can update policy but does not define a policy-read operation. Editing is disabled until the current settings can be reviewed.</p>
        </section>

        <section className="panel admin-arrears-panel" aria-labelledby="holdings-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="holdings-title">Member holdings</h2>
              <p className="intro">Share ownership across the cooperative</p>
            </div>
            <span className="status-pill">Data unavailable</span>
          </div>
          <div className="member-table-wrap">
            <table className="member-table">
              <thead>
                <tr>
                  <th scope="col">Member</th>
                  <th scope="col">Shares</th>
                  <th scope="col">Unit price</th>
                  <th scope="col">Total value</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan={4}>
                    <div className="contract-empty" role="status">
                      <strong>Holdings are unavailable</strong>
                      <span>The API defines a member’s own share summary only; it does not define the admin holdings list.</span>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section className="panel admin-arrears-panel" aria-labelledby="dividends-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="dividends-title">Dividend run</h2>
              <p className="intro">Propose, preview, and approve a dividend distribution.</p>
            </div>
          </div>
          <ol className="dividend-steps">
            <li><strong>Rate and period</strong><span>Unavailable</span></li>
            <li><strong>Preview allocation</strong><span>No preview endpoint</span></li>
            <li><strong>Second-admin approval</strong><span>Run ID and PIN authorization required</span></li>
            <li><strong>Post distribution</strong><span>Unavailable</span></li>
          </ol>
          <button className="button-secondary" disabled type="button">Start dividend run</button>
          <p className="intro">Dividend creation is disabled until the holdings, preview, run-status, and shared web-session contracts are available.</p>
        </section>
      </section>
    </main>
  );
}
