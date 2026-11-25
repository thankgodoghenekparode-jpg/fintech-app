import { useCallback, useEffect, useMemo, useState, type CSSProperties } from "react";
import {
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  StatusChip,
  SurfaceCard,
} from "../components/ui";
import type {
  PasVendorPlansAdapter,
  PasVendorPlansCopy,
  PasVendorPlan,
} from "./vendor_plans_types";

interface PasVendorPlansPageProps {
  readonly tenantId: string;
  readonly adapter: PasVendorPlansAdapter;
  readonly copy: PasVendorPlansCopy;
}

const summaryLabels = [
  "summaryActive",
  "summarySaved",
  "summaryCompletion",
  "summaryExpiring",
] as const;
const summaryIcons = ["invoice", "fees", "chart", "clock"] as const;

export function PasVendorPlansPage({ adapter, copy, tenantId }: PasVendorPlansPageProps) {
  const [plans, setPlans] = useState<readonly PasVendorPlan[]>([]);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [access, setAccess] = useState<"ready" | "empty" | "unavailable" | "restricted">(
    "unavailable",
  );
  const [query, setQuery] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [selectedId, setSelectedId] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setFailed(false);
    try {
      const result = await adapter.loadPlans({ tenantId });
      setAccess(result.state);
      setPlans(result.state === "ready" ? result.plans : []);
      setSelectedId((current) =>
        result.state === "ready" && current && result.plans.some((plan) => plan.id === current)
          ? current
          : result.state === "ready"
            ? (result.plans[0]?.id ?? null)
            : null,
      );
    } catch {
      setFailed(true);
    } finally {
      setLoading(false);
    }
  }, [adapter, tenantId]);

  useEffect(() => {
    void load();
  }, [load]);

  const planTypes = useMemo(() => [...new Set(plans.map((plan) => plan.planTypeLabel))], [plans]);
  const statuses = useMemo(() => [...new Set(plans.map((plan) => plan.statusLabel))], [plans]);
  const filteredPlans = useMemo(() => {
    const normalized = query.trim().toLocaleLowerCase();
    return plans.filter((plan) => {
      const matchesQuery =
        !normalized ||
        [plan.planReference, plan.customerLabel, plan.productLabel].some((value) =>
          value.toLocaleLowerCase().includes(normalized),
        );
      return (
        matchesQuery &&
        (!typeFilter || plan.planTypeLabel === typeFilter) &&
        (!statusFilter || plan.statusLabel === statusFilter)
      );
    });
  }, [plans, query, statusFilter, typeFilter]);
  const selected = filteredPlans.find((plan) => plan.id === selectedId) ?? filteredPlans[0] ?? null;
  const unavailable = access === "unavailable";
  const restricted = access === "restricted";
  const noRows = access === "empty" || (access === "ready" && plans.length === 0);

  return (
    <main className="feature-page pas-vendor-page pas-vendor-plans">
      <div className="page-heading pas-vendor-heading">
        <div>
          <span className="page-eyebrow">{copy.eyebrow}</span>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
      </div>

      <section aria-label="Plan summary" className="pas-vendor-kpi-grid pas-vendor-plan-kpis">
        {summaryLabels.map((label, index) => (
          <SurfaceCard className="pas-vendor-metric-card" key={label}>
            <div className="pas-vendor-metric-heading">
              <span>{copy[label]}</span>
              <span className="pas-vendor-metric-icon">
                <Icon name={summaryIcons[index]} />
              </span>
            </div>
            <strong className="pas-vendor-metric-value">{copy.metricUnavailable}</strong>
            <span className="pas-vendor-metric-support">{copy.notSupplied}</span>
          </SurfaceCard>
        ))}
      </section>

      <div className="pas-vendor-unavailable" role="note">
        <Icon name="info" />
        <div>
          <strong>{copy.unavailableTitle}</strong>
          <p>{copy.unavailableBody}</p>
        </div>
      </div>

      <section aria-label={copy.searchLabel} className="pas-vendor-plan-toolbar">
        <label className="table-search pas-vendor-search">
          <Icon name="search" />
          <span className="sr-only">{copy.searchLabel}</span>
          <input
            onChange={(event) => setQuery(event.target.value)}
            placeholder={copy.searchPlaceholder}
            type="search"
            value={query}
          />
        </label>
        <label className="pas-vendor-filter">
          <span>{copy.planType}</span>
          <select
            aria-label={copy.planType}
            onChange={(event) => setTypeFilter(event.target.value)}
            value={typeFilter}
          >
            <option value="">{copy.allPlans}</option>
            {planTypes.map((planType) => (
              <option key={planType} value={planType}>
                {planType}
              </option>
            ))}
          </select>
        </label>
        <label className="pas-vendor-filter">
          <span>{copy.status}</span>
          <select
            aria-label={copy.status}
            onChange={(event) => setStatusFilter(event.target.value)}
            value={statusFilter}
          >
            <option value="">{copy.allPlans}</option>
            {statuses.map((status) => (
              <option key={status} value={status}>
                {status}
              </option>
            ))}
          </select>
        </label>
      </section>

      {loading ? <LoadingState label={copy.loading} /> : null}
      {!loading && failed ? (
        <ErrorState
          body={copy.errorBody}
          onRetry={() => void load()}
          retryLabel={copy.retry}
          title={copy.errorTitle}
        />
      ) : null}
      {!loading && !failed && restricted ? (
        <EmptyState body={copy.restrictedBody} title={copy.restrictedTitle} />
      ) : null}
      {!loading && !failed && unavailable ? (
        <EmptyState body={copy.unavailableBody} title={copy.unavailableTitle} />
      ) : null}
      {!loading && !failed && noRows ? (
        <EmptyState body={copy.emptyBody} title={copy.emptyTitle} />
      ) : null}
      {!loading && !failed && access === "ready" && filteredPlans.length === 0 ? (
        <EmptyState body={copy.noResultsBody} title={copy.noResultsTitle} />
      ) : null}

      {!loading && !failed && access === "ready" && filteredPlans.length > 0 ? (
        <div className="pas-vendor-plans-layout">
          <SurfaceCard className="pas-vendor-plan-table-card">
            <div className="pas-vendor-table-heading">
              <h2>
                <Icon name="reports" />
                {copy.tableHeading}
              </h2>
              <span>
                {filteredPlans.length} {copy.planReference.toLocaleLowerCase()}s
              </span>
            </div>
            <div className="pas-vendor-responsive-table-wrap">
              <table className="data-table pas-vendor-responsive-table pas-vendor-plan-table">
                <thead>
                  <tr>
                    <th scope="col">{copy.planReference}</th>
                    <th scope="col">{copy.customer}</th>
                    <th scope="col">{copy.product}</th>
                    <th scope="col">{copy.target}</th>
                    <th scope="col">{copy.progress}</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredPlans.map((plan) => (
                    <tr className={selected?.id === plan.id ? "is-selected" : ""} key={plan.id}>
                      <td data-label={copy.planReference}>
                        <button
                          aria-pressed={selected?.id === plan.id}
                          className="pas-vendor-row-select"
                          onClick={() => setSelectedId(plan.id)}
                          type="button"
                        >
                          <strong>{plan.planReference}</strong>
                          <small>{plan.planTypeLabel}</small>
                        </button>
                      </td>
                      <td data-label={copy.customer}>
                        <span className="pas-vendor-customer-cell">{plan.customerLabel}</span>
                        <small className="pas-vendor-table-secondary">
                          {plan.identityLabel ?? copy.notSupplied}
                        </small>
                      </td>
                      <td data-label={copy.product}>{plan.productLabel}</td>
                      <td className="amount-cell" data-label={copy.target}>
                        {plan.targetAmountLabel ?? copy.notSupplied}
                      </td>
                      <td data-label={copy.progress}>
                        <div className="pas-vendor-progress-cell">
                          {typeof plan.progressPercent === "number" &&
                          Number.isFinite(plan.progressPercent) &&
                          plan.progressPercent >= 0 &&
                          plan.progressPercent <= 100 ? (
                            <span
                              aria-label={`${plan.progressLabel ?? copy.progress}: ${plan.progressPercent}%`}
                              className="pas-vendor-progress-track"
                              role="img"
                            >
                              <span style={{ width: `${plan.progressPercent}%` }} />
                            </span>
                          ) : (
                            <span
                              className="pas-vendor-progress-track is-unavailable"
                              aria-hidden="true"
                            />
                          )}
                          <span>{plan.progressLabel ?? copy.notSupplied}</span>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </SurfaceCard>

          <SurfaceCard className="pas-vendor-plan-inspector">
            {selected ? (
              <>
                <div className="pas-vendor-section-heading">
                  <span className="pas-vendor-inspector-overline">{copy.detailHeading}</span>
                  <StatusChip tone={selected.statusTone ?? "neutral"}>
                    {selected.statusLabel}
                  </StatusChip>
                </div>
                <span className="pas-vendor-inspector-reference">{selected.planReference}</span>
                <h2 className="pas-vendor-plan-customer">{selected.customerLabel}</h2>
                <p className="pas-vendor-plan-product">{selected.productLabel}</p>
                <span className="pas-vendor-type-badge">{selected.planTypeLabel}</span>
                <div className="pas-vendor-plan-progress-card">
                  <div
                    aria-label={
                      selected.progressPercent != null &&
                      selected.progressPercent >= 0 &&
                      selected.progressPercent <= 100
                        ? `${selected.progressLabel ?? copy.progress}: ${selected.progressPercent}%`
                        : copy.notSupplied
                    }
                    className="pas-vendor-progress-ring"
                    role="img"
                    style={
                      selected.progressPercent != null &&
                      selected.progressPercent >= 0 &&
                      selected.progressPercent <= 100
                        ? ({ "--progress-value": `${selected.progressPercent}%` } as CSSProperties)
                        : undefined
                    }
                  >
                    <span>{selected.progressLabel ?? copy.notSupplied}</span>
                  </div>
                  <div className="pas-vendor-plan-value-pair">
                    <span>
                      <small>{copy.saved}</small>
                      <strong>{selected.savedAmountLabel ?? copy.notSupplied}</strong>
                    </span>
                    <span>
                      <small>{copy.target}</small>
                      <strong>{selected.targetAmountLabel ?? copy.notSupplied}</strong>
                    </span>
                  </div>
                </div>
                <dl className="pas-vendor-detail-list">
                  <div>
                    <dt>{copy.identity}</dt>
                    <dd>{selected.identityLabel ?? copy.notSupplied}</dd>
                  </div>
                  <div>
                    <dt>{copy.verification}</dt>
                    <dd>{selected.verificationLabel ?? copy.notSupplied}</dd>
                  </div>
                  <div>
                    <dt>{copy.repaymentHistory}</dt>
                    <dd>{selected.repaymentHistoryLabel ?? copy.notSupplied}</dd>
                  </div>
                  <div>
                    <dt>{copy.nextDue}</dt>
                    <dd>{selected.nextDueLabel ?? copy.notSupplied}</dd>
                  </div>
                  {selected.detailRows?.map((row) => (
                    <div key={`${row.label}-${row.value}`}>
                      <dt>{row.label}</dt>
                      <dd>{row.value}</dd>
                    </div>
                  ))}
                </dl>
                <span className="pas-vendor-synthetic-tag">
                  <Icon name="info" />
                  {copy.syntheticLabel}
                </span>
              </>
            ) : (
              <p className="pas-vendor-inspector-empty">{copy.noSelection}</p>
            )}
          </SurfaceCard>
        </div>
      ) : null}
    </main>
  );
}
