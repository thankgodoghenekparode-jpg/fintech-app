import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeHubAdmin({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="hub" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.hub}</h1>
            <p className="intro">Share updates and organize cooperative meetings.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>Announcements can be published and meetings scheduled by API, but web session integration is not connected. Meeting lists, attendance, RSVP, and minutes upload are not defined.</span>
        </div>

        <div className="hub-admin-grid">
          <section className="panel hub-compose-panel" aria-labelledby="compose-announcement-title">
            <div className="panel-heading"><h2 id="compose-announcement-title">Compose announcement</h2></div>
            <form className="hub-form">
              <label>Title<input disabled /></label>
              <label>Message<textarea disabled rows={5} /></label>
              <button className="button-secondary" disabled type="button">Publish announcement</button>
            </form>
            <p className="intro">Drafts and published posts are unavailable because the announcement-list response is unspecified.</p>
          </section>

          <section className="panel hub-compose-panel" aria-labelledby="schedule-meeting-title">
            <div className="panel-heading"><h2 id="schedule-meeting-title">Schedule a meeting</h2></div>
            <form className="hub-form">
              <label>Meeting title<input disabled /></label>
              <label>Date and time<input disabled type="datetime-local" /></label>
              <label>Venue<input disabled /></label>
              <button className="button-secondary" disabled type="button">Schedule meeting</button>
            </form>
            <p className="intro">Meeting schedules cannot be listed or updated after creation until read and edit contracts are defined.</p>
          </section>
        </div>

        <section className="panel admin-arrears-panel" aria-labelledby="upcoming-meetings-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="upcoming-meetings-title">Upcoming meetings</h2>
              <p className="intro">Attendance and minutes</p>
            </div>
            <span className="status-pill">Unavailable</span>
          </div>
          <div className="contract-empty" role="status">
            <strong>Meeting list is unavailable</strong>
            <span>No list, RSVP/attendance, or minutes upload operation is documented.</span>
          </div>
        </section>
      </section>
    </main>
  );
}
