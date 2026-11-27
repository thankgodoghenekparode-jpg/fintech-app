import { useEffect, useState } from "react";
import type { LoanAdminCopy } from "./loan_admin_copy";
import type {
  LoanProductVersion,
  LoanProductsAdapter,
  LoanProductsResult,
  LoanSettlementPeriod,
  LoanSettlementsAdapter,
  LoanSettlementsResult,
} from "./loan_admin_types";
import {
  AppButton,
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  StatusChip,
  SurfaceCard,
} from "../components/ui";
import "./loan_admin_pages.css";

interface LoanProductsPageProps {
  readonly adapter: LoanProductsAdapter;
  readonly copy: LoanAdminCopy;
  readonly tenantId: string;
}

export function LoanProductsPage({ adapter, copy, tenantId }: LoanProductsPageProps) {
  const [result, setResult] = useState<LoanProductsResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [selected, setSelected] = useState<LoanProductVersion | null>(null);
  const [configText, setConfigText] = useState("");
  const [effectiveFrom, setEffectiveFrom] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [feedback, setFeedback] = useState("");

  async function load() {
    setLoading(true);
    setFailed(false);
    try {
      const next = await adapter.loadProducts({ tenantId });
      setResult(next);
      if (next.state === "ready" && !selected) setSelected(next.products[0] ?? null);
    } catch {
      setFailed(true);
    } finally {
      setLoading(false);
    }
  }
  useEffect(() => {
    void load();
  }, [adapter, tenantId]);

  function selectProduct(item: LoanProductVersion) {
    setSelected(item);
    setConfigText(JSON.stringify(item.config, null, 2));
    setEffectiveFrom("");
    setFeedback("");
  }

  async function propose() {
    if (!selected || result?.state !== "ready" || !result.canPropose) return;
    let config: unknown;
    try {
      config = JSON.parse(configText);
    } catch {
      setFeedback(copy.products.validConfig);
      return;
    }
    if (!config || typeof config !== "object" || Array.isArray(config)) {
      setFeedback(copy.products.validConfig);
      return;
    }
    const effectiveDate = new Date(effectiveFrom);
    if (!effectiveFrom || Number.isNaN(effectiveDate.getTime())) {
      setFeedback(copy.products.validDate);
      return;
    }
    setSubmitting(true);
    setFeedback("");
    try {
      await adapter.proposeProductVersion({
        config: config as Readonly<Record<string, unknown>>,
        effectiveFrom: effectiveDate.toISOString(),
        tenantId,
      });
      setFeedback(copy.products.proposalPending);
    } catch {
      setFeedback(copy.products.proposalError);
    } finally {
      setSubmitting(false);
    }
  }

  const products = result?.state === "ready" ? result.products : [];
  return (
    <main className="feature-page loan-admin-page">
      <header className="page-heading">
        <div>
          <p className="eyebrow">{copy.products.eyebrow}</p>
          <h1>{copy.products.title}</h1>
          <p className="page-subtitle">{copy.products.subtitle}</p>
        </div>
      </header>
      {loading ? <LoadingState label={copy.common.loading} /> : null}
      {!loading && failed ? (
        <ErrorState
          body={copy.common.errorBody}
          onRetry={() => void load()}
          retryLabel={copy.common.retry}
          title={copy.common.errorTitle}
        />
      ) : null}
      {!loading && !failed && result?.state === "unavailable" ? (
        <Unavailable copy={copy.common} />
      ) : null}
      {!loading && !failed && result?.state === "restricted" ? (
        <Unavailable copy={copy.common} restricted />
      ) : null}
      {!loading && !failed && result?.state === "empty" ? (
        <SurfaceCard>
          <EmptyState body={copy.common.emptyBody} title={copy.common.emptyTitle} />
        </SurfaceCard>
      ) : null}
      {!loading && !failed && result?.state === "ready" && !products.length ? (
        <SurfaceCard>
          <EmptyState body={copy.common.emptyBody} title={copy.common.emptyTitle} />
        </SurfaceCard>
      ) : null}
      {!loading && !failed && result?.state === "ready" && products.length ? (
        <div className="loan-admin-two-column">
          <SurfaceCard className="loan-admin-list">
            <header className="loan-admin-section-heading">
              <h2>{copy.products.listTitle}</h2>
              <span>{products.length}</span>
            </header>
            <div className="loan-version-list">
              {products.map((item) => (
                <button
                  aria-pressed={selected?.id === item.id}
                  className="loan-version-row"
                  key={item.id}
                  onClick={() => selectProduct(item)}
                  type="button"
                >
                  <span className="loan-version-icon">
                    <Icon name="invoice" />
                  </span>
                  <span className="loan-version-main">
                    <strong>{item.productLabel}</strong>
                    <small>
                      {item.versionLabel}
                      {item.effectiveFromLabel ? ` · ${item.effectiveFromLabel}` : ""}
                    </small>
                  </span>
                  <StatusChip tone={statusTone(item.statusLabel)}>{item.statusLabel}</StatusChip>
                </button>
              ))}
            </div>
          </SurfaceCard>
          <section className="loan-admin-editor">
            <SurfaceCard className="loan-admin-current">
              <p className="eyebrow">{copy.products.currentConfiguration}</p>
              <h2>{selected?.productLabel ?? copy.products.chooseProduct}</h2>
              {selected ? (
                <>
                  <StatusChip tone={statusTone(selected.statusLabel)}>
                    {selected.statusLabel}
                  </StatusChip>
                  <pre className="loan-config-preview">
                    {JSON.stringify(selected.config, null, 2)}
                  </pre>
                </>
              ) : null}
            </SurfaceCard>
            <SurfaceCard className="loan-admin-form">
              <header>
                <div>
                  <p className="eyebrow">{copy.products.eyebrow}</p>
                  <h2>{copy.products.configuration}</h2>
                </div>
              </header>
              <label className="loan-admin-field">
                {copy.products.configuration}
                <small>{copy.products.configHelp}</small>
                <textarea
                  aria-label={copy.products.configuration}
                  disabled={!result.canPropose || !selected || submitting}
                  onChange={(event) => setConfigText(event.target.value)}
                  spellCheck={false}
                  value={configText || (selected ? JSON.stringify(selected.config, null, 2) : "")}
                />
              </label>
              <label className="loan-admin-field">
                {copy.products.effectiveFrom}
                <small>{copy.products.effectiveDateHelp}</small>
                <input
                  aria-label={copy.products.effectiveFrom}
                  disabled={!result.canPropose || !selected || submitting}
                  onChange={(event) => setEffectiveFrom(event.target.value)}
                  type="datetime-local"
                  value={effectiveFrom}
                />
              </label>
              <div className="loan-dual-control-note">
                <Icon name="shield" />
                <span>{copy.products.permissionUnavailable}</span>
              </div>
              <AppButton
                disabled={!result.canPropose || !selected || submitting}
                onClick={() => void propose()}
                type="button"
                variant="primary"
              >
                {submitting ? copy.products.proposing : copy.products.propose}
              </AppButton>
              {feedback ? (
                <p aria-live="polite" className="loan-admin-feedback" role="status">
                  {feedback}
                </p>
              ) : null}
            </SurfaceCard>
          </section>
        </div>
      ) : null}
    </main>
  );
}

