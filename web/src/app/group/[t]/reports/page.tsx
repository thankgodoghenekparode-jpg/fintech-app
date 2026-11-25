import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

const reportTypes = [
  'Trial balance',
  'Income summary',
  'Member statements',
  'AGM pack',
];

export default async function CooperativeReports({
  params,
}: {
  params: Promise<{ t: string }>;
}) {
  const { t } = await params;

  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="reports" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div>
            <p className="eyebrow">{en.products.cooperatives}</p>
            <h1>{en.cooperative.reports}</h1>
            <p className="intro">Prepare financial statements and cooperative reports.</p>
          </div>
          <span className="tenant-chip">{t}</span>
        </header>

        <div className="notice notice-info" role="status">
          <span className="notice-mark" aria-hidden="true">i</span>
          <span>Report contents and file delivery are not defined in the API response. No report data or downloads are available.</span>
        </div>

        <section className="panel report-options-panel" aria-labelledby="report-options-title">
          <div className="panel-heading"><h2 id="report-options-title">Choose a report</h2></div>
          <div className="report-type-grid">
            {reportTypes.map((type) => (
              <button className="report-type-card" disabled key={type} type="button">
                <span aria-hidden="true">▤</span>
                <strong>{type}</strong>
                <span>Unavailable</span>
              </button>
            ))}
          </div>
          <div className="report-filters">
            <label>From<input disabled type="date" /></label>
            <label>To<input disabled type="date" /></label>
            <label>File format
              <select disabled defaultValue="">
                <option value="" disabled>Select format</option>
                <option value="PDF">PDF</option>
                <option value="CSV">CSV</option>
              </select>
            </label>
            <button className="button-secondary" disabled type="button">Export report</button>
          </div>
          <p className="intro">The report endpoint has no response schema or content-type/file-delivery contract; these controls are shown for handoff alignment only.</p>
        </section>

        <section className="panel report-preview-panel" aria-labelledby="preview-title">
          <div className="panel-heading"><h2 id="preview-title">Report preview</h2></div>
          <div className="contract-empty" role="status">
            <strong>No report preview is available</strong>
            <span>Connect the report response format before rendering ledger entries or totals.</span>
          </div>
        </section>
      </section>
    </main>
  );
}
