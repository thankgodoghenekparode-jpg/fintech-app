import { en } from '@/i18n/en';
import { GroupSidebar } from '@/components/group-sidebar';

export default async function CooperativeVerification({ params }: { params: Promise<{ t: string }> }) {
  const { t } = await params;
  return (
    <main className="dashboard-layout">
      <GroupSidebar tenant={t} active="verification" />
      <section className="dashboard-content">
        <header className="dashboard-header">
          <div><p className="eyebrow">{en.products.cooperatives}</p><h1>Verification and trust level</h1><p className="intro">Review cooperative documents and verification status.</p></div>
          <span className="tenant-chip">{t}</span>
        </header>
        <div className="notice notice-info" role="status"><span className="notice-mark" aria-hidden="true">i</span><span>The API does not define document status, trust levels, unlock limits, or document upload. No upload or trust claim can be made from this screen.</span></div>
        <div className="verification-grid">
          <section className="panel verification-panel" aria-labelledby="trust-level-title"><div className="panel-heading"><h2 id="trust-level-title">Trust level</h2><span className="status-pill">Unavailable</span></div><div className="contract-empty" role="status"><strong>Trust level is unavailable</strong><span>No verification status or trust-limit response is documented.</span></div></section>
          <section className="panel verification-panel" aria-labelledby="documents-title"><div className="panel-heading"><h2 id="documents-title">Documents</h2></div><div className="contract-empty" role="status"><strong>Document list is unavailable</strong><span>Document records, rejection reasons, and upload storage are not defined.</span></div><label className="verification-upload">Upload new documents<input disabled type="file" /></label></section>
        </div>
      </section>
    </main>
  );
}
