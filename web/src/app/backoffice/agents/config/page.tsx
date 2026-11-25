import { AgentOpsSidebar } from '@/components/agent-ops-sidebar';

export default function AgentNetworkConfig() {
  return (
    <main className="dashboard-layout">
      <AgentOpsSidebar active="/backoffice/agents/config" />
      <section className="dashboard-content">
        <header className="dashboard-header"><div><p className="eyebrow">Agent Network · Product administration</p><h1>Commission and limits</h1><p className="intro">Review agent transaction rules and control configuration changes.</p></div></header>
        <div className="notice notice-info" role="status"><span className="notice-mark" aria-hidden="true">i</span><span>The API defines a dual-control configuration write, but no configuration read, commission catalog, current limits, or approval workflow.</span></div>
        <section className="panel rules-form-panel"><div className="panel-heading"><h2>Current configuration</h2></div><div className="review-unavailable-grid"><div><strong>Cash-in limits</strong><span>Per-transaction and daily limits unavailable</span></div><div><strong>Cash-out limits</strong><span>Customer and agent tiers unavailable</span></div><div><strong>Commission</strong><span>Rates and payout schedule unavailable</span></div><div><strong>Float thresholds</strong><span>Low-float alert rules unavailable</span></div></div></section>
        <section className="panel rules-form-panel"><div className="panel-heading"><h2>Propose a configuration change</h2></div><form className="share-policy-form"><label>Commission rate<input disabled /></label><label>Per-transaction limit<input disabled /></label><label>Daily limit<input disabled /></label><button className="button-secondary" disabled type="button">Submit for dual approval</button></form><p className="intro">A typed configuration schema and defined two-person approval flow are required before editing.</p></section>
      </section>
    </main>
  );
}
