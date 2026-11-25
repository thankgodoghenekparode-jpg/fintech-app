import { AgentOpsSidebar } from '@/components/agent-ops-sidebar';

export default function AgentManagement() {
  return (
    <main className="dashboard-layout">
      <AgentOpsSidebar active="/backoffice/agents" />
      <section className="dashboard-content">
        <header className="dashboard-header"><div><p className="eyebrow">Agent Network · Operations</p><h1>Agents and applications</h1><p className="intro">Review onboarding applications and manage active agent access.</p></div></header>
        <div className="notice notice-info" role="status"><span className="notice-mark" aria-hidden="true">i</span><span>The API includes an applications list and decision endpoint, but its response fields, review details, and decision states are unspecified.</span></div>
        <section className="panel admin-arrears-panel">
          <div className="admin-section-heading"><div><h2>Applications and agents</h2><p className="intro">Application queue · Active · Suspended</p></div><span className="status-pill">Unavailable</span></div>
          <div className="member-toolbar"><label className="member-search"><span className="visually-hidden">Search agent applications</span><input disabled placeholder="Search by name, phone, or agent code" /></label><button className="button-secondary" disabled type="button">Filter</button></div>
          <div className="member-table-wrap"><table className="member-table"><thead><tr><th scope="col">Applicant / agent</th><th scope="col">Location</th><th scope="col">Status</th><th scope="col">Activity</th><th scope="col">Review</th></tr></thead><tbody><tr><td colSpan={5}><div className="contract-empty" role="status"><strong>Agent records are unavailable</strong><span>The list response schema is not defined, so no applicant or agent data can be shown.</span></div></td></tr></tbody></table></div>
        </section>
        <section className="panel admin-arrears-panel"><div className="panel-heading"><h2>Application review</h2></div><div className="review-unavailable-grid"><div><strong>Identity and business</strong><span>Verification results and application documents unavailable</span></div><div><strong>Location and services</strong><span>Service area and operating details unavailable</span></div><div><strong>Limits</strong><span>Agent transaction limits unavailable</span></div><div><strong>Review decision</strong><span>Approval, rejection, and suspension actions disabled</span></div></div><button className="button-secondary" disabled type="button">Approve or reject</button></section>
      </section>
    </main>
  );
}
