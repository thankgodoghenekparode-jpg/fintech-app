import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

const sections = [
  { title: 'Contributions', fields: ['Frequency', 'Amount', 'Grace period'] },
  { title: 'Loans', fields: ['Waiting period', 'Savings multiplier', 'Interest', 'Penalties'] },
  { title: 'Shares', fields: ['Unit price', 'Share limits'] },
  { title: 'Withdrawals', fields: ['Withdrawal rules', 'Cooling-off period'] },
];

export default async function CooperativeRules({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="rules" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.rules}</h1>
            <p className="intro">Review and submit versioned cooperative rules.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>Current and draft rule values are unavailable because the rules response and rule-field schema are not defined.</span>
        </div>

        <section className="panel rules-form-panel" aria-labelledby="draft-title">
          <div className="admin-section-heading">
            <div>
              <h2 id="draft-title">Draft rule set</h2>
              <p className="intro">A change is submitted as a new version for approval.</p>
            </div>
            <span className="status-pill">Editing unavailable</span>
          </div>
          <form>
            <fieldset className="rules-fieldset" disabled>
              <legend className="visually-hidden">Cooperative rule categories</legend>
              <div className="rules-section-grid">
                {sections.map((section) => (
                  <section className="rules-category" key={section.title}>
                    <h3>{section.title}</h3>
                    {section.fields.map((field) => (
                      <label key={field}>{field}<input /></label>
                    ))}
                  </section>
                ))}
              </div>
              <label className="effective-date">Effective date<input type="datetime-local" /></label>
            </fieldset>
            <p className="intro">Rule names, units, validation, and notice-period behavior need a typed schema before editing can be enabled.</p>
            <button className="button-secondary" disabled type="button">Review and submit for approval</button>
          </form>
        </section>

        <section className="panel rules-history-panel" aria-labelledby="history-title">
          <div className="panel-heading"><h2 id="history-title">Version history</h2></div>
          <div className="contract-empty" role="status">
            <strong>Rule history is unavailable</strong>
            <span>The API does not define active/draft response fields or a version-history diff.</span>
          </div>
        </section>
      </section>
    </main>
  );
}
