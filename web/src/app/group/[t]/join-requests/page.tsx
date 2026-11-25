import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeJoinRequests({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="join-requests" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.joinRequests}</h1>
            <p className="intro">Review membership requests before approving or declining.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>Request records are unavailable because the join-request list has no response schema. No applicant details are shown.</span>
        </div>

        <section className="member-toolbar" aria-label="Join request controls">
          <label className="member-search">
            <span className="visually-hidden">Search requests</span>
            <input disabled placeholder="Search applicants" type="search" />
          </label>
          <button className="button-secondary" disabled type="button">Approve selected</button>
        </section>

        <section className="panel member-panel" aria-labelledby="requests-title">
          <div className="member-panel-heading">
            <div>
              <h2 id="requests-title">Membership requests</h2>
              <p className="intro">Review each request before making a decision.</p>
            </div>
            <span className="status-pill">Data unavailable</span>
          </div>
          <div className="member-table-wrap">
            <table className="member-table">
              <thead>
                <tr>
                  <th scope="col">Applicant</th>
                  <th scope="col">Message</th>
                  <th scope="col">Decision</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan={3}>
                    <div className="member-unavailable" role="status">
                      <span aria-hidden="true" className="empty-icon">◎</span>
                      <strong>Join requests can’t be displayed yet</strong>
                      <span>The service must define applicant fields and request IDs before this queue can show records or target approve/reject actions.</span>
                      <div className="request-actions" aria-label="Decision actions unavailable">
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
      </section>
    </main>
  );
}
