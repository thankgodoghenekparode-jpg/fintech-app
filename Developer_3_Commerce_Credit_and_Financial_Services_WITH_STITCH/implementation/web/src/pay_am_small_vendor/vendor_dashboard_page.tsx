import { useCallback, useEffect, useMemo, useState } from "react";
import {
  AppButton,
  ErrorState,
  Icon,
  LoadingState,
  StatusChip,
  SurfaceCard,
} from "../components/ui";
import type { PasVendorDashboardCopy } from "./vendor_copy";
import type {
  PasVendorDashboardAdapter,
  PasVendorDashboardMetric,
  PasVendorDashboardResult,
} from "./vendor_types";

interface PasVendorDashboardPageProps {
  readonly tenantId: string;
  readonly adapter: PasVendorDashboardAdapter;
  readonly copy: PasVendorDashboardCopy;
  readonly onOpenProducts?: () => void;
}

export function PasVendorDashboardPage({
  adapter,
  copy,
  onOpenProducts,
  tenantId,
}: PasVendorDashboardPageProps) {
  const [result, setResult] = useState<PasVendorDashboardResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setLoadError(false);
    try {
      setResult(await adapter.loadDashboard({ tenantId }));
    } catch {
      setLoadError(true);
    } finally {
      setLoading(false);
    }
  }, [adapter, tenantId]);

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

  const snapshot = result?.state === "ready" ? result.snapshot : null;
  const chartSummary = useMemo(
    () => [
      { title: copy.salesChart, values: snapshot?.salesTrend ?? [] },
      { title: copy.completionChart, values: snapshot?.planCompletion ?? [] },
    ],
    [copy.completionChart, copy.salesChart, snapshot],
  );

  return (
    <main className="feature-page pas-vendor-page pas-vendor-dashboard">
      <header className="page-heading pas-vendor-heading">
        <div>
          <p className="eyebrow">{copy.eyebrow}</p>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <AppButton
          disabled={!onOpenProducts}
          leadingIcon="invoice"
          onClick={onOpenProducts}
          type="button"
          variant="primary"
        >
          {copy.viewProducts}
        </AppButton>
      </header>

      {loading ? <LoadingState label={copy.loading} /> : null}
      {!loading && loadError ? (
        <ErrorState
          body={copy.errorBody}
          onRetry={() => void load()}
          retryLabel={copy.retry}
          title={copy.errorTitle}
        />
      ) : null}
      {!loading && !loadError && result?.state === "restricted" ? (
        <div className="restricted-banner pas-vendor-restricted" role="status">
          <Icon name="warning" />
          <div>
            <strong>{copy.restrictedTitle}</strong>
            <p>{copy.restrictedBody}</p>
          </div>
        </div>
      ) : null}
      {!loading && !loadError && result?.state === "unavailable" ? (
        <div className="pas-vendor-unavailable" role="status">
          <Icon name="info" />
          <div>
            <strong>{copy.unavailableTitle}</strong>
            <p>{copy.unavailableBody}</p>
          </div>
        </div>
      ) : null}
      {!loading && !loadError && result?.state === "empty" ? (
        <div className="pas-vendor-unavailable" role="status">
          <Icon name="info" />
          <div>
            <strong>{copy.emptyTitle}</strong>
            <p>{copy.emptyBody}</p>
          </div>
        </div>
      ) : null}

      {!loading && !loadError ? (
        <>
          <section aria-label={copy.title} className="pas-vendor-kpi-grid">
            <MetricTile
              copy={copy.orders}
              icon="send"
              metric={snapshot?.metrics.orders}
              unavailable={copy.unavailableValue}
            />
            <MetricTile
              copy={copy.activePlans}
              icon="reports"
              metric={snapshot?.metrics.activePlans}
              unavailable={copy.unavailableValue}
            />
            <MetricTile
              copy={copy.payouts}
              icon="fees"
              metric={snapshot?.metrics.payouts}
              unavailable={copy.unavailableValue}
            />
            <MetricTile
              copy={copy.disputes}
              icon="warning"
              metric={snapshot?.metrics.disputes}
              unavailable={copy.unavailableValue}
            />
          </section>

          <section aria-label={copy.salesChart} className="pas-vendor-dashboard-grid">
            {chartSummary.map((chart) => (
              <SurfaceCard className="pas-vendor-chart-card" key={chart.title}>
                <header className="pas-vendor-section-heading">
                  <h2>{chart.title}</h2>
                  <Icon name="chart" />
                </header>
                {chart.values.length ? (
                  <div className="pas-vendor-chart" role="list" aria-label={chart.title}>
                    {chart.values.map((point) => (
                      <div
                        className="pas-vendor-chart-column"
                        key={point.periodLabel}
                        role="listitem"
                      >
                        <span className="pas-vendor-chart-value">{point.valueLabel}</span>
                        <div className="pas-vendor-chart-track">
                          <span
                            className="pas-vendor-chart-bar"
                            style={{
                              height: `${Math.max(0, Math.min(100, point.displayFraction * 100))}%`,
                            }}
                          />
                        </div>
                        <span className="pas-vendor-chart-period">{point.periodLabel}</span>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="pas-vendor-chart-empty">
                    <Icon name="chart" />
                    <span>{copy.noChartData}</span>
                  </div>
                )}
              </SurfaceCard>
            ))}
            <SurfaceCard className="pas-vendor-alert-card">
              <header className="pas-vendor-section-heading">
                <h2>{copy.alerts}</h2>
                <Icon name="warning" />
              </header>
              {snapshot?.alerts.length ? (
                <ul className="pas-vendor-alert-list">
                  {snapshot.alerts.map((alert, index) => (
                    <li
                      className={`pas-vendor-alert tone-${alert.tone}`}
                      key={`${alert.title}-${index}`}
                    >
                      <StatusChip tone={alert.tone === "neutral" ? "neutral" : alert.tone}>
                        {alert.title}
                      </StatusChip>
                      <p>{alert.detail}</p>
                    </li>
                  ))}
                </ul>
              ) : (
                <div className="pas-vendor-chart-empty">
                  <Icon name="info" />
                  <span>{copy.noAlerts}</span>
                </div>
              )}
            </SurfaceCard>
          </section>
        </>
      ) : null}
    </main>
  );
}

function MetricTile({
  copy,
  icon,
  metric,
  unavailable,
}: {
  readonly copy: string;
  readonly icon: "send" | "reports" | "fees" | "warning";
  readonly metric?: PasVendorDashboardMetric;
  readonly unavailable: string;
}) {
  return (
    <SurfaceCard className="pas-vendor-metric-card">
      <div className="pas-vendor-metric-heading">
        <span>{metric?.label ?? copy}</span>
        <span aria-hidden="true" className="pas-vendor-metric-icon">
          <Icon name={icon} />
        </span>
      </div>
      <strong className="pas-vendor-metric-value">{metric?.valueLabel ?? "—"}</strong>
      <span className="pas-vendor-metric-support">{metric?.supportingLabel ?? unavailable}</span>
    </SurfaceCard>
  );
}
