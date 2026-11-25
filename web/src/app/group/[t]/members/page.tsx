import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeMembers({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="members" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.members}</h1>
            <p className="intro">Review membership and manage access for this cooperative.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <section className="member-toolbar" aria-label="Member filters">
          <label className="member-search">
            <span className="visually-hidden">Search members</span>
            <input disabled placeholder="Search members" type="search" />
          </label>
          <label className="member-filter">
            <span className="visually-hidden">Filter by membership status</span>
            <select disabled defaultValue="all">
              <option value="all">All statuses</option>
            </select>
          </label>
          <button className="button-secondary" disabled type="button">Invite member</button>
        </section>

        <section className="panel member-panel" aria-labelledby="member-list-title">
          <div className="member-panel-heading">
            <div>
              <h2 id="member-list-title">Members</h2>
              <p className="intro">Member directory and account actions</p>
            </div>
            <span className="status-pill">Data unavailable</span>
          </div>
          <div className="member-table-wrap">
            <table className="member-table">
              <thead>
                <tr>
                  <th scope="col">Member</th>
                  <th scope="col">Role</th>
                  <th scope="col">Joined</th>
                  <th scope="col">Status</th>
                  <th scope="col"><span className="visually-hidden">Actions</span></th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan={5}>
                    <div className="member-unavailable" role="status">
                      <span aria-hidden="true" className="empty-icon">◎</span>
                      <strong>Member list is not available yet</strong>
                      <span>The cooperative service has not defined the member-list response fields. Member records and actions are not displayed.</span>
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
