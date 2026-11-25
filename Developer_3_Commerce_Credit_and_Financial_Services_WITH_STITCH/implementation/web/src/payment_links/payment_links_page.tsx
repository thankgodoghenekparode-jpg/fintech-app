import { useEffect, useMemo, useState } from "react";
import type { FormEvent } from "react";
import type { PaymentLinksCopy } from "../shared/copy";
import { formatDate, formatKobo, parseNairaToKobo } from "../shared/format";
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
  CreatePaymentLinkInput,
  PaymentLinkAdapter,
  PaymentLinkFilter,
  PaymentLinkRow,
} from "./payment_link_types";

interface PaymentLinksPageProps {
  readonly tenantId: string;
  readonly adapter: PaymentLinkAdapter;
  readonly copy: PaymentLinksCopy;
}

const filters: readonly PaymentLinkFilter[] = ["all", "active", "expired"];

export function PaymentLinksPage({ adapter, copy, tenantId }: PaymentLinksPageProps) {
  const [filter, setFilter] = useState<PaymentLinkFilter>("all");
  const [links, setLinks] = useState<readonly PaymentLinkRow[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [query, setQuery] = useState("");
  const [showCreate, setShowCreate] = useState(false);
  const [amountKind, setAmountKind] = useState<"fixed" | "open">("fixed");
  const [amount, setAmount] = useState("");
  const [description, setDescription] = useState("");
  const [expiresAt, setExpiresAt] = useState("");
  const [multiUse, setMultiUse] = useState(true);
  const [formError, setFormError] = useState("");
  const [creating, setCreating] = useState(false);
  const [feedback, setFeedback] = useState("");

  async function load() {
    setLoading(true);
    setLoadError(false);
    try {
      const result = await adapter.loadPaymentLinks({ tenantId, filter });
      setLinks(result);
      setSelectedId((current) =>
        current && result.some((link) => link.id === current) ? current : (result[0]?.id ?? null),
      );
    } catch {
      setLoadError(true);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    let active = true;
    setLoading(true);
    setLoadError(false);
    adapter
      .loadPaymentLinks({ tenantId, filter })
      .then((result) => {
        if (!active) return;
        setLinks(result);
        setSelectedId((current) =>
          current && result.some((link) => link.id === current) ? current : (result[0]?.id ?? null),
        );
      })
      .catch(() => active && setLoadError(true))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [adapter, filter, tenantId]);

  const visibleLinks = useMemo(() => {
    const normalized = query.trim().toLocaleLowerCase();
    if (!normalized) return links;
    return links.filter((link) => link.description.toLocaleLowerCase().includes(normalized));
  }, [links, query]);
  const selectedLink = visibleLinks.find((link) => link.id === selectedId) ?? null;

  function resetForm() {
    setAmountKind("fixed");
    setAmount("");
    setDescription("");
    setExpiresAt("");
    setMultiUse(true);
    setFormError("");
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (creating) return;

    const amountKobo = amountKind === "fixed" ? parseNairaToKobo(amount) : null;
    if (amountKind === "fixed" && amount.trim() === "") {
      setFormError(copy.amountRequired);
      return;
    }
    if (amountKind === "fixed" && amountKobo === null) {
      setFormError(copy.amountInvalid);
      return;
    }

    let expiryIso: string | undefined;
    if (expiresAt) {
      const parsed = new Date(expiresAt);
      if (Number.isNaN(parsed.getTime())) {
        setFormError(copy.expiryInvalid);
        return;
      }
      // The backend date-time convention remains an integration question; the host owns mapping.
      expiryIso = parsed.toISOString();
    }

    const request: CreatePaymentLinkInput = {
      kind: "LINK",
      ...(amountKobo === null ? {} : { amountKobo }),
      ...(description.trim() ? { description: description.trim() } : {}),
      ...(expiryIso ? { expiresAt: expiryIso } : {}),
      multiUse,
    };

    setCreating(true);
    setFormError("");
    try {
      await adapter.createPaymentLink({ tenantId, request });
      setShowCreate(false);
      resetForm();
      setFeedback(copy.created);
      await load();
    } catch {
      setFormError(copy.createError);
    } finally {
      setCreating(false);
    }
  }

  return (
    <div className="feature-page payment-links-page">
      <div className="page-heading">
        <div>
          <p className="eyebrow">{copy.eyebrow}</p>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <AppButton
          leadingIcon="plus"
          onClick={() => {
            resetForm();
            setShowCreate(true);
          }}
          type="button"
          variant="primary"
        >
          {copy.createLink}
        </AppButton>
      </div>

      <SurfaceCard className="list-card">
        <div className="list-toolbar">
          <div aria-label={copy.filterLabel} className="filter-tabs" role="tablist">
            {filters.map((value) => (
              <button
                aria-selected={filter === value}
                className={filter === value ? "filter-tab is-selected" : "filter-tab"}
                key={value}
                onClick={() => {
                  setFeedback("");
                  setFilter(value);
                }}
                role="tab"
                type="button"
              >
                {copy[value]}
              </button>
            ))}
          </div>
          <label className="table-search">
            <Icon name="search" />
            <span className="sr-only">{copy.searchLabel}</span>
            <input
              onChange={(event) => setQuery(event.target.value)}
              placeholder={copy.searchPlaceholder}
              type="search"
              value={query}
            />
          </label>
        </div>

        {feedback ? (
          <div aria-live="polite" className="feedback-banner">
            <Icon name="check" />
            {feedback}
          </div>
        ) : null}
        {loading ? <LoadingState label={copy.loading} /> : null}
        {!loading && loadError ? (
          <ErrorState
            body={copy.errorBody}
            onRetry={() => void load()}
            retryLabel={copy.retry}
            title={copy.errorTitle}
          />
        ) : null}
        {!loading && !loadError && links.length === 0 ? (
          <EmptyState
            action={
              <AppButton
                leadingIcon="plus"
                onClick={() => setShowCreate(true)}
                type="button"
                variant="primary"
              >
                {copy.createLink}
              </AppButton>
            }
            body={copy.emptyBody}
            title={copy.emptyTitle}
          />
        ) : null}
        {!loading && !loadError && links.length > 0 && visibleLinks.length === 0 ? (
          <EmptyState body={copy.noResultsBody} title={copy.noResultsTitle} />
        ) : null}
        {!loading && !loadError && visibleLinks.length > 0 ? (
          <div className="table-layout">
            <div className="data-table-wrap">
              <table className="data-table payment-link-table">
                <thead>
                  <tr>
                    <th scope="col">{copy.name}</th>
                    <th scope="col">{copy.type}</th>
                    <th className="align-right" scope="col">
                      {copy.amount}
                    </th>
                    <th scope="col">{copy.uses}</th>
                    <th scope="col">{copy.expires}</th>
                    <th scope="col">{copy.status}</th>
                  </tr>
                </thead>
                <tbody>
                  {visibleLinks.map((link) => (
                    <tr
                      aria-selected={selectedId === link.id}
                      className={selectedId === link.id ? "data-row is-selected" : "data-row"}
                      key={link.id}
                    >
                      <td>
                        <button
                          className="row-link"
                          onClick={() => setSelectedId(link.id)}
                          type="button"
                        >
                          {link.description}
                        </button>
                      </td>
                      <td>{link.multiUse ? copy.reusable : copy.singleUse}</td>
                      <td className="amount-cell">
                        {link.amountKobo === null ? copy.openAmount : formatKobo(link.amountKobo)}
                      </td>
                      <td>{link.multiUse ? copy.multiUse : copy.singleUse}</td>
                      <td>{link.expiresAt ? formatDate(link.expiresAt) : copy.noExpiry}</td>
                      <td>
                        <StatusChip tone={link.status === "active" ? "success" : "neutral"}>
                          {link.status === "active" ? copy.statusActive : copy.statusExpired}
                        </StatusChip>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            {selectedLink ? <PaymentLinkDetail copy={copy} link={selectedLink} /> : null}
          </div>
        ) : null}
      </SurfaceCard>

      {showCreate ? (
        <Modal onClose={() => !creating && setShowCreate(false)} title={copy.createDialogTitle}>
          <form className="modal-body" onSubmit={(event) => void submit(event)}>
            <p className="modal-description">{copy.createDialogBody}</p>
            <fieldset className="choice-fieldset">
              <legend className="field-label">{copy.amountType}</legend>
              <div className="choice-group">
                <label
                  className={amountKind === "fixed" ? "choice-option is-selected" : "choice-option"}
                >
                  <input
                    checked={amountKind === "fixed"}
                    name="amount-kind"
                    onChange={() => setAmountKind("fixed")}
                    type="radio"
                  />
                  {copy.fixedAmount}
                </label>
                <label
                  className={amountKind === "open" ? "choice-option is-selected" : "choice-option"}
                >
                  <input
                    checked={amountKind === "open"}
                    name="amount-kind"
                    onChange={() => setAmountKind("open")}
                    type="radio"
                  />
                  {copy.openAmount}
                </label>
              </div>
            </fieldset>
            {amountKind === "fixed" ? (
              <label className="form-field">
                <span className="field-label">{copy.amountLabel}</span>
                <input
                  aria-invalid={
                    formError === copy.amountRequired || formError === copy.amountInvalid
                  }
                  className="app-input"
                  inputMode="decimal"
                  onChange={(event) => {
                    setAmount(event.target.value);
                    setFormError("");
                  }}
                  placeholder={copy.amountPlaceholder}
                  value={amount}
                />
              </label>
            ) : null}
            <label className="form-field">
              <span className="field-label">{copy.description}</span>
              <input
                className="app-input"
                onChange={(event) => setDescription(event.target.value)}
                value={description}
              />
            </label>
            <label className="form-field">
              <span className="field-label">{copy.expiry}</span>
              <input
                className="app-input"
                onChange={(event) => {
                  setExpiresAt(event.target.value);
                  setFormError("");
                }}
                type="datetime-local"
                value={expiresAt}
              />
            </label>
            <fieldset className="choice-fieldset">
              <legend className="field-label">{copy.uses}</legend>
              <div className="choice-group">
                <label className={multiUse ? "choice-option is-selected" : "choice-option"}>
                  <input
                    checked={multiUse}
                    name="link-use"
                    onChange={() => setMultiUse(true)}
                    type="radio"
                  />
                  {copy.multiUse}
                </label>
                <label className={!multiUse ? "choice-option is-selected" : "choice-option"}>
                  <input
                    checked={!multiUse}
                    name="link-use"
                    onChange={() => setMultiUse(false)}
                    type="radio"
                  />
                  {copy.singleUse}
                </label>
              </div>
            </fieldset>
            {formError ? (
              <p className="field-error" role="alert">
                {formError}
              </p>
            ) : null}
            <div className="modal-actions">
              <AppButton
                disabled={creating}
                onClick={() => setShowCreate(false)}
                type="button"
                variant="secondary"
              >
                {copy.cancel}
              </AppButton>
              <AppButton disabled={creating} leadingIcon="plus" type="submit" variant="primary">
                {creating ? copy.creating : copy.create}
              </AppButton>
            </div>
          </form>
        </Modal>
      ) : null}
    </div>
  );
}

function PaymentLinkDetail({
  copy,
  link,
}: {
  readonly copy: PaymentLinksCopy;
  readonly link: PaymentLinkRow;
}) {
  return (
    <aside aria-label={copy.detailTitle} className="detail-panel">
      <div className="detail-heading">
        <div>
          <p className="eyebrow">{copy.detailTitle}</p>
          <h2>{link.description || copy.unnamedLink}</h2>
        </div>
        <StatusChip tone={link.status === "active" ? "success" : "neutral"}>
          {link.status === "active" ? copy.statusActive : copy.statusExpired}
        </StatusChip>
      </div>
      <dl className="detail-list">
        <div>
          <dt>{copy.type}</dt>
          <dd>{link.multiUse ? copy.reusable : copy.singleUse}</dd>
        </div>
        <div>
          <dt>{copy.amount}</dt>
          <dd className="detail-amount">
            {link.amountKobo === null ? copy.openAmount : formatKobo(link.amountKobo)}
          </dd>
        </div>
        <div>
          <dt>{copy.uses}</dt>
          <dd>{link.multiUse ? copy.multiUse : copy.singleUse}</dd>
        </div>
        <div>
          <dt>{copy.expires}</dt>
          <dd>{link.expiresAt ? formatDate(link.expiresAt) : copy.noExpiry}</dd>
        </div>
      </dl>
      <p className="detail-note">
        <Icon name="info" />
        {copy.linkReferenceUnavailable}
      </p>
    </aside>
  );
}