interface LoanSettlementsPageProps {
  readonly adapter: LoanSettlementsAdapter;
  readonly copy: LoanAdminCopy;
  readonly tenantId: string;
  readonly authorizeApproval?: (
    settlementId: string,
  ) => Promise<{ readonly idempotencyKey: string; readonly pinToken: string }>;
  readonly onExport?: (period: LoanSettlementPeriod) => Promise<void> | void;
}

export function LoanSettlementsPage({
  adapter,
  authorizeApproval,
  copy,
  onExport,
  tenantId,
}: LoanSettlementsPageProps) {
  const [result, setResult] = useState<LoanSettlementsResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [periodId, setPeriodId] = useState("");
  const [approving, setApproving] = useState(false);
  const [feedback, setFeedback] = useState("");
  const [exporting, setExporting] = useState(false);

  async function load() {
    setLoading(true);
    setFailed(false);
    try {
      const next = await adapter.loadSettlements({ tenantId });
      setResult(next);
      if (next.state === "ready" && !next.periods.some((period) => period.id === periodId))
        setPeriodId(next.periods[0]?.id ?? "");
    } catch {
      setFailed(true);
    } finally {
      setLoading(false);
    }
  }
  useEffect(() => {
    void load();
  }, [adapter, tenantId]);

  const periods = result?.state === "ready" ? result.periods : [];
  const selected = periods.find((item) => item.id === periodId) ?? periods[0];
  async function approve() {
    if (!selected?.canApprove || !authorizeApproval || approving) return;
    setApproving(true);
    setFeedback("");
    try {
      const credentials = await authorizeApproval(selected.id);
      await adapter.approveSettlement({ settlementId: selected.id, ...credentials, tenantId });
      setFeedback(copy.settlements.approvalAccepted);
    } catch {
      setFeedback(copy.settlements.approvalError);
    } finally {
      setApproving(false);
    }
  }
  async function exportStatement() {
    if (!selected || !onExport) return;
    setExporting(true);
    setFeedback("");
    try {
      await onExport(selected);
    } catch {
      setFeedback(copy.settlements.exportError);
    } finally {
      setExporting(false);
    }
  }

  return (
    <main className="feature-page loan-admin-page">
      <header className="page-heading">
        <div>
          <p className="eyebrow">{copy.settlements.eyebrow}</p>
          <h1>{copy.settlements.title}</h1>
          <p className="page-subtitle">{copy.settlements.subtitle}</p>
        </div>
      </header>
      {loading ? <LoadingState label={copy.common.loading} /> : null}
      {!loading && failed ? (
        <ErrorState
          body={copy.common.errorBody}
          onRetry={() => void load()}
          retryLabel={copy.common.retry}
          title={copy.common.errorTitle}
        />
      ) : null}
      {!loading && !failed && result?.state === "unavailable" ? (
        <Unavailable copy={copy.common} />
      ) : null}
      {!loading && !failed && result?.state === "restricted" ? (
        <Unavailable copy={copy.common} restricted />
      ) : null}
      {!loading &&
      !failed &&
      (result?.state === "empty" || (result?.state === "ready" && periods.length === 0)) ? (
        <SurfaceCard>
          <EmptyState body={copy.common.emptyBody} title={copy.common.emptyTitle} />
        </SurfaceCard>
      ) : null}
      {!loading && !failed && result?.state === "ready" && periods.length ? (
        <>
          <SurfaceCard className="loan-settlement-toolbar">
            <label>
              {copy.settlements.period}
              <select
                aria-label={copy.settlements.period}
                onChange={(event) => {
                  setPeriodId(event.target.value);
                  setFeedback("");
                }}
                value={selected?.id ?? ""}
              >
                {periods.map((period) => (
                  <option key={period.id} value={period.id}>
                    {period.periodLabel}
                  </option>
                ))}
              </select>
            </label>
            <StatusChip tone={statusTone(selected?.statusLabel ?? "")}>
              {selected?.statusLabel}
            </StatusChip>
          </SurfaceCard>
          {selected ? (
            <>
              <SurfaceCard className="loan-settlement-statement">
                <header className="loan-admin-section-heading">
                  <div>
                    <p className="eyebrow">{copy.settlements.statement}</p>
                    <h2>{selected.statementReference}</h2>
                  </div>
                  {selected.totalLabel ? (
                    <div className="loan-settlement-total">
                      <span>{copy.settlements.total}</span>
                      <strong>{selected.totalLabel}</strong>
                    </div>
                  ) : null}
                </header>
                <section className="loan-settlement-section">
                  <h3>{copy.settlements.splits}</h3>
                  {selected.splits.length ? (
                    <dl className="loan-split-list">
                      {selected.splits.map((split, index) => (
                        <div key={`${split.label}-${index}`}>
                          <dt>{split.label}</dt>
                          <dd>{split.valueLabel}</dd>
                        </div>
                      ))}
                    </dl>
                  ) : (
                    <p className="loan-section-empty">{copy.settlements.noSplits}</p>
                  )}
                </section>
                <section className="loan-settlement-section">
                  <h3>{copy.settlements.exceptions}</h3>
                  {selected.exceptions.length ? (
                    <ul className="loan-exception-list">
                      {selected.exceptions.map((exception) => (
                        <li key={exception.id}>
                          <StatusChip tone="warning">{exception.label}</StatusChip>
                          {exception.detail ? <p>{exception.detail}</p> : null}
                        </li>
                      ))}
                    </ul>
                  ) : (
                    <p className="loan-section-empty">{copy.settlements.noExceptions}</p>
                  )}
                </section>
                <footer className="loan-settlement-actions">
                  <AppButton
                    disabled={!onExport || exporting}
                    leadingIcon="download"
                    onClick={() => void exportStatement()}
                    type="button"
                  >
                    {exporting ? copy.settlements.export : copy.settlements.export}
                  </AppButton>
                  <AppButton
                    disabled={!selected.canApprove || !authorizeApproval || approving}
                    onClick={() => void approve()}
                    type="button"
                    variant="primary"
                  >
                    {approving ? copy.settlements.approving : copy.settlements.approve}
                  </AppButton>
                </footer>
                {!selected.canApprove || !authorizeApproval ? (
                  <p className="loan-admin-feedback">{copy.settlements.approvalUnavailable}</p>
                ) : null}
                {!onExport ? (
                  <p className="loan-admin-feedback">{copy.settlements.exportUnavailable}</p>
                ) : null}
                {feedback ? (
                  <p aria-live="polite" className="loan-admin-feedback" role="status">
                    {feedback}
                  </p>
                ) : null}
              </SurfaceCard>
            </>
          ) : null}
        </>
      ) : null}
    </main>
  );
}

function statusTone(status: string): "success" | "warning" | "error" | "neutral" {
  const value = status.toLowerCase();
  if (value.includes("complete") || value.includes("active")) return "success";
  if (value.includes("exception") || value.includes("reject") || value.includes("failed"))
    return "error";
  if (value.includes("pending") || value.includes("review")) return "warning";
  return "neutral";
}

function Unavailable({
  copy,
  restricted = false,
}: {
  readonly copy: LoanAdminCopy["common"];
  readonly restricted?: boolean;
}) {
  return (
    <div className="loan-unavailable" role="status">
      <Icon name={restricted ? "shield" : "info"} />
      <div>
        <strong>{restricted ? copy.restrictedTitle : copy.unavailableTitle}</strong>
        <p>{restricted ? copy.restrictedBody : copy.unavailableBody}</p>
      </div>
    </div>
  );
}
