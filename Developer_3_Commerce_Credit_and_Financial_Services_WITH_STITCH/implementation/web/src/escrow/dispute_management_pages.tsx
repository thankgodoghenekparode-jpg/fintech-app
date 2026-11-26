import { useCallback, useEffect, useMemo, useRef, useState, type FormEvent } from "react";
import {
  AppButton,
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  Modal,
  StatusChip,
  SurfaceCard,
} from "../components/ui";
import type {
  EscrowDecisionOutcome,
  EscrowDisputeCaseAdapter,
  EscrowDisputeCaseCopy,
  EscrowDisputeCaseDetail,
  EscrowDisputeQueueAdapter,
  EscrowDisputeQueueCopy,
  EscrowDisputeQueueItem,
} from "./dispute_management_types";
import "./dispute_management_pages.css";

interface QueuePageProps {
  readonly adapter: EscrowDisputeQueueAdapter;
  readonly copy: EscrowDisputeQueueCopy;
  readonly tenantId: string;
  readonly onOpenCase: (caseId: string) => void;
}

export function EscrowDisputeQueuePage({ adapter, copy, onOpenCase, tenantId }: QueuePageProps) {
  const [cases, setCases] = useState<readonly EscrowDisputeQueueItem[]>([]);
  const [state, setState] = useState<
    "loading" | "ready" | "empty" | "unavailable" | "restricted" | "error"
  >("loading");
  const [query, setQuery] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [valueFilter, setValueFilter] = useState("");
  const [ageFilter, setAgeFilter] = useState("");

  const load = useCallback(async () => {
    setState("loading");
    try {
      const result = await adapter.loadQueue({ tenantId });
      if (result.state === "ready") setCases(result.cases);
      else setCases([]);
      setState(result.state);
    } catch {
      setState("error");
    }
  }, [adapter, tenantId]);

  useEffect(() => {
    void load();
  }, [load]);

  const options = useMemo(
    () => ({
      types: [
        ...new Set(cases.flatMap((item) => (item.disputeTypeLabel ? [item.disputeTypeLabel] : []))),
      ],
      values: [
        ...new Set(cases.flatMap((item) => (item.valueBandLabel ? [item.valueBandLabel] : []))),
      ],
      ages: [...new Set(cases.flatMap((item) => (item.ageBandLabel ? [item.ageBandLabel] : [])))],
    }),
    [cases],
  );

  const filteredCases = useMemo(() => {
    const needle = query.trim().toLocaleLowerCase();
    return cases.filter((item) => {
      const searchFields = [
        item.caseReferenceLabel,
        item.dealReferenceLabel,
        item.dealTitle,
        item.disputeTypeLabel,
        item.responsiblePartyLabel,
      ].filter((value): value is string => Boolean(value));
      return (
        (!needle || searchFields.some((value) => value.toLocaleLowerCase().includes(needle))) &&
        (!typeFilter || item.disputeTypeLabel === typeFilter) &&
        (!valueFilter || item.valueBandLabel === valueFilter) &&
        (!ageFilter || item.ageBandLabel === ageFilter)
      );
    });
  }, [ageFilter, cases, query, typeFilter, valueFilter]);

  const isEmpty = state === "empty" || (state === "ready" && cases.length === 0);

  return (
    <main className="feature-page escrow-dispute-queue">
      <div className="page-heading escrow-dispute-heading">
        <div>
          <span className="eyebrow">{copy.eyebrow}</span>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
      </div>

      <SurfaceCard className="escrow-dispute-filters">
        <label className="table-search escrow-dispute-search">
          <Icon name="search" />
          <span className="sr-only">{copy.searchLabel}</span>
          <input
            value={query}
            onChange={(event) => setQuery(event.target.value)}
            placeholder={copy.searchPlaceholder}
            type="search"
          />
        </label>
        <QueueFilter
          label={copy.typeFilter}
          value={typeFilter}
          onChange={setTypeFilter}
          allLabel={copy.allTypes}
          options={options.types}
        />
        <QueueFilter
          label={copy.valueFilter}
          value={valueFilter}
          onChange={setValueFilter}
          allLabel={copy.allValues}
          options={options.values}
        />
        <QueueFilter
          label={copy.ageFilter}
          value={ageFilter}
          onChange={setAgeFilter}
          allLabel={copy.allAges}
          options={options.ages}
        />
        {state === "ready" ? (
          <span className="escrow-queue-count" aria-live="polite">
            {copy.queueCount(filteredCases.length, cases.length)}
          </span>
        ) : null}
      </SurfaceCard>

      {state === "loading" ? <LoadingState label={copy.loading} /> : null}
      {state === "error" ? (
        <ErrorState
          body={copy.errorBody}
          onRetry={() => void load()}
          retryLabel={copy.retry}
          title={copy.errorTitle}
        />
      ) : null}
      {state === "unavailable" ? (
        <EmptyState body={copy.unavailableBody} title={copy.unavailableTitle} />
      ) : null}
      {state === "restricted" ? (
        <EmptyState body={copy.restrictedBody} title={copy.restrictedTitle} />
      ) : null}
      {isEmpty ? <EmptyState body={copy.emptyBody} title={copy.emptyTitle} /> : null}
      {state === "ready" && cases.length > 0 && filteredCases.length === 0 ? (
        <EmptyState body={copy.noResultsBody} title={copy.noResultsTitle} />
      ) : null}

      {state === "ready" && filteredCases.length > 0 ? (
        <SurfaceCard className="escrow-queue-table-card">
          <div className="escrow-queue-table-scroll">
            <table className="escrow-queue-table">
              <thead>
                <tr>
                  <th scope="col">{copy.caseColumn}</th>
                  <th scope="col">{copy.dealColumn}</th>
                  <th scope="col">{copy.typeColumn}</th>
                  <th scope="col">{copy.valueColumn}</th>
                  <th scope="col">{copy.ageColumn}</th>
                  <th scope="col">{copy.statusColumn}</th>
                  <th scope="col">{copy.slaColumn}</th>
                  <th scope="col">{copy.responsibleColumn}</th>
                  <th scope="col">
                    <span className="sr-only">{copy.openCase}</span>
                  </th>
                </tr>
              </thead>
              <tbody>
                {filteredCases.map((item) => (
                  <tr key={item.id}>
                    <td data-label={copy.caseColumn}>
                      <strong>{item.caseReferenceLabel}</strong>
                    </td>
                    <td data-label={copy.dealColumn}>
                      <span className="escrow-queue-deal">{item.dealTitle}</span>
                      {item.dealReferenceLabel ? <small>{item.dealReferenceLabel}</small> : null}
                    </td>
                    <td data-label={copy.typeColumn}>
                      {item.disputeTypeLabel ?? copy.notSupplied}
                    </td>
                    <td className="escrow-queue-value" data-label={copy.valueColumn}>
                      {item.valueLabel ?? copy.notSupplied}
                    </td>
                    <td data-label={copy.ageColumn}>{item.ageLabel ?? copy.notSupplied}</td>
                    <td data-label={copy.statusColumn}>
                      <StatusChip tone={item.statusTone ?? "neutral"}>
                        {item.statusLabel}
                      </StatusChip>
                    </td>
                    <td data-label={copy.slaColumn}>
                      {item.slaBreached === true ? (
                        <StatusChip tone="error">{copy.breached}</StatusChip>
                      ) : item.slaLabel ? (
                        <StatusChip tone={item.slaTone ?? "neutral"}>{item.slaLabel}</StatusChip>
                      ) : (
                        copy.notSupplied
                      )}
                    </td>
                    <td data-label={copy.responsibleColumn}>
                      {item.responsiblePartyLabel ?? copy.notSupplied}
                    </td>
                    <td data-label={copy.openCase}>
                      <AppButton
                        aria-label={`${copy.openCase}: ${item.caseReferenceLabel}`}
                        leadingIcon="chevron"
                        onClick={() => onOpenCase(item.id)}
                        type="button"
                        variant="tertiary"
                      >
                        {copy.openCase}
                      </AppButton>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </SurfaceCard>
      ) : null}
    </main>
  );
}

function QueueFilter({
  allLabel,
  label,
  onChange,
  options,
  value,
}: {
  readonly allLabel: string;
  readonly label: string;
  readonly onChange: (value: string) => void;
  readonly options: readonly string[];
  readonly value: string;
}) {
  return (
    <label className="escrow-queue-filter">
      <span>{label}</span>
      <select aria-label={label} onChange={(event) => onChange(event.target.value)} value={value}>
        <option value="">{allLabel}</option>
        {options.map((option) => (
          <option key={option} value={option}>
            {option}
          </option>
        ))}
      </select>
    </label>
  );
}

interface DisputeCasePageProps {
  readonly adapter: EscrowDisputeCaseAdapter;
  readonly caseId: string;
  readonly copy: EscrowDisputeCaseCopy;
  readonly tenantId: string;
  readonly onBackToQueue: () => void;
}

const decisionOutcomes: readonly {
  readonly value: EscrowDecisionOutcome;
  readonly labelKey: "release" | "refund" | "split";
}[] = [
  { value: "RELEASE", labelKey: "release" },
  { value: "REFUND", labelKey: "refund" },
  { value: "SPLIT", labelKey: "split" },
];

export function EscrowDisputeCasePage({
  adapter,
  caseId,
  copy,
  onBackToQueue,
  tenantId,
}: DisputeCasePageProps) {
  const [detail, setDetail] = useState<EscrowDisputeCaseDetail | null>(null);
  const [state, setState] = useState<"loading" | "ready" | "unavailable" | "restricted" | "error">(
    "loading",
  );
  const [outcome, setOutcome] = useState<EscrowDecisionOutcome | "">("");
  const [splitSellerKobo, setSplitSellerKobo] = useState("");
  const [rationale, setRationale] = useState("");
  const [validation, setValidation] = useState<string[]>([]);
  const [confirming, setConfirming] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState("");
  const requestKey = useRef<string | null>(null);

  const load = useCallback(async () => {
    setState("loading");
    setError("");
    try {
      const result = await adapter.loadCase({ tenantId, caseId });
      if (result.state === "ready") setDetail(result.detail);
      else setDetail(null);
      setState(result.state);
    } catch {
      setDetail(null);
      setState("error");
    }
  }, [adapter, caseId, tenantId]);

  useEffect(() => {
    void load();
  }, [load]);

  const reviewDecision = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const issues: string[] = [];
    if (!outcome) issues.push(copy.requiredOutcome);
    if (!rationale.trim()) issues.push(copy.requiredRationale);
    if (outcome === "SPLIT" && splitSellerKobo && !/^\d+$/.test(splitSellerKobo.trim())) {
      issues.push(copy.invalidSplitAmount);
    }
    setValidation(issues);
    if (issues.length === 0) setConfirming(true);
  };

  const confirmDecision = async () => {
    if (
      !detail ||
      !outcome ||
      !detail.canDecide ||
      (detail.requiresSecondReview && !detail.secondReviewSatisfied)
    )
      return;
    setSubmitting(true);
    setError("");
    try {
      const pinToken = await adapter.authorizeDecision({ tenantId, caseId });
      if (!pinToken) throw new Error("Host authorization was not granted.");
      requestKey.current ??= createIdempotencyKey();
      await adapter.submitDecision({
        tenantId,
        caseId,
        idempotencyKey: requestKey.current,
        pinToken,
        outcome,
        ...(outcome === "SPLIT" && splitSellerKobo.trim()
          ? { splitSellerKobo: Number(splitSellerKobo) }
          : {}),
        rationale: rationale.trim(),
      });
      setSubmitted(true);
      setConfirming(false);
    } catch {
      setError(copy.submitError);
      setConfirming(false);
    } finally {
      setSubmitting(false);
    }
  };

  const canSubmit =
    Boolean(detail?.canDecide) &&
    !(detail?.requiresSecondReview && !detail.secondReviewSatisfied) &&
    !submitting &&
    !submitted;

  return (
    <main className="feature-page escrow-dispute-case">
      <div className="page-heading escrow-case-heading">
        <div>
          <span className="eyebrow">{copy.eyebrow}</span>
          <h1>{copy.title}</h1>
          {detail ? (
            <p className="page-subtitle">
              {detail.caseReferenceLabel} · {detail.dealReferenceLabel ?? copy.notSupplied}
            </p>
          ) : null}
        </div>
        <AppButton leadingIcon="chevron" onClick={onBackToQueue} type="button" variant="secondary">
          {copy.backToQueue}
        </AppButton>
      </div>

      {state === "loading" ? <LoadingState label={copy.loading} /> : null}
      {state === "error" ? (
        <ErrorState
          body={copy.unavailableBody}
          onRetry={() => void load()}
          retryLabel={copy.retry}
          title={copy.unavailableTitle}
        />
      ) : null}
      {state === "unavailable" ? (
        <EmptyState body={copy.unavailableBody} title={copy.unavailableTitle} />
      ) : null}
      {state === "restricted" ? (
        <EmptyState body={copy.restrictedBody} title={copy.restrictedTitle} />
      ) : null}

      {state === "ready" && detail ? (
        <>
          <div className="escrow-case-status-banner">
            <div>
              <span className="eyebrow">{detail.dealTitle}</span>
              <strong>{detail.caseTypeLabel ?? copy.notSupplied}</strong>
            </div>
            <StatusChip tone={detail.statusTone ?? "neutral"}>{detail.statusLabel}</StatusChip>
          </div>

          <div className="escrow-case-grid">
            <div className="escrow-case-main-column">
              <SurfaceCard className="escrow-case-panel">
                <h2>
                  <Icon name="info" />
                  {copy.caseSummary}
                </h2>
                <p>{detail.summary ?? copy.notSupplied}</p>
                <dl className="escrow-case-facts">
                  <Fact label="Buyer" value={detail.buyerLabel ?? copy.notSupplied} />
                  <Fact label="Seller" value={detail.sellerLabel ?? copy.notSupplied} />
                  <Fact
                    label={copy.decisionDeadline}
                    value={detail.decisionDeadlineLabel ?? copy.notSupplied}
                  />
                  <Fact
                    label={copy.feeOutcome}
                    value={detail.feeOutcomeLabel ?? copy.notSupplied}
                  />
                </dl>
                <p className="escrow-case-contract-note">
                  <Icon name="info" />
                  {copy.feeOutcomeContractGap}
                </p>
              </SurfaceCard>

              <SurfaceCard className="escrow-case-panel">
                <h2>
                  <Icon name="invoice" />
                  {copy.termsSnapshot}
                </h2>
                {detail.termsSnapshot.length ? (
                  <dl className="escrow-case-facts">
                    {detail.termsSnapshot.map((row, index) => (
                      <Fact key={`${row.label}-${index}`} label={row.label} value={row.value} />
                    ))}
                  </dl>
                ) : (
                  <p>{copy.notSupplied}</p>
                )}
              </SurfaceCard>

              <SurfaceCard className="escrow-case-panel">
                <h2>
                  <Icon name="reports" />
                  {copy.evidence}
                </h2>
                {detail.evidence.length ? (
                  <ul className="escrow-case-evidence">
                    {detail.evidence.map((item, index) => (
                      <li key={`${item.label}-${index}`}>
                        <Icon name="invoice" />
                        <span>
                          <strong>{item.label}</strong>
                          <small>
                            {[item.submittedByLabel, item.submittedAtLabel]
                              .filter(Boolean)
                              .join(" · ") || copy.notSupplied}
                          </small>
                        </span>
                        {item.signedUrl ? (
                          <a href={item.signedUrl} rel="noreferrer" target="_blank">
                            Open
                          </a>
                        ) : (
                          <span className="escrow-evidence-unavailable">{copy.notSupplied}</span>
                        )}
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p>{copy.noEvidence}</p>
                )}
              </SurfaceCard>

              <SurfaceCard className="escrow-case-panel">
                <h2>
                  <Icon name="clock" />
                  {copy.caseHistory}
                </h2>
                {detail.history.length ? (
                  <ol className="escrow-case-history">
                    {detail.history.map((event, index) => (
                      <li key={`${event.label}-${index}`}>
                        <span className="escrow-history-dot" />
                        <div>
                          <strong>{event.label}</strong>
                          <p>{event.description ?? copy.notSupplied}</p>
                          <small>{event.timestampLabel ?? copy.notSupplied}</small>
                        </div>
                      </li>
                    ))}
                  </ol>
                ) : (
                  <p>{copy.noHistory}</p>
                )}
              </SurfaceCard>
            </div>

            <div className="escrow-case-side-column">
              <SurfaceCard className="escrow-case-panel escrow-appeal-panel">
                <h2>
                  <Icon name="warning" />
                  {copy.appealHandling}
                </h2>
                <p>{detail.appealStatusLabel ?? copy.notSupplied}</p>
                <div>
                  <strong>{copy.secondReview}</strong>
                  <span>{detail.secondReviewStatusLabel ?? copy.notSupplied}</span>
                </div>
              </SurfaceCard>

              <SurfaceCard className="escrow-case-panel escrow-decision-panel">
                <h2>{copy.decision}</h2>
                {detail.restrictionMessage ? (
                  <p className="escrow-decision-restriction" role="note">
                    {detail.restrictionMessage}
                  </p>
                ) : null}
                {detail.requiresSecondReview && !detail.secondReviewSatisfied ? (
                  <p className="escrow-decision-restriction" role="note">
                    {detail.secondReviewStatusLabel ?? copy.secondReview}
                  </p>
                ) : null}
                {submitted ? (
                  <p className="escrow-decision-success" role="status">
                    {copy.decisionRecorded}
                  </p>
                ) : null}
                {error ? (
                  <p className="escrow-decision-error" role="alert">
                    {error}
                  </p>
                ) : null}
                <form onSubmit={reviewDecision}>
                  <label className="escrow-decision-field">
                    <span>{copy.outcome}</span>
                    <select
                      disabled={!detail.canDecide || submitted}
                      value={outcome}
                      onChange={(event) =>
                        setOutcome(event.target.value as EscrowDecisionOutcome | "")
                      }
                    >
                      <option value="">{copy.notSupplied}</option>
                      {decisionOutcomes.map((option) => (
                        <option key={option.value} value={option.value}>
                          {copy[option.labelKey]}
                        </option>
                      ))}
                    </select>
                  </label>
                  {outcome === "SPLIT" ? (
                    <label className="escrow-decision-field">
                      <span>{copy.splitSellerAmount}</span>
                      <input
                        disabled={!detail.canDecide || submitted}
                        inputMode="numeric"
                        onChange={(event) => setSplitSellerKobo(event.target.value)}
                        value={splitSellerKobo}
                      />
                      <small>{copy.splitUnitHelp}</small>
                    </label>
                  ) : null}
                  <label className="escrow-decision-field">
                    <span>{copy.rationale}</span>
                    <textarea
                      disabled={!detail.canDecide || submitted}
                      onChange={(event) => setRationale(event.target.value)}
                      placeholder={copy.rationalePlaceholder}
                      rows={5}
                      value={rationale}
                    />
                  </label>
                  {validation.map((issue) => (
                    <p className="escrow-decision-error" key={issue} role="alert">
                      {issue}
                    </p>
                  ))}
                  <AppButton disabled={!canSubmit} type="submit" variant="primary">
                    {copy.reviewDecision}
                  </AppButton>
                </form>
                {!detail.canDecide && !detail.restrictionMessage ? (
                  <p className="escrow-decision-restriction">{copy.decisionUnavailable}</p>
                ) : null}
              </SurfaceCard>
            </div>
          </div>
        </>
      ) : null}

      {confirming ? (
        <Modal onClose={() => !submitting && setConfirming(false)} title={copy.confirmTitle}>
          <div className="escrow-decision-confirm">
            <p>{copy.confirmBody}</p>
            <dl>
              <Fact
                label={copy.outcome}
                value={
                  outcome
                    ? copy[decisionOutcomes.find((item) => item.value === outcome)!.labelKey]
                    : copy.notSupplied
                }
              />
              {outcome === "SPLIT" && splitSellerKobo ? (
                <Fact label={copy.splitSellerAmount} value={splitSellerKobo} />
              ) : null}
              <Fact label={copy.rationale} value={rationale.trim()} />
            </dl>
            <div>
              <AppButton
                disabled={submitting}
                onClick={() => setConfirming(false)}
                type="button"
                variant="secondary"
              >
                {copy.cancel}
              </AppButton>
              <AppButton
                disabled={submitting}
                onClick={() => void confirmDecision()}
                type="button"
                variant="primary"
              >
                {submitting ? copy.loading : copy.confirmSubmit}
              </AppButton>
            </div>
          </div>
        </Modal>
      ) : null}
    </main>
  );
}

function Fact({ label, value }: { readonly label: string; readonly value: string }) {
  return (
    <div>
      <dt>{label}</dt>
      <dd>{value}</dd>
    </div>
  );
}

function createIdempotencyKey(): string {
  const bytes = crypto.getRandomValues(new Uint8Array(16));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  const hex = [...bytes].map((byte) => byte.toString(16).padStart(2, "0"));
  return `${hex.slice(0, 4).join("")}-${hex.slice(4, 6).join("")}-${hex.slice(6, 8).join("")}-${hex.slice(8, 10).join("")}-${hex.slice(10).join("")}`;
}
