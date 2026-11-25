import { useEffect, useState } from "react";
import type { FormEvent } from "react";
import type { ReportsCopy } from "../shared/copy";
import { formatKobo } from "../shared/format";
import {
  AppButton,
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  SurfaceCard,
} from "../components/ui";
import type { ReportsAdapter, ReportsQuery, ReportsResult } from "./reports_types";

interface DateRange {
  readonly from: string;
  readonly to: string;
}

interface ReportsAndExportsPageProps {
  readonly tenantId: string;
  /** The host supplies this opaque identifier; the API has no report-type enum. */
  readonly reportType: string;
  readonly adapter: ReportsAdapter;
  readonly copy: ReportsCopy;
}

export function ReportsAndExportsPage({
  adapter,
  copy,
  reportType,
  tenantId,
}: ReportsAndExportsPageProps) {
  const [draftRange, setDraftRange] = useState<DateRange>({ from: "", to: "" });
  const [appliedRange, setAppliedRange] = useState<DateRange>({ from: "", to: "" });
  const [refreshKey, setRefreshKey] = useState(0);
  const [result, setResult] = useState<ReportsResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [rangeError, setRangeError] = useState(false);
  const [generating, setGenerating] = useState(false);
  const [exportState, setExportState] = useState<"idle" | "success" | "error">("idle");

  const query: ReportsQuery = {
    tenantId,
    reportType,
    ...(appliedRange.from ? { from: appliedRange.from } : {}),
    ...(appliedRange.to ? { to: appliedRange.to } : {}),
  };

  useEffect(() => {
    let active = true;
    setLoading(true);
    setLoadError(false);
    adapter
      .loadReport(query)
      .then((next) => active && setResult(next))
      .catch(() => active && setLoadError(true))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [adapter, appliedRange.from, appliedRange.to, refreshKey, reportType, tenantId]);

  async function retry() {
    setLoading(true);
    setLoadError(false);
    try {
      setResult(await adapter.loadReport(query));
    } catch {
      setLoadError(true);
    } finally {
      setLoading(false);
    }
  }

  function applyDates(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (draftRange.from && draftRange.to && draftRange.from > draftRange.to) {
      setRangeError(true);
      return;
    }
    setRangeError(false);
    setExportState("idle");
    setAppliedRange(draftRange);
    setRefreshKey((current) => current + 1);
  }

  async function exportReport() {
    if (generating || result?.state !== "ready") return;
    setGenerating(true);
    setExportState("idle");
    try {
      await adapter.exportReport(query);
      setExportState("success");
    } catch {
      setExportState("error");
    } finally {
      setGenerating(false);
    }
  }

  return (
    <main className="feature-page reports-page">
      <header className="page-heading reports-heading">
        <div>
          <p className="eyebrow">{copy.eyebrow}</p>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <AppButton
          disabled={loading || generating || result?.state !== "ready"}
          leadingIcon="download"
          onClick={() => void exportReport()}
          type="button"
          variant="primary"
        >
          {generating ? copy.exporting : copy.export}
        </AppButton>
      </header>

      <SurfaceCard className="reports-filter-card">
        <form className="reports-filter-form" noValidate onSubmit={applyDates}>
          <label className="form-field" htmlFor="reports-from">
            <span className="field-label">{copy.from}</span>
            <input
              className="app-input"
              id="reports-from"
              max={draftRange.to || undefined}
              onChange={(event) =>
                setDraftRange((current) => ({ ...current, from: event.target.value }))
              }
              type="date"
              value={draftRange.from}
            />
          </label>
          <label className="form-field" htmlFor="reports-to">
            <span className="field-label">{copy.to}</span>
            <input
              className="app-input"
              id="reports-to"
              min={draftRange.from || undefined}
              onChange={(event) =>
                setDraftRange((current) => ({ ...current, to: event.target.value }))
              }
              type="date"
              value={draftRange.to}
            />
          </label>
          <AppButton leadingIcon="calendar" type="submit" variant="secondary">
            {copy.applyRange}
          </AppButton>
          {rangeError ? (
            <p className="field-error reports-range-error" role="alert">
              {copy.invalidRange}
            </p>
          ) : null}
        </form>
      </SurfaceCard>

      {exportState === "success" ? (
        <div className="feedback-banner" role="status">
          <Icon name="check" />
          {copy.exportSuccess}
        </div>
      ) : null}
      {exportState === "error" ? (
        <div className="reports-export-error" role="alert">
          <Icon name="warning" />
          {copy.exportError}
        </div>
      ) : null}

      {loading ? <LoadingState label={copy.loading} /> : null}
      {!loading && loadError ? (
        <ErrorState
          body={copy.errorBody}
          onRetry={() => void retry()}
          retryLabel={copy.retry}
          title={copy.errorTitle}
        />
      ) : null}
      {!loading && !loadError && result?.state === "restricted" ? (
        <div className="restricted-banner" role="status">
          <Icon name="warning" />
          <div>
            <strong>{copy.restrictedTitle}</strong>
            <p>{copy.restrictedBody}</p>
          </div>
        </div>
      ) : null}
      {!loading && !loadError && result?.state === "empty" ? (
        <SurfaceCard>
          <EmptyState body={copy.emptyBody} title={copy.emptyTitle} />
        </SurfaceCard>
      ) : null}
      {!loading && !loadError && result?.state === "ready" ? (
        <section aria-label={copy.summaryTitle} className="reports-summary-grid">
          <ReportMetric icon="sales" label={copy.sales} value={result.summary.salesKobo} />
          <ReportMetric icon="fees" label={copy.fees} value={result.summary.feesKobo} />
          <ReportMetric icon="refund" label={copy.refunds} value={result.summary.refundsKobo} />
          <ReportMetric icon="invoice" label={copy.tax} value={result.summary.taxKobo} />
        </section>
      ) : null}
    </main>
  );
}

function ReportMetric({
  icon,
  label,
  value,
}: {
  readonly icon: "sales" | "fees" | "refund" | "invoice";
  readonly label: string;
  readonly value: number;
}) {
  return (
    <SurfaceCard className="report-metric-card">
      <div className="report-metric-heading">
        <span>{label}</span>
        <span aria-hidden="true" className="report-metric-icon">
          <Icon name={icon} />
        </span>
      </div>
      <strong className="report-metric-value">{formatKobo(value)}</strong>
    </SurfaceCard>
  );
}
