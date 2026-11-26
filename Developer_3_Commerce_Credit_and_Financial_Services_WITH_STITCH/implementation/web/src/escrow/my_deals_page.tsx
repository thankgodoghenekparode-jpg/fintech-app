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
import type {
  EscrowBusinessDeal,
  EscrowBusinessDealDetailResult,
  EscrowBusinessDealsAdapter,
  EscrowBusinessDealsCopy,
} from "./my_deals_types";
import "./my_deals_page.css";

interface EscrowBusinessDealsPageProps {
  readonly adapter: EscrowBusinessDealsAdapter;
  readonly copy: EscrowBusinessDealsCopy;
  readonly tenantId: string;
}

export function EscrowBusinessDealsPage({ adapter, copy, tenantId }: EscrowBusinessDealsPageProps) {
  const [deals, setDeals] = useState<readonly EscrowBusinessDeal[]>([]);
  const [listState, setListState] = useState<
    "loading" | "ready" | "empty" | "unavailable" | "restricted" | "error"
  >("loading");
  const [query, setQuery] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [detail, setDetail] = useState<EscrowBusinessDealDetailResult | null>(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [exportState, setExportState] = useState<"idle" | "success" | "error">("idle");

  const load = useCallback(async () => {
    setListState("loading");
    try {
      const result = await adapter.loadDeals({ tenantId });
      if (result.state === "ready") {
        setDeals(result.deals);
        setSelectedId((current) =>
          current && result.deals.some((deal) => deal.id === current) ? current : null,
        );
      } else {
        setDeals([]);
        setSelectedId(null);
      }
      setListState(result.state);
    } catch {
      setListState("error");
    }
  }, [adapter, tenantId]);

  useEffect(() => {
    void load();
  }, [load]);

  const statuses = useMemo(() => [...new Set(deals.map((deal) => deal.statusLabel))], [deals]);
  const filteredDeals = useMemo(() => {
    const needle = query.trim().toLocaleLowerCase();
    return deals.filter((deal) => {
      const matchesQuery =
        !needle ||
        [deal.referenceLabel, deal.title, deal.counterpartyLabel, deal.typeLabel, deal.roleLabel]
          .filter((value): value is string => Boolean(value))
          .some((value) => value.toLocaleLowerCase().includes(needle));
      return matchesQuery && (!statusFilter || deal.statusLabel === statusFilter);
    });
  }, [deals, query, statusFilter]);

  const openDetails = async (dealId: string) => {
    setSelectedId(dealId);
    setDetail(null);
    setDetailLoading(true);
    try {
      setDetail(await adapter.loadDealDetail({ tenantId, dealId }));
    } catch {
      setDetail({ state: "unavailable" });
    } finally {
      setDetailLoading(false);
    }
  };

  const closeDetails = () => {
    setSelectedId(null);
    setDetail(null);
  };

  const exportVisibleDeals = async () => {
    if (!adapter.exportDeals || filteredDeals.length === 0) return;
    setExportState("idle");
    try {
      await adapter.exportDeals({ tenantId, deals: filteredDeals });
      setExportState("success");
    } catch {
      setExportState("error");
    }
  };

  const selectedDeal = deals.find((deal) => deal.id === selectedId) ?? null;
  const showUnavailable = listState === "unavailable";
  const showRestricted = listState === "restricted";
  const showEmpty = listState === "empty" || (listState === "ready" && deals.length === 0);

  return (
    <main className="feature-page escrow-business-page">
      <div className="page-heading escrow-business-heading">
        <div>
          <span className="eyebrow">{copy.eyebrow}</span>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <AppButton
          disabled={!adapter.exportDeals || filteredDeals.length === 0 || listState !== "ready"}
          leadingIcon="download"
          onClick={() => void exportVisibleDeals()}
          type="button"
          variant="secondary"
        >
          {copy.exportLabel}
        </AppButton>
      </div>

      {!adapter.exportDeals ? (
        <p className="escrow-export-note" role="note">
          <Icon name="info" /> {copy.exportUnavailable}
        </p>
      ) : null}
      {exportState === "success" ? (
        <p className="escrow-export-success" role="status">
          {copy.exportSuccess}
        </p>
      ) : null}
      {exportState === "error" ? (
        <p className="escrow-export-error" role="alert">
          {copy.exportError}
        </p>
      ) : null}

      <SurfaceCard className="escrow-deals-toolbar">
        <label className="table-search escrow-deals-search">
          <Icon name="search" />
          <span className="sr-only">{copy.searchLabel}</span>
          <input
            onChange={(event) => setQuery(event.target.value)}
            placeholder={copy.searchPlaceholder}
            type="search"
            value={query}
          />
        </label>
        <label className="escrow-deals-filter">
          <span>{copy.statusFilterLabel}</span>
          <select
            aria-label={copy.statusFilterLabel}
            onChange={(event) => setStatusFilter(event.target.value)}
            value={statusFilter}
          >
            <option value="">{copy.allStatuses}</option>
            {statuses.map((status) => (
              <option key={status} value={status}>
                {status}
              </option>
            ))}
          </select>
        </label>
        {listState === "ready" ? (
          <span className="escrow-deals-count" aria-live="polite">
            {copy.countLabel(filteredDeals.length, deals.length)}
          </span>
        ) : null}
      </SurfaceCard>

      {listState === "loading" ? <LoadingState label={copy.loading} /> : null}
      {listState === "error" ? (
        <ErrorState
          body={copy.errorBody}
          onRetry={() => void load()}
          retryLabel={copy.retry}
          title={copy.errorTitle}
        />
      ) : null}
      {showUnavailable ? (
        <EmptyState body={copy.unavailableBody} title={copy.unavailableTitle} />
      ) : null}
      {showRestricted ? (
        <EmptyState body={copy.restrictedBody} title={copy.restrictedTitle} />
      ) : null}
      {showEmpty ? <EmptyState body={copy.emptyBody} title={copy.emptyTitle} /> : null}
      {listState === "ready" && deals.length > 0 && filteredDeals.length === 0 ? (
        <EmptyState body={copy.noResultsBody} title={copy.noResultsTitle} />
      ) : null}

      {listState === "ready" && filteredDeals.length > 0 ? (
        <SurfaceCard className="escrow-deals-table-card">
          <div className="escrow-deals-table-scroll">
            <table className="escrow-deals-table">
              <thead>
                <tr>
                  <th scope="col">{copy.dealColumn}</th>
                  <th scope="col">{copy.counterpartyColumn}</th>
                  <th scope="col">{copy.typeColumn}</th>
                  <th scope="col">{copy.amountColumn}</th>
                  <th scope="col">{copy.roleColumn}</th>
                  <th scope="col">{copy.statusColumn}</th>
                  <th scope="col">{copy.updatedColumn}</th>
                  <th scope="col">
                    <span className="sr-only">{copy.actionsColumn}</span>
                  </th>
                </tr>
              </thead>
              <tbody>
                {filteredDeals.map((deal) => (
                  <tr key={deal.id} className={selectedId === deal.id ? "is-selected" : undefined}>
                    <td data-label={copy.dealColumn}>
                      <button
                        aria-label={`${copy.openDetails}: ${deal.title}`}
                        className="escrow-deal-open"
                        onClick={() => void openDetails(deal.id)}
                        type="button"
                      >
                        <strong>{deal.title}</strong>
                        <small>{deal.referenceLabel}</small>
                      </button>
                    </td>
                    <td data-label={copy.counterpartyColumn}>
                      {deal.counterpartyLabel ?? copy.notSupplied}
                    </td>
                    <td data-label={copy.typeColumn}>{deal.typeLabel ?? copy.notSupplied}</td>
                    <td className="escrow-deal-amount" data-label={copy.amountColumn}>
                      {deal.amountLabel ?? copy.notSupplied}
                    </td>
                    <td data-label={copy.roleColumn}>{deal.roleLabel ?? copy.notSupplied}</td>
                    <td data-label={copy.statusColumn}>
                      <StatusChip tone={deal.statusTone ?? "neutral"}>
                        {deal.statusLabel}
                      </StatusChip>
                    </td>
                    <td data-label={copy.updatedColumn}>{deal.updatedLabel ?? copy.notSupplied}</td>
                    <td data-label={copy.actionsColumn}>
                      <button
                        aria-label={`${copy.openDetails}: ${deal.title}`}
                        className="escrow-deal-icon-button"
                        onClick={() => void openDetails(deal.id)}
                        type="button"
                      >
                        <Icon name="chevron" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </SurfaceCard>
      ) : null}

      {selectedId && selectedDeal ? (
        <div
          className="escrow-drawer-backdrop"
          onMouseDown={(event) => event.target === event.currentTarget && closeDetails()}
        >
          <aside
            aria-label={copy.drawerTitle}
            aria-modal="true"
            className="escrow-deal-drawer"
            role="dialog"
          >
            <header className="escrow-drawer-header">
              <div>
                <span className="eyebrow">{selectedDeal.referenceLabel}</span>
                <h2>{copy.drawerTitle}</h2>
              </div>
              <button
                aria-label={copy.close}
                className="icon-button"
                onClick={closeDetails}
                type="button"
              >
                <Icon name="close" />
              </button>
            </header>
            <div className="escrow-drawer-content">
              {detailLoading ? <LoadingState label={copy.drawerLoading} /> : null}
              {!detailLoading && detail?.state === "unavailable" ? (
                <EmptyState body={copy.unavailableBody} title={copy.drawerUnavailable} />
              ) : null}
              {!detailLoading && detail?.state === "restricted" ? (
                <EmptyState body={copy.restrictedBody} title={copy.drawerRestricted} />
              ) : null}
              {!detailLoading && detail?.state === "ready" ? (
                <>
                  <div className="escrow-drawer-deal-title">
                    <h3>{detail.detail.title}</h3>
                    <StatusChip tone={detail.detail.statusTone ?? "neutral"}>
                      {detail.detail.statusLabel}
                    </StatusChip>
                  </div>
                  <dl className="escrow-detail-rows">
                    {detail.detail.rows.map((row, index) => (
                      <div key={`${row.label}-${index}`}>
                        <dt>{row.label}</dt>
                        <dd>{row.value}</dd>
                      </div>
                    ))}
                  </dl>
                  {detail.detail.nextActionLabel ? (
                    <section className="escrow-next-action">
                      <h3>{copy.nextAction}</h3>
                      <p>{detail.detail.nextActionLabel}</p>
                    </section>
                  ) : null}
                </>
              ) : null}
            </div>
          </aside>
        </div>
      ) : null}
    </main>
  );
}
