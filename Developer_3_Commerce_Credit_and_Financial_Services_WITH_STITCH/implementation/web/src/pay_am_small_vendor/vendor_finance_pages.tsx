import { useCallback, useEffect, useMemo, useState } from "react";
import {
  AppButton,
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  StatusChip,
  SurfaceCard,
} from "../components/ui";

export interface PasVendorCreditOffer {
  readonly id: string;
  readonly reference: string;
  readonly buyerLabel: string;
  readonly productLabel: string;
  readonly statusLabel: string;
  readonly statusTone: "success" | "warning" | "error" | "neutral";
  readonly identitySummary?: string;
  readonly repaymentHistory?: string;
  readonly requestedAmountLabel?: string;
  readonly hostDetails: readonly { readonly label: string; readonly value: string }[];
}
export type PasVendorCreditResult =
  | { readonly state: "ready"; readonly offers: readonly PasVendorCreditOffer[] }
  | { readonly state: "empty" | "unavailable" | "restricted" };
export interface PasVendorCreditAdapter {
  loadOffers(input: { readonly tenantId: string }): Promise<PasVendorCreditResult>;
  /** Explicit host/legal capability; omitted or false keeps credit decisions unavailable. */
  readonly creditDecisionsAuthorized?: boolean;
  decide?(input: {
    readonly tenantId: string;
    readonly offerId: string;
    readonly decision: "ACCEPT" | "DECLINE";
    readonly reason?: string;
  }): Promise<void>;
}
export interface PasVendorPayoutSnapshot {
  readonly availableBalanceLabel?: string;
  readonly pendingHoldbackLabel?: string;
  readonly settledTotalLabel?: string;
  readonly settlementAccountLabel?: string;
  readonly summaryDetails?: readonly { readonly label: string; readonly value: string }[];
  readonly transactions: readonly {
    readonly reference: string;
    readonly dateLabel: string;
    readonly orderLabel?: string;
    readonly counterpartyLabel?: string;
    readonly grossAmountLabel?: string;
    readonly feeAmountLabel?: string;
    readonly netAmountLabel?: string;
    readonly statusLabel: string;
    readonly statusTone: "success" | "warning" | "error" | "neutral";
  }[];
}
export type PasVendorPayoutResult =
  | { readonly state: "ready"; readonly snapshot: PasVendorPayoutSnapshot }
  | { readonly state: "empty" | "unavailable" | "restricted" };
export interface PasVendorPayoutAdapter {
  loadPayouts(input: { readonly tenantId: string }): Promise<PasVendorPayoutResult>;
}
export interface PasVendorFinanceCopy {
  readonly credit: {
    readonly title: string;
    readonly subtitle: string;
    readonly loading: string;
    readonly error: string;
    readonly restricted: string;
    readonly unavailable: string;
    readonly empty: string;
    readonly search: string;
    readonly buyer: string;
    readonly product: string;
    readonly requested: string;
    readonly status: string;
    readonly details: string;
    readonly risk: string;
    readonly riskCopy: string;
    readonly notSupplied: string;
    readonly disabledDecision: string;
    readonly decisionAccepted: string;
    readonly decisionError: string;
    readonly reason: string;
  };
  readonly payouts: {
    readonly title: string;
    readonly subtitle: string;
    readonly loading: string;
    readonly error: string;
    readonly restricted: string;
    readonly unavailable: string;
    readonly empty: string;
    readonly available: string;
    readonly holdback: string;
    readonly settled: string;
    readonly account: string;
    readonly ledger: string;
    readonly reference: string;
    readonly date: string;
    readonly order: string;
    readonly gross: string;
    readonly fee: string;
    readonly net: string;
    readonly status: string;
    readonly notSupplied: string;
    readonly exportUnavailable: string;
  };
}

function useLoad<T>(load: () => Promise<T>) {
  const [value, setValue] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  const reload = useCallback(async () => {
    setLoading(true);
    setError(false);
    try {
      setValue(await load());
    } catch {
      setError(true);
    } finally {
      setLoading(false);
    }
  }, [load]);
  useEffect(() => {
    void reload();
  }, [reload]);
  return { value, loading, error, reload };
}

