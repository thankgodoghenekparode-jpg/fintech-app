import { AgentOpsSidebar } from '@/components/agent-ops-sidebar';

export default function AgentFloatReconciliation() {
  return (
    <main className="dashboard-layout">
      <AgentOpsSidebar active="/backoffice/agents/float" />
      <section className="dashboard-content">
        <header className="dashboard-header"><div><p className="eyebrow">Agent Network · Operations</p><h1>Float and reconciliation</h1><p className="intro">Monitor agent float and review daily reconciliation exceptions.</p></div></header>
        <div className="notice notice-info" role="status"><span className="notice-mark" aria-hidden="true">i</span><span>No backoffice float or reconciliation list endpoint is defined. The agent home and day-end operations also have no typed success response.</span></div>
        <div className="metric-grid"><article className="panel metric-card"><h2>Total float</h2><p className="metric-value">Unavailable</p></article><article className="panel metric-card"><h2>Low-float agents</h2><p className="metric-value">Unavailable</p></article><article className="panel metric-card"><h2>Reconciliation exceptions</h2><p className="metric-value">Unavailable</p></article></div>
        <section className="panel admin-arrears-panel"><div className="admin-section-heading"><div><h2>Agent float and day-end submissions</h2><p className="intro">Balances, declared cash, and variance</p></div><button className="button-secondary" disabled type="button">Export</button></div><div className="member-table-wrap"><table className="member-table"><thead><tr><th scope="col">Agent</th><th scope="col">Float</th><th scope="col">Declared cash</th><th scope="col">Variance</th><th scope="col">Status</th></tr></thead><tbody><tr><td colSpan={5}><div className="contract-empty" role="status"><strong>Reconciliation records are unavailable</strong><span>There is no agent float or backoffice reconciliation response contract.</span></div></td></tr></tbody></table></div></section>
      </section>
    </main>
  );
}
