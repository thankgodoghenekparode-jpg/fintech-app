import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeLoansPortfolio({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="loans" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.loans}</h1>
            <p className="intro">Monitor active loans, upcoming payments, and recovery notices.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>The API has no cooperative-wide loan portfolio endpoint. Loan records and recovery notice states are unavailable.</span>
        </div>

        <section className="panel admin-arrears-panel" aria-labelledby="portfolio-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="portfolio-title">Active loans</h2>
              <p className="intro">Borrowers and outstanding repayment status</p>
            </div>
            <span className="status-pill">Data unavailable</span>
          </div>
          <div className="member-table-wrap">
            <table className="member-table">
              <thead>
                <tr>
                  <th scope="col">Borrower</th>
                  <th scope="col">Balance</th>
                  <th scope="col">Status</th>
                  <th scope="col">Next due</th>
                  <th scope="col">Days overdue</th>
                  <th scope="col">Recovery</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan={6}>
                    <div className="member-unavailable" role="status">
                      <span aria-hidden="true" className="empty-icon">◎</span>
                      <strong>Loan portfolio is unavailable</strong>
                      <span>The API only defines individual loan details when a loan ID is known. No portfolio list or notice state is available.</span>
                      <button className="button-secondary" disabled type="button">Start recovery</button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section className="panel loan-review-panel" aria-labelledby="guarantor-title">
          <div className="panel-heading"><h2 id="guarantor-title">Guarantor details</h2></div>
          <div className="contract-empty" role="status">
            <strong>Guarantor details are unavailable</strong>
            <span>Open a loan record to review guarantors. A cooperative-wide loan record is not available from the API.</span>
          </div>
        </section>
      </section>
    </main>
  );
}