export function PasVendorCreditOffersPage({
  adapter,
  tenantId,
  copy,
}: {
  readonly adapter: PasVendorCreditAdapter;
  readonly tenantId: string;
  readonly copy: PasVendorFinanceCopy["credit"];
}) {
  const load = useCallback(() => adapter.loadOffers({ tenantId }), [adapter, tenantId]);
  const { value, loading, error, reload } = useLoad(load);
  const [query, setQuery] = useState("");
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [reason, setReason] = useState("");
  const [busy, setBusy] = useState(false);
  const [feedback, setFeedback] = useState("");
  const offers = value?.state === "ready" ? value.offers : [];
  const filtered = useMemo(
    () =>
      offers.filter((x) =>
        `${x.reference} ${x.buyerLabel} ${x.productLabel}`
          .toLocaleLowerCase()
          .includes(query.trim().toLocaleLowerCase()),
      ),
    [offers, query],
  );
  const selected = filtered.find((x) => x.id === selectedId) ?? filtered[0] ?? null;
  const canDecide = adapter.creditDecisionsAuthorized === true && !!adapter.decide;
  async function decide(decision: "ACCEPT" | "DECLINE") {
    if (!selected || !adapter.decide || adapter.creditDecisionsAuthorized !== true) return;
    setBusy(true);
    setFeedback("");
    try {
      await adapter.decide({
        tenantId,
        offerId: selected.id,
        decision,
        ...(reason.trim() ? { reason: reason.trim() } : {}),
      });
      setFeedback(copy.decisionAccepted);
    } catch {
      setFeedback(copy.decisionError);
    } finally {
      setBusy(false);
    }
  }
  const noRows = value?.state === "empty" || (value?.state === "ready" && offers.length === 0);
  return (
    <main className="feature-page pas-vendor-page pas-finance-page">
      <header className="page-heading pas-vendor-heading">
        <div>
          <span className="page-eyebrow">PAY AM SMALL · UNDERWRITING</span>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
      </header>
      <div className="pas-vendor-restricted">
        <Icon name="shield" />
        <div>
          <strong>{copy.risk}</strong>
          <p>{copy.riskCopy}</p>
        </div>
      </div>
      <label className="table-search pas-vendor-finance-search">
        <Icon name="search" />
        <span className="sr-only">{copy.search}</span>
        <input
          aria-label={copy.search}
          onChange={(e) => setQuery(e.target.value)}
          placeholder={copy.search}
          type="search"
          value={query}
        />
      </label>
      {loading ? <LoadingState label={copy.loading} /> : null}
      {!loading && error ? (
        <ErrorState
          body={copy.error}
          onRetry={() => void reload()}
          retryLabel="Retry"
          title={copy.title}
        />
      ) : null}
      {!loading && !error && value?.state === "unavailable" ? (
        <EmptyState body={copy.unavailable} title={copy.title} />
      ) : null}
      {!loading && !error && value?.state === "restricted" ? (
        <EmptyState body={copy.restricted} title={copy.title} />
      ) : null}
      {!loading && !error && noRows ? <EmptyState body={copy.empty} title={copy.title} /> : null}
      {!loading && !error && value?.state === "ready" && filtered.length === 0 ? (
        <EmptyState body={copy.empty} title={copy.title} />
      ) : null}
      {!loading && !error && filtered.length > 0 ? (
        <div className="pas-finance-split">
          <SurfaceCard className="pas-finance-list">
            <div className="pas-vendor-table-heading">
              <h2>{copy.title}</h2>
              <span>{filtered.length} supplied</span>
            </div>
            <div className="pas-vendor-responsive-table-wrap">
              <table className="data-table pas-vendor-responsive-table">
                <thead>
                  <tr>
                    <th>{copy.buyer}</th>
                    <th>{copy.product}</th>
                    <th>{copy.requested}</th>
                    <th>{copy.status}</th>
                  </tr>
                </thead>
                <tbody>
                  {filtered.map((x) => (
                    <tr className={selected?.id === x.id ? "is-selected" : ""} key={x.id}>
                      <td data-label={copy.buyer}>
                        <button
                          className="pas-vendor-row-select"
                          onClick={() => {
                            setSelectedId(x.id);
                            setFeedback("");
                          }}
                          type="button"
                        >
                          <strong>{x.buyerLabel}</strong>
                          <small>{x.reference}</small>
                        </button>
                      </td>
                      <td data-label={copy.product}>{x.productLabel}</td>
                      <td data-label={copy.requested}>
                        {x.requestedAmountLabel ?? copy.notSupplied}
                      </td>
                      <td data-label={copy.status}>
                        <StatusChip tone={x.statusTone}>{x.statusLabel}</StatusChip>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </SurfaceCard>
          <SurfaceCard className="pas-finance-detail">
            {selected ? (
              <>
                <div className="pas-vendor-section-heading">
                  <h2>{copy.details}</h2>
                  <StatusChip tone={selected.statusTone}>{selected.statusLabel}</StatusChip>
                </div>
                <h3>{selected.buyerLabel}</h3>
                <p>{selected.productLabel}</p>
                <p>
                  {copy.notSupplied}: {selected.identitySummary ?? copy.notSupplied}
                </p>
                <p>
                  {copy.notSupplied}: {selected.repaymentHistory ?? copy.notSupplied}
                </p>
                <dl className="pas-vendor-detail-list">
                  {selected.hostDetails.map((d) => (
                    <div key={d.label}>
                      <dt>{d.label}</dt>
                      <dd>{d.value}</dd>
                    </div>
                  ))}
                </dl>
                <label className="form-field">
                  <span className="field-label">{copy.reason}</span>
                  <textarea
                    className="app-input"
                    onChange={(e) => setReason(e.target.value)}
                    value={reason}
                  />
                </label>
                <p className="pas-vendor-contract-gap">{copy.disabledDecision}</p>
                {feedback ? <p role="status">{feedback}</p> : null}
                <div className="pas-finance-actions">
                  <AppButton
                    disabled={!canDecide || busy}
                    onClick={() => void decide("ACCEPT")}
                    variant="primary"
                  >
                    Accept
                  </AppButton>
                  <AppButton
                    disabled={!canDecide || busy}
                    onClick={() => void decide("DECLINE")}
                    variant="secondary"
                  >
                    Decline
                  </AppButton>
                </div>
              </>
            ) : (
              <p>{copy.notSupplied}</p>
            )}
          </SurfaceCard>
        </div>
      ) : null}
    </main>
  );
}

export function PasVendorPayoutsPage({
  adapter,
  tenantId,
  copy,
}: {
  readonly adapter: PasVendorPayoutAdapter;
  readonly tenantId: string;
  readonly copy: PasVendorFinanceCopy["payouts"];
}) {
  const load = useCallback(() => adapter.loadPayouts({ tenantId }), [adapter, tenantId]);
  const { value, loading, error, reload } = useLoad(load);
  const result = value?.state === "ready" ? value.snapshot : null;
  const cards = [
    [copy.available, result?.availableBalanceLabel],
    [copy.holdback, result?.pendingHoldbackLabel],
    [copy.settled, result?.settledTotalLabel],
    [copy.account, result?.settlementAccountLabel],
  ] as const;
  return (
    <main className="feature-page pas-vendor-page pas-finance-page">
      <header className="page-heading pas-vendor-heading">
        <div>
          <span className="page-eyebrow">PAY AM SMALL · FINANCE</span>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <AppButton disabled leadingIcon="download" title={copy.exportUnavailable}>
          {copy.exportUnavailable}
        </AppButton>
      </header>
      <section aria-label={copy.title} className="pas-vendor-kpi-grid">
        {cards.map(([label, value]) => (
          <SurfaceCard className="pas-vendor-metric-card" key={label}>
            <div className="pas-vendor-metric-heading">{label}</div>
            <strong className="pas-vendor-metric-value">{value ?? copy.notSupplied}</strong>
          </SurfaceCard>
        ))}
      </section>
      {result?.summaryDetails?.length ? (
        <SurfaceCard className="pas-vendor-payout-summary">
          <dl className="pas-vendor-detail-list">
            {result.summaryDetails.map((x) => (
              <div key={x.label}>
                <dt>{x.label}</dt>
                <dd>{x.value}</dd>
              </div>
            ))}
          </dl>
        </SurfaceCard>
      ) : null}
      {loading ? <LoadingState label={copy.loading} /> : null}
      {!loading && error ? (
        <ErrorState
          body={copy.error}
          onRetry={() => void reload()}
          retryLabel="Retry"
          title={copy.title}
        />
      ) : null}
      {!loading && !error && value?.state === "unavailable" ? (
        <EmptyState body={copy.unavailable} title={copy.title} />
      ) : null}
      {!loading && !error && value?.state === "restricted" ? (
        <EmptyState body={copy.restricted} title={copy.title} />
      ) : null}
      {!loading && !error && value?.state === "empty" ? (
        <EmptyState body={copy.empty} title={copy.title} />
      ) : null}
      {!loading && !error && result ? (
        <SurfaceCard className="pas-finance-ledger">
          <div className="pas-vendor-table-heading">
            <h2>{copy.ledger}</h2>
            <span>{result.transactions.length} supplied</span>
          </div>
          {result.transactions.length === 0 ? (
            <EmptyState body={copy.empty} title={copy.ledger} />
          ) : (
            <div className="pas-vendor-responsive-table-wrap">
              <table className="data-table pas-vendor-responsive-table">
                <thead>
                  <tr>
                    {[
                      copy.reference,
                      copy.date,
                      copy.order,
                      copy.gross,
                      copy.fee,
                      copy.net,
                      copy.status,
                    ].map((x) => (
                      <th key={x}>{x}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {result.transactions.map((x) => (
                    <tr key={`${x.reference}-${x.dateLabel}`}>
                      <td data-label={copy.reference}>{x.reference}</td>
                      <td data-label={copy.date}>{x.dateLabel}</td>
                      <td data-label={copy.order}>{x.orderLabel ?? copy.notSupplied}</td>
                      <td className="amount-cell" data-label={copy.gross}>
                        {x.grossAmountLabel ?? copy.notSupplied}
                      </td>
                      <td className="amount-cell" data-label={copy.fee}>
                        {x.feeAmountLabel ?? copy.notSupplied}
                      </td>
                      <td className="amount-cell" data-label={copy.net}>
                        {x.netAmountLabel ?? copy.notSupplied}
                      </td>
                      <td data-label={copy.status}>
                        <StatusChip tone={x.statusTone}>{x.statusLabel}</StatusChip>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </SurfaceCard>
      ) : null}
    </main>
  );
}
