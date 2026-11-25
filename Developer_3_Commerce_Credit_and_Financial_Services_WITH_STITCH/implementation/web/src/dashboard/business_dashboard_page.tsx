import { useEffect, useMemo, useState } from "react";
import type { DashboardCopy } from "../shared/copy";
import { formatKobo } from "../shared/format";
import {
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  StatusChip,
  SurfaceCard,
} from "../components/ui";
import type {
  BusinessDashboardAdapter,
  DashboardActivityRow,
  DashboardResult,
} from "./dashboard_types";

export type DashboardDestination = "invoices" | "reports";

interface BusinessDashboardPageProps {
  readonly tenantId: string;
  readonly adapter: BusinessDashboardAdapter;
  readonly copy: DashboardCopy;
  readonly onNavigate?: (destination: DashboardDestination) => void;
}

export function BusinessDashboardPage({
  adapter,
  copy,
  onNavigate,
  tenantId,
}: BusinessDashboardPageProps) {
  const [result, setResult] = useState<DashboardResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);

  useEffect(() => {
    let active = true;
    setLoading(true);
    setLoadError(false);
    adapter
      .loadDashboard({ tenantId })
      .then((next) => active && setResult(next))
      .catch(() => active && setLoadError(true))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [adapter, tenantId]);

  async function retry() {
    setLoading(true);
    setLoadError(false);
    try {
      setResult(await adapter.loadDashboard({ tenantId }));
    } catch {
      setLoadError(true);
    } finally {
      setLoading(false);
    }
  }

  const snapshot = result?.state === "ready" ? result.snapshot : null;
  const maxSales = useMemo(
    () => Math.max(0, ...(snapshot?.salesSeries.map((point) => point.amountKobo) ?? [])),
    [snapshot],
  );

  return (
    <main className="feature-page dashboard-page">
      <header className="page-heading dashboard-heading">
        <div>
          <p className="eyebrow">{copy.eyebrow}</p>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <button
          className="dashboard-drilldown-link"
          disabled={!onNavigate}
          onClick={() => onNavigate?.("reports")}
          type="button"
        >
          <Icon name="reports" />
          <span>{copy.viewReports}</span>
        </button>
      </header>

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

      {!loading && !loadError && snapshot ? (
        <>
          <section aria-label={copy.eyebrow} className="dashboard-metric-grid">
            <MetricCard
              copy={copy.sales}
              hint={copy.viewDetails}
              icon="sales"
              onClick={onNavigate ? () => onNavigate("reports") : undefined}
              value={snapshot.metrics.salesKobo}
            />
            <MetricCard
              copy={copy.fees}
              hint={copy.viewDetails}
              icon="fees"
              onClick={onNavigate ? () => onNavigate("reports") : undefined}
              value={snapshot.metrics.feesKobo}
            />
            <MetricCard
              copy={copy.refunds}
              hint={copy.viewDetails}
              icon="refund"
              onClick={onNavigate ? () => onNavigate("reports") : undefined}
              value={snapshot.metrics.refundsKobo}
            />
            <MetricCard
              copy={copy.outstandingInvoices}
              hint={copy.viewDetails}
              icon="invoice"
              onClick={onNavigate ? () => onNavigate("invoices") : undefined}
              value={snapshot.metrics.outstandingInvoicesKobo}
            />
          </section>

          <section className="dashboard-content-grid">
            <SurfaceCard className="dashboard-chart-card">
              <div className="dashboard-section-heading">
                <div>
                  <h2>{copy.chartTitle}</h2>
                  <p>{copy.chartDescription}</p>
                </div>
                <Icon name="chart" />
              </div>
              {snapshot.salesSeries.length ? (
                <div aria-label={copy.chartTitle} className="sales-chart" role="img">
                  {snapshot.salesSeries.map((point) => {
                    const height =
                      maxSales > 0 ? (Math.max(0, point.amountKobo) / maxSales) * 100 : 0;
                    return (
                      <div className="sales-chart-column" key={point.label}>
                        <span className="sales-chart-value">{formatKobo(point.amountKobo)}</span>
                        <div className="sales-chart-track">
                          <span className="sales-chart-bar" style={{ height: `${height}%` }} />
                        </div>
                        <span className="sales-chart-label">{point.label}</span>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <p className="dashboard-inline-empty">{copy.emptyBody}</p>
              )}
            </SurfaceCard>

            <SurfaceCard className="dashboard-activity-card">
              <div className="dashboard-section-heading">
                <div>
                  <h2>{copy.recentActivity}</h2>
                  <p>{copy.activityTitle}</p>
                </div>
                <button
                  className="dashboard-inline-link"
                  disabled={!onNavigate}
                  onClick={() => onNavigate?.("reports")}
                  type="button"
                >
                  {copy.viewReports}
                </button>
              </div>
              {snapshot.recentActivity.length ? (
                <div className="dashboard-activity-list">
                  {snapshot.recentActivity.map((row) => (
                    <ActivityItem copy={copy} key={row.id} row={row} />
                  ))}
                </div>
              ) : (
                <p className="dashboard-inline-empty">{copy.noActivity}</p>
              )}
            </SurfaceCard>
          </section>
        </>
      ) : null}
    </main>
  );
}

function MetricCard({
  copy,
  hint,
  icon,
  onClick,
  value,
}: {
  readonly copy: string;
  readonly hint: string;
  readonly icon: "sales" | "fees" | "refund" | "invoice";
  readonly onClick?: () => void;
  readonly value: number;
}) {
  return (
    <button className="dashboard-metric-card" disabled={!onClick} onClick={onClick} type="button">
      <span className="dashboard-metric-label">{copy}</span>
      <span aria-hidden="true" className="dashboard-metric-icon">
        <Icon name={icon} />
      </span>
      <strong className="dashboard-metric-value">{formatKobo(value)}</strong>
      <span className="dashboard-metric-hint">{onClick ? hint : ""}</span>
    </button>
  );
}

function ActivityItem({
  copy,
  row,
}: {
  readonly copy: DashboardCopy;
  readonly row: DashboardActivityRow;
}) {
  return (
    <div className="dashboard-activity-row">
      <div className="dashboard-activity-name">
        <strong>{row.title}</strong>
        <span>{row.timeLabel}</span>
      </div>
      <span className="dashboard-activity-amount" aria-label={copy.activityAmount}>
        {formatKobo(row.amountKobo)}
      </span>
      <StatusChip tone={row.statusTone}>{row.statusLabel}</StatusChip>
    </div>
  );
}
