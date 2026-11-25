import { useCallback, useEffect, useMemo, useState, type FormEvent } from "react";
import {
  AppButton,
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  StatusChip,
  SurfaceCard,
} from "../components/ui";
import type {
  PasVendorOrdersAdapter,
  PasVendorOrdersCopy,
  PasVendorOrder,
} from "./vendor_orders_types";

interface PasVendorOrdersPageProps {
  readonly tenantId: string;
  readonly adapter: PasVendorOrdersAdapter;
  readonly copy: PasVendorOrdersCopy;
}

const summaryLabels = [
  "summaryOrders",
  "summaryPending",
  "summaryInTransit",
  "summaryOverdue",
] as const;
const summaryIcons = ["invoice", "clock", "send", "warning"] as const;

export function PasVendorOrdersPage({ adapter, copy, tenantId }: PasVendorOrdersPageProps) {
  const [orders, setOrders] = useState<readonly PasVendorOrder[]>([]);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [access, setAccess] = useState<"ready" | "empty" | "unavailable" | "restricted">(
    "unavailable",
  );
  const [query, setQuery] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [deliveryCode, setDeliveryCode] = useState("");
  const [attempted, setAttempted] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [deliveryError, setDeliveryError] = useState(false);
  const [deliveryAccepted, setDeliveryAccepted] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setFailed(false);
    try {
      const result = await adapter.loadOrders({ tenantId });
      setAccess(result.state);
      setOrders(result.state === "ready" ? result.orders : []);
      setSelectedId((current) =>
        result.state === "ready" && current && result.orders.some((order) => order.id === current)
          ? current
          : result.state === "ready"
            ? (result.orders[0]?.id ?? null)
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

  const statuses = useMemo(() => [...new Set(orders.map((order) => order.statusLabel))], [orders]);
  const filteredOrders = useMemo(() => {
    const normalized = query.trim().toLocaleLowerCase();
    return orders.filter((order) => {
      const matchesSearch =
        !normalized ||
        [order.orderReference, order.buyerLabel, order.itemLabel].some((value) =>
          value.toLocaleLowerCase().includes(normalized),
        );
      return matchesSearch && (!statusFilter || order.statusLabel === statusFilter);
    });
  }, [orders, query, statusFilter]);
  const selected =
    filteredOrders.find((order) => order.id === selectedId) ?? filteredOrders[0] ?? null;

  async function submitDelivery(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setAttempted(true);
    setDeliveryError(false);
    setDeliveryAccepted(false);
    if (
      !selected ||
      !/^\d{6}$/.test(deliveryCode) ||
      !selected.canConfirmDelivery ||
      !adapter.confirmDelivered
    )
      return;
    setSubmitting(true);
    try {
      await adapter.confirmDelivered({ tenantId, orderId: selected.id, deliveryCode });
      setDeliveryAccepted(true);
      setDeliveryCode("");
      setAttempted(false);
    } catch {
      setDeliveryError(true);
    } finally {
      setSubmitting(false);
    }
  }

  const unavailable = access === "unavailable";
  const restricted = access === "restricted";
  const noRows = access === "empty" || (access === "ready" && orders.length === 0);

  return (
    <main className="feature-page pas-vendor-page pas-vendor-orders">
      <div className="page-heading pas-vendor-heading">
        <div>
          <span className="page-eyebrow">{copy.eyebrow}</span>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
      </div>

      <section aria-label="Order summary" className="pas-vendor-kpi-grid pas-vendor-order-kpis">
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

      <section aria-label={copy.searchLabel} className="pas-vendor-catalog-toolbar">
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
        <span className="pas-vendor-record-count">
          {access === "ready" ? `${filteredOrders.length} / ${orders.length}` : copy.notSupplied}
        </span>
      </section>

      {statuses.length > 0 ? (
        <div aria-label={copy.status} className="pas-vendor-status-tabs" role="group">
          <button
            aria-pressed={!statusFilter}
            className={!statusFilter ? "pas-vendor-status-tab is-active" : "pas-vendor-status-tab"}
            onClick={() => setStatusFilter("")}
            type="button"
          >
            {copy.allOrders} <span>{orders.length}</span>
          </button>
          {statuses.map((status) => (
            <button
              aria-pressed={statusFilter === status}
              className={
                statusFilter === status
                  ? "pas-vendor-status-tab is-active"
                  : "pas-vendor-status-tab"
              }
              key={status}
              onClick={() => setStatusFilter(status)}
              type="button"
            >
              {status} <span>{orders.filter((order) => order.statusLabel === status).length}</span>
            </button>
          ))}
        </div>
      ) : null}

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
      {!loading && !failed && access === "ready" && filteredOrders.length === 0 ? (
        <EmptyState body={copy.noResultsBody} title={copy.noResultsTitle} />
      ) : null}

      {!loading && !failed && access === "ready" && filteredOrders.length > 0 ? (
        <div className="pas-vendor-orders-layout">
          <SurfaceCard className="pas-vendor-order-table-card">
            <div className="pas-vendor-table-heading">
              <h2>
                <Icon name="invoice" />
                {copy.ordersHeading}
              </h2>
              <span>
                {filteredOrders.length} {copy.order.toLocaleLowerCase()}s
              </span>
            </div>
            <div className="pas-vendor-responsive-table-wrap">
              <table className="data-table pas-vendor-responsive-table">
                <thead>
                  <tr>
                    <th scope="col">{copy.order}</th>
                    <th scope="col">{copy.buyer}</th>
                    <th scope="col">{copy.item}</th>
                    <th scope="col">{copy.value}</th>
                    <th scope="col">{copy.planType}</th>
                    <th scope="col">{copy.status}</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredOrders.map((order) => (
                    <tr className={selected?.id === order.id ? "is-selected" : ""} key={order.id}>
                      <td data-label={copy.order}>
                        <button
                          aria-pressed={selected?.id === order.id}
                          className="pas-vendor-row-select"
                          onClick={() => {
                            setSelectedId(order.id);
                            setDeliveryAccepted(false);
                            setDeliveryError(false);
                          }}
                          type="button"
                        >
                          <strong>{order.orderReference}</strong>
                          <small>{copy.syntheticLabel}</small>
                        </button>
                      </td>
                      <td data-label={copy.buyer}>{order.buyerLabel}</td>
                      <td data-label={copy.item}>{order.itemLabel}</td>
                      <td className="amount-cell" data-label={copy.value}>
                        {order.orderValueLabel ?? copy.notSupplied}
                      </td>
                      <td data-label={copy.planType}>{order.planTypeLabel ?? copy.notSupplied}</td>
                      <td data-label={copy.status}>
                        <div className="pas-vendor-order-status">
                          <StatusChip tone={order.statusTone ?? "neutral"}>
                            {order.statusLabel}
                          </StatusChip>
                          {order.overdue ? (
                            <StatusChip tone="error">{copy.overdue}</StatusChip>
                          ) : null}
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </SurfaceCard>

          <SurfaceCard className="pas-vendor-order-inspector">
            {selected ? (
              <>
                <div className="pas-vendor-section-heading">
                  <h2>{copy.detailHeading}</h2>
                  <StatusChip tone={selected.statusTone ?? "neutral"}>
                    {selected.statusLabel}
                  </StatusChip>
                </div>
                <span className="pas-vendor-inspector-reference">{selected.orderReference}</span>
                <h3>{selected.itemLabel}</h3>
                <dl className="pas-vendor-detail-list">
                  {selected.details.map((detail) => (
                    <div key={`${detail.label}-${detail.value}`}>
                      <dt>{detail.label}</dt>
                      <dd>{detail.value}</dd>
                    </div>
                  ))}
                </dl>
                <form className="pas-vendor-delivery-form" noValidate onSubmit={submitDelivery}>
                  <h3>{copy.deliveryHeading}</h3>
                  <label className="form-field">
                    <span className="field-label">{copy.deliveryCode}</span>
                    <input
                      aria-label={copy.deliveryCode}
                      aria-describedby="pas-delivery-code-hint"
                      aria-invalid={
                        attempted && deliveryCode.length > 0 && !/^\d{6}$/.test(deliveryCode)
                      }
                      className="app-input pas-delivery-code-input"
                      disabled={
                        !selected.canConfirmDelivery || !adapter.confirmDelivered || submitting
                      }
                      inputMode="numeric"
                      maxLength={6}
                      onChange={(event) =>
                        setDeliveryCode(event.target.value.replace(/\D/g, "").slice(0, 6))
                      }
                      pattern="[0-9]{6}"
                      placeholder="••••••"
                      value={deliveryCode}
                    />
                    <small id="pas-delivery-code-hint">{copy.deliveryCodeHint}</small>
                    {attempted && !/^\d{6}$/.test(deliveryCode) ? (
                      <span className="field-error" role="alert">
                        {copy.deliveryCodeInvalid}
                      </span>
                    ) : null}
                  </label>
                  {!selected.canConfirmDelivery || !adapter.confirmDelivered ? (
                    <p className="pas-vendor-contract-gap">{copy.deliveryUnavailable}</p>
                  ) : null}
                  {deliveryAccepted ? (
                    <p className="pas-vendor-operation-success" role="status">
                      {copy.deliverySuccess}
                    </p>
                  ) : null}
                  {deliveryError ? (
                    <p className="pas-vendor-operation-error" role="alert">
                      {copy.deliveryError}
                    </p>
                  ) : null}
                  <AppButton
                    className="pas-vendor-full-button"
                    disabled={
                      !selected.canConfirmDelivery || !adapter.confirmDelivered || submitting
                    }
                    leadingIcon="check"
                    type="submit"
                    variant="primary"
                  >
                    {submitting ? copy.confirmingDelivery : copy.confirmDelivery}
                  </AppButton>
                </form>
                <div className="pas-vendor-unavailable-action-list">
                  <button className="app-button button-secondary" disabled type="button">
                    {copy.shippedUnavailable}
                  </button>
                  <p>{copy.proofUnavailable}</p>
                </div>
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
