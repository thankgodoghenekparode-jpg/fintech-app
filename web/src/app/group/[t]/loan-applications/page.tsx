import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeLoanApplications({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="loan-applications" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.loanApplications}</h1>
            <p className="intro">Review applications, guarantor cover, and repayment schedules.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>The loan queue response has no schema. Applicant records, guarantor completion, and second-approver status are unavailable.</span>
        </div>

        <section className="panel admin-arrears-panel" aria-labelledby="loan-queue-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="loan-queue-title">Application queue</h2>
              <p className="intro">Review the request and cover details before deciding.</p>
            </div>
            <span className="status-pill">Data unavailable</span>
          </div>
          <div className="member-table-wrap">
            <table className="member-table">
              <thead>
                <tr>
                  <th scope="col">Applicant</th>
                  <th scope="col">Requested amount</th>
                  <th scope="col">Status</th>
                  <th scope="col">Guarantor cover</th>
                  <th scope="col">Review</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan={5}>
                    <div className="member-unavailable" role="status">
                      <span aria-hidden="true" className="empty-icon">◎</span>
                      <strong>Loan applications can’t be displayed yet</strong>
                      <span>The queue must expose application IDs and review fields before the web app can show a request or target a decision.</span>
                      <div className="request-actions" aria-label="Loan decision actions unavailable">
                        <button className="button-secondary" disabled type="button">Approve</button>
                        <button className="button-secondary" disabled type="button">Reject</button>
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section className="panel loan-review-panel" aria-labelledby="loan-review-title">
          <div className="panel-heading"><h2 id="loan-review-title">Application review</h2></div>
          <div className="review-unavailable-grid">
            <div><strong>Member history</strong><span>Unavailable</span></div>
            <div><strong>Savings and guarantees</strong><span>Unavailable</span></div>
            <div><strong>Repayment schedule and cost</strong><span>Unavailable</span></div>
            <div><strong>Second approver</strong><span>Unavailable</span></div>
          </div>
          <p className="intro">The service must define these review fields before loan decisions can be enabled.</p>
        </section>
      </section>
    </main>
  );
}
