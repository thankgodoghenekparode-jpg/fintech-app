import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeAdmins({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="admins" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.admins}</h1>
            <p className="intro">Manage cooperative administrators and role assignments.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>The API can invite or assign an admin, but does not define an admin list, role values, or permission catalog.</span>
        </div>

        <section className="panel admin-arrears-panel" aria-labelledby="admins-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="admins-title">Admins and roles</h2>
              <p className="intro">Keep at least two verified principal admins for the cooperative.</p>
            </div>
            <span className="status-pill">Roster unavailable</span>
          </div>
          <div className="member-table-wrap">
            <table className="member-table">
              <thead>
                <tr>
                  <th scope="col">Admin</th>
                  <th scope="col">Role</th>
                  <th scope="col">Permissions</th>
                  <th scope="col">Status</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan={4}>
                    <div className="contract-empty" role="status">
                      <strong>Admin roster is unavailable</strong>
                      <span>No admin-list endpoint is specified, so the minimum-admin warning and current assignments can’t be evaluated.</span>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <div className="admin-management-grid">
          <section className="panel admin-form-panel" aria-labelledby="invite-admin-title">
            <div className="panel-heading"><h2 id="invite-admin-title">Invite or assign an admin</h2></div>
            <form className="disabled-admin-form">
              <label>Phone number<input disabled /></label>
              <label>Role<input disabled /></label>
              <label>Permissions<input disabled /></label>
              <button className="button-secondary" disabled type="button">Invite admin</button>
            </form>
            <p className="intro">Role and permission values need a shared catalog before an assignment can be made.</p>
          </section>

          <section className="panel admin-form-panel" aria-labelledby="succession-title">
            <div className="panel-heading"><h2 id="succession-title">Admin succession</h2></div>
            <form className="disabled-admin-form">
              <label>Replacement admin<input disabled /></label>
              <label>Admin to replace<input disabled /></label>
              <button className="button-secondary" disabled type="button">Start succession</button>
            </form>
            <p className="intro">Member IDs and the shared PIN verification contract are required for succession.</p>
          </section>
        </div>
      </section>
    </main>
  );
}
