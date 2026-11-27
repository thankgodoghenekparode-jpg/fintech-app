import { useEffect, useState } from "react";
import type { LoanBackofficeCopy } from "./loan_backoffice_copy";
import type {
  LoanApplicationDetail,
  LoanApplicationsAdapter,
  LoanApplicationsResult,
  LoanDecision,
  LoanPortfolioAdapter,
  LoanPortfolioResult,
} from "./loan_backoffice_types";
import {
  AppButton,
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  StatusChip,
  SurfaceCard,
} from "../components/ui";
import "./loan_backoffice_pages.css";

interface ApplicationsPageProps {
  readonly adapter: LoanApplicationsAdapter;
  readonly copy: LoanBackofficeCopy;
  readonly tenantId: string;
  readonly authorizeDecision?: (applicationId: string) => Promise<{
    readonly pinToken: string;
    readonly idempotencyKey: string;
  }>;
}

export function LoanApplicationsPage({
  adapter,
  authorizeDecision,
  copy,
  tenantId,
}: ApplicationsPageProps) {
  const [result, setResult] = useState<LoanApplicationsResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [selected, setSelected] = useState<LoanApplicationDetail | null>(null);
  const [decision, setDecision] = useState<LoanDecision | null>(null);
  const [reason, setReason] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [feedback, setFeedback] = useState("");

  async function load() {
    setLoading(true);
    setFailed(false);
    try {
      setResult(await adapter.loadApplications({ tenantId }));
    } catch {
      setFailed(true);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void load();
  }, [adapter, tenantId]);

  async function submitDecision() {
    if (!selected || !decision || !reason.trim()) {
      setFeedback(copy.applications.reasonRequired);
      return;
    }
    if (!authorizeDecision) {
      setFeedback(copy.applications.decisionUnavailable);
      return;
    }
    setSubmitting(true);
    setFeedback("");
    try {
      const authorization = await authorizeDecision(selected.id);
      await adapter.decideApplication({
        applicationId: selected.id,
        decision,
        reason: reason.trim(),
        ...authorization,
        tenantId,
      });
      setFeedback(copy.applications.decisionSubmitted);
      setDecision(null);
      setReason("");
      await load();
    } catch {
      setFeedback(copy.applications.decisionError);
    } finally {
      setSubmitting(false);
    }
  }

  const applications = result?.state === "ready" ? result.applications : [];
  return (
    <main className="feature-page loan-backoffice-page">
      <header className="page-heading">
        <div>
          <p className="eyebrow">{copy.applications.eyebrow}</p>
          <h1>{copy.applications.title}</h1>
          <p className="page-subtitle">{copy.applications.subtitle}</p>
        </div>
        {!loading && !failed && result?.state === "ready" ? (
          <span className="loan-count">
            {applications.length} {copy.applications.applicationCount}
          </span>
        ) : null}
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
      {!loading && !failed && result?.state === "restricted" ? (
        <Unavailable copy={copy} restricted />
      ) : null}
      {!loading && !failed && result?.state === "unavailable" ? <Unavailable copy={copy} /> : null}
      {!loading && !failed && result?.state === "empty" ? (
        <SurfaceCard>
          <EmptyState body={copy.common.emptyBody} title={copy.common.emptyTitle} />
        </SurfaceCard>
      ) : null}
      {!loading && !failed && result?.state === "ready" && applications.length === 0 ? (
        <SurfaceCard>
          <EmptyState body={copy.common.emptyBody} title={copy.common.emptyTitle} />
        </SurfaceCard>
      ) : null}
      {!loading && !failed && result?.state === "ready" && applications.length > 0 ? (
        <div className="loan-queue-layout">
          <SurfaceCard className="loan-table-card">
            <div className="loan-table-scroll">
              <table className="loan-data-table">
                <thead>
                  <tr>
                    <th>{copy.applications.reference}</th>
                    <th>{copy.applications.customer}</th>
                    <th>{copy.applications.score}</th>
                    <th>{copy.applications.reasons}</th>
                    <th>{copy.applications.exposure}</th>
                    <th>{copy.applications.sla}</th>
                    <th>{copy.applications.action}</th>
                  </tr>
                </thead>
                <tbody>
                  {applications.map((item) => (
                    <tr key={item.id} aria-selected={selected?.id === item.id}>
                      <td data-label={copy.applications.reference}>{item.reference}</td>
                      <td data-label={copy.applications.customer}>{item.maskedCustomer}</td>
                      <td data-label={copy.applications.score}>{item.scoreLabel}</td>
                      <td data-label={copy.applications.reasons}>
                        {item.reasons.join(", ") || copy.applications.noReasons}
                      </td>
                      <td data-label={copy.applications.exposure}>{item.exposureLabel}</td>
                      <td data-label={copy.applications.sla}>
                        <StatusChip tone="warning">
                          {item.slaLabel ?? copy.common.hostUnavailable}
                        </StatusChip>
                      </td>
                      <td data-label={copy.applications.action}>
                        <button
                          className="loan-text-action"
                          onClick={() => {
                            setSelected(item);
                            setDecision(null);
                            setReason("");
                            setFeedback("");
                          }}
                          type="button"
                        >
                          {copy.applications.open}
                          <Icon name="chevron" />
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </SurfaceCard>
          <aside aria-label={copy.applications.detailTitle} className="loan-detail-panel">
            {selected ? (
              <ApplicationDetail
                copy={copy}
                item={selected}
                decision={decision}
                feedback={feedback}
                reason={reason}
                submitting={submitting}
                canAuthorize={Boolean(authorizeDecision)}
                onDecision={setDecision}
                onReason={setReason}
                onSubmit={() => void submitDecision()}
              />
            ) : (
              <SurfaceCard>
                <div className="loan-detail-empty">
                  <Icon name="info" />
                  <p>{copy.applications.noSelection}</p>
                </div>
              </SurfaceCard>
            )}
          </aside>
        </div>
      ) : null}
      {!loading && !failed && result === null ? <Unavailable copy={copy} /> : null}
    </main>
  );
}

function ApplicationDetail({
  copy,
  item,
  decision,
  feedback,
  reason,
  submitting,
  canAuthorize,
  onDecision,
  onReason,
  onSubmit,
}: {
  readonly copy: LoanBackofficeCopy;
  readonly item: LoanApplicationDetail;
  readonly decision: LoanDecision | null;
  readonly feedback: string;
  readonly reason: string;
  readonly submitting: boolean;
  readonly canAuthorize: boolean;
  readonly onDecision: (value: LoanDecision) => void;
  readonly onReason: (value: string) => void;
  readonly onSubmit: () => void;
}) {
  return (
    <SurfaceCard className="loan-detail-card">
      <p className="eyebrow">{copy.applications.detailTitle}</p>
      <h2>{item.reference}</h2>
      <StatusChip tone="neutral">{item.maskedCustomer}</StatusChip>
      <dl className="loan-detail-values">
        {item.maskedCustomerView.map((entry) => (
          <div key={entry.label}>
            <dt>{entry.label}</dt>
            <dd>{entry.value}</dd>
          </div>
        ))}
        <div>
          <dt>{copy.applications.score}</dt>
          <dd>{item.scoreLabel}</dd>
        </div>
        <div>
          <dt>{copy.applications.exposure}</dt>
          <dd>{item.exposureLabel}</dd>
        </div>
      </dl>
      <section>
        <h3>{copy.applications.reasons}</h3>
        {item.reasons.length ? (
          <ul>
            {item.reasons.map((value) => (
              <li key={value}>{value}</li>
            ))}
          </ul>
        ) : (
          <p>{copy.applications.noReasons}</p>
        )}
      </section>
      <section>
        <h3>{copy.applications.customerView}</h3>
        <p>{item.maskedCustomerReference}</p>
      </section>
      <div className="loan-decision-actions">
        <AppButton
          disabled={!canAuthorize || submitting}
          onClick={() => onDecision("APPROVE")}
          type="button"
          variant="primary"
        >
          {copy.applications.approve}
        </AppButton>
        <AppButton
          disabled={!canAuthorize || submitting}
          onClick={() => onDecision("DECLINE")}
          type="button"
        >
          {copy.applications.decline}
        </AppButton>
      </div>
      {!canAuthorize ? (
        <p className="loan-inline-note">{copy.applications.decisionUnavailable}</p>
      ) : null}
      {decision ? (
        <div className="loan-decision-form">
          <label>
            {copy.applications.decisionReason}
            <textarea
              maxLength={1000}
              onChange={(event) => onReason(event.target.value)}
              placeholder={copy.applications.decisionReasonPlaceholder}
              required
              value={reason}
            />
          </label>
          <AppButton
            disabled={!reason.trim() || submitting}
            onClick={onSubmit}
            type="button"
            variant="primary"
          >
            {submitting ? copy.applications.decisionPending : copy.applications.submit}
          </AppButton>
        </div>
      ) : null}
      {feedback ? (
        <p aria-live="polite" className="loan-feedback" role="status">
          {feedback}
        </p>
      ) : null}
    </SurfaceCard>
  );
}

interface PortfolioPageProps {
  readonly adapter: LoanPortfolioAdapter;
  readonly copy: LoanBackofficeCopy;
  readonly tenantId: string;
}

export function LoanPortfolioPage({ adapter, copy, tenantId }: PortfolioPageProps) {
  const [result, setResult] = useState<LoanPortfolioResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [selectedCaseId, setSelectedCaseId] = useState<string | null>(null);

  async function load() {
    setLoading(true);
    setFailed(false);
    try {
      setResult(await adapter.loadPortfolio({ tenantId }));
    } catch {
      setFailed(true);
    } finally {
      setLoading(false);
    }
  }
  useEffect(() => {
    void load();
  }, [adapter, tenantId]);
  const snapshot = result?.state === "ready" ? result.snapshot : null;
  const selectedCase = snapshot?.hardshipCases.find((item) => item.id === selectedCaseId);
  return (
    <main className="feature-page loan-backoffice-page">
      <header className="page-heading">
        <div>
          <p className="eyebrow">{copy.portfolio.eyebrow}</p>
          <h1>{copy.portfolio.title}</h1>
          <p className="page-subtitle">{copy.portfolio.subtitle}</p>
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
      {!loading && !failed && result?.state === "restricted" ? (
        <Unavailable copy={copy} restricted />
      ) : null}
      {!loading && !failed && result?.state === "unavailable" ? <Unavailable copy={copy} /> : null}
      {!loading && !failed && result?.state === "empty" ? (
        <SurfaceCard>
          <EmptyState body={copy.common.emptyBody} title={copy.common.emptyTitle} />
        </SurfaceCard>
      ) : null}
      {!loading && !failed && snapshot ? (
        <>
          <section aria-label={copy.portfolio.metrics} className="loan-metric-grid">
            <h2 className="visually-hidden">{copy.portfolio.metrics}</h2>
            <MetricTile
              label={copy.portfolio.outstanding}
              value={snapshot.outstandingLabel}
              unavailable={copy.common.hostUnavailable}
            />
            <SurfaceCard className="loan-metric-card">
              <span>{copy.portfolio.parBuckets}</span>
              {snapshot.parBuckets.length ? (
                <ul className="loan-par-list">
                  {snapshot.parBuckets.map((bucket) => (
                    <li key={bucket.label}>
                      <span>{bucket.label}</span>
                      <strong>{bucket.value}</strong>
                    </li>
                  ))}
                </ul>
              ) : (
                <strong>{copy.common.hostUnavailable}</strong>
              )}
            </SurfaceCard>
            <MetricTile
              label={copy.portfolio.repaymentRate}
              value={snapshot.repaymentRateLabel}
              unavailable={copy.common.hostUnavailable}
            />
          </section>
          <SurfaceCard className="loan-portfolio-section">
            <header>
              <div>
                <h2>{copy.portfolio.arrears}</h2>
                <p>{copy.portfolio.contactRestrictions}</p>
              </div>
            </header>
            {snapshot.arrears.length ? (
              <div className="loan-table-scroll">
                <table className="loan-data-table">
                  <thead>
                    <tr>
                      <th>{copy.portfolio.customer}</th>
                      <th>{copy.portfolio.loan}</th>
                      <th>{copy.portfolio.daysPastDue}</th>
                      <th>{copy.portfolio.amountDue}</th>
                      <th>{copy.portfolio.contactHistory}</th>
                      <th>{copy.portfolio.approvedScripts}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {snapshot.arrears.map((row) => (
                      <tr key={row.id}>
                        <td data-label={copy.portfolio.customer}>{row.maskedCustomer}</td>
                        <td data-label={copy.portfolio.loan}>{row.loanReference}</td>
                        <td data-label={copy.portfolio.daysPastDue}>{row.daysPastDueLabel}</td>
                        <td data-label={copy.portfolio.amountDue}>{row.amountDueLabel}</td>
                        <td data-label={copy.portfolio.contactHistory}>
                          {row.contactHistory.length
                            ? row.contactHistory.join(" · ")
                            : copy.portfolio.noContactHistory}
                          {row.contactRestrictionLabel ? (
                            <small className="loan-cell-note">{row.contactRestrictionLabel}</small>
                          ) : null}
                        </td>
                        <td data-label={copy.portfolio.approvedScripts}>
                          {row.approvedScripts.length
                            ? row.approvedScripts.join("\n")
                            : copy.portfolio.noApprovedScripts}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <div className="loan-section-empty">{copy.common.emptyBody}</div>
            )}
          </SurfaceCard>
          <div className="loan-hardship-layout">
            <SurfaceCard className="loan-portfolio-section">
              <header>
                <div>
                  <h2>{copy.portfolio.hardshipCases}</h2>
                </div>
              </header>
              {snapshot.hardshipCases.length ? (
                <div className="loan-case-list">
                  {snapshot.hardshipCases.map((item) => (
                    <button
                      aria-pressed={selectedCaseId === item.id}
                      className="loan-case-row"
                      key={item.id}
                      onClick={() => setSelectedCaseId(item.id)}
                      type="button"
                    >
                      <span>
                        <strong>{item.maskedCustomer}</strong>
                        <small>{item.summary}</small>
                      </span>
                      <StatusChip tone="warning">{item.caseStatusLabel}</StatusChip>
                      <span className="loan-open-case">
                        {copy.portfolio.openCase}
                        <Icon name="chevron" />
                      </span>
                    </button>
                  ))}
                </div>
              ) : (
                <div className="loan-section-empty">{copy.common.emptyBody}</div>
              )}
            </SurfaceCard>
            <SurfaceCard className="loan-case-detail">
              <h2>{copy.portfolio.caseDetails}</h2>
              {selectedCase ? (
                <>
                  <StatusChip tone="warning">{selectedCase.caseStatusLabel}</StatusChip>
                  <p>
                    <strong>{selectedCase.maskedCustomer}</strong>
                  </p>
                  <p>{selectedCase.summary}</p>
                </>
              ) : (
                <p>{copy.portfolio.noCaseSelected}</p>
              )}
            </SurfaceCard>
          </div>
        </>
      ) : null}
      {!loading && !failed && result === null ? <Unavailable copy={copy} /> : null}
    </main>
  );
}

function MetricTile({
  label,
  value,
  unavailable,
}: {
  readonly label: string;
  readonly value?: string;
  readonly unavailable: string;
}) {
  return (
    <SurfaceCard className="loan-metric-card">
      <span>{label}</span>
      <strong>{value ?? unavailable}</strong>
    </SurfaceCard>
  );
}

function Unavailable({
  copy,
  restricted = false,
}: {
  readonly copy: LoanBackofficeCopy;
  readonly restricted?: boolean;
}) {
  return (
    <div className="loan-unavailable" role="status">
      <Icon name={restricted ? "shield" : "info"} />
      <div>
        <strong>{restricted ? copy.common.restrictedTitle : copy.common.unavailableTitle}</strong>
        <p>{restricted ? copy.common.restrictedBody : copy.common.unavailableBody}</p>
      </div>
    </div>
  );
}
