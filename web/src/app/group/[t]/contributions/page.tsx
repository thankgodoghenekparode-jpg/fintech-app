import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeContributionsAdmin({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="contributions" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.contributions}</h1>
            <p className="intro">Manage contribution plans and review member arrears.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>Plan and arrears records are unavailable until their response fields are defined. The web app also has no shared session/API adapter yet.</span>
        </div>

        <section className="panel admin-plan-panel" aria-labelledby="plans-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="plans-title">Contribution plans</h2>
              <p className="intro">Changes create a new plan version under the backend rules.</p>
            </div>
          </div>
          <div className="contract-empty" role="status">
            <strong>Plan list is unavailable</strong>
            <span>The plan-list endpoint has no response schema. No plan values or current rule versions are shown.</span>
          </div>
          <details className="plan-create-details">
            <summary>Create a plan</summary>
            <form className="plan-form">
              <label>Plan name<input disabled name="name" /></label>
              <label>Frequency
                <select disabled defaultValue="">
                  <option value="" disabled>Select frequency</option>
                  <option value="DAILY">Daily</option>
                  <option value="WEEKLY">Weekly</option>
                  <option value="MONTHLY">Monthly</option>
                  <option value="YEARLY">Yearly</option>
                </select>
              </label>
              <label>Amount per contribution<input disabled inputMode="decimal" name="amount" /></label>
              <label>Start date<input disabled name="startsOn" type="date" /></label>
              <label>Grace days<input disabled inputMode="numeric" name="graceDays" /></label>
              <p className="intro">Category allocations are not configurable until the service defines the category amount schema.</p>
              <button className="button-secondary" disabled type="button">Save plan</button>
            </form>
            <p className="intro">Plan creation is unavailable until the shared web session and API adapter are connected.</p>
          </details>
        </section>

        <section className="panel admin-arrears-panel" aria-labelledby="arrears-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="arrears-title">Arrears by member and plan</h2>
              <p className="intro">Review outstanding contributions.</p>
            </div>
            <button className="button-secondary" disabled type="button">Export</button>
          </div>
          <div className="member-table-wrap">
            <table className="member-table">
              <thead>
                <tr>
                  <th scope="col">Member</th>
                  <th scope="col">Plan</th>
                  <th scope="col">Outstanding</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan={3}>
                    <div className="contract-empty" role="status">
                      <strong>Arrears data is unavailable</strong>
                      <span>The arrears endpoint has no response schema, and no export format is defined.</span>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </section>
    </main>
  );
}
