import { useEffect, useMemo, useState } from "react";
import type { InvoicesCopy } from "../shared/copy";
import { formatDate, formatKobo } from "../shared/format";
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
  InvoiceAdapter,
  InvoiceFilter,
  InvoiceReminderChannel,
  InvoiceRow,
  InvoiceStatus,
} from "./invoice_types";

interface InvoicesPageProps {
  readonly tenantId: string;
  readonly adapter: InvoiceAdapter;
  readonly copy: InvoicesCopy;
  readonly onCreateInvoice?: () => void;
}

const filters: readonly InvoiceFilter[] = ["all", "unpaid", "overdue", "paid"];

export function InvoicesPage({ adapter, copy, onCreateInvoice, tenantId }: InvoicesPageProps) {
  const [filter, setFilter] = useState<InvoiceFilter>("all");
  const [invoices, setInvoices] = useState<readonly InvoiceRow[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [query, setQuery] = useState("");
  const [reminderTarget, setReminderTarget] = useState<InvoiceRow | null>(null);
  const [channel, setChannel] = useState<InvoiceReminderChannel>("LINK");
  const [sending, setSending] = useState(false);
  const [sendError, setSendError] = useState(false);
  const [feedback, setFeedback] = useState("");

  async function load() {
    setLoading(true);
    setLoadError(false);
    try {
      const result = await adapter.loadInvoices({ tenantId, filter });
      setInvoices(result);
      setSelectedId((current) =>
        current && result.some((invoice) => invoice.id === current)
          ? current
          : (result[0]?.id ?? null),
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
      .loadInvoices({ tenantId, filter })
      .then((result) => {
        if (!active) return;
        setInvoices(result);
        setSelectedId((current) =>
          current && result.some((invoice) => invoice.id === current)
            ? current
            : (result[0]?.id ?? null),
        );
      })
      .catch(() => active && setLoadError(true))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [adapter, filter, tenantId]);

  const visibleInvoices = useMemo(() => {
    const normalized = query.trim().toLocaleLowerCase();
    if (!normalized) return invoices;
    return invoices.filter((invoice) =>
      `${invoice.displayNumber} ${invoice.customerName}`.toLocaleLowerCase().includes(normalized),
    );
  }, [invoices, query]);
  const selectedInvoice = visibleInvoices.find((invoice) => invoice.id === selectedId) ?? null;

  async function sendReminder() {
    if (!reminderTarget || sending) return;
    setSending(true);
    setSendError(false);
    try {
      await adapter.sendInvoice({
        tenantId,
        invoiceId: reminderTarget.id,
        channel,
      });
      setReminderTarget(null);
      setFeedback(copy.sendSuccess);
    } catch {
      setSendError(true);
    } finally {
      setSending(false);
    }
  }

  return (
    <div className="feature-page invoices-page">
      <div className="page-heading">
        <div>
          <p className="eyebrow">{copy.eyebrow}</p>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <AppButton
          disabled={!onCreateInvoice}
          leadingIcon="plus"
          onClick={onCreateInvoice}
          type="button"
          variant="primary"
        >
          {copy.createInvoice}
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
        {!loading && !loadError && invoices.length === 0 ? (
          <EmptyState
            action={
              <AppButton
                disabled={!onCreateInvoice}
                leadingIcon="plus"
                onClick={onCreateInvoice}
                type="button"
                variant="primary"
              >
                {copy.createInvoice}
              </AppButton>
            }
            body={copy.emptyBody}
            title={copy.emptyTitle}
          />
        ) : null}
        {!loading && !loadError && invoices.length > 0 && visibleInvoices.length === 0 ? (
          <EmptyState body={copy.noResultsBody} title={copy.noResultsTitle} />
        ) : null}
        {!loading && !loadError && visibleInvoices.length > 0 ? (
          <div className="table-layout">
            <div className="data-table-wrap">
              <table className="data-table">
                <thead>
                  <tr>
                    <th scope="col">{copy.invoiceNumber}</th>
                    <th scope="col">{copy.customer}</th>
                    <th scope="col">{copy.issueDate}</th>
                    <th scope="col">{copy.dueDate}</th>
                    <th className="align-right" scope="col">
                      {copy.amount}
                    </th>
                    <th scope="col">{copy.status}</th>
                  </tr>
                </thead>
                <tbody>
                  {visibleInvoices.map((invoice) => (
                    <tr
                      aria-selected={selectedId === invoice.id}
                      className={selectedId === invoice.id ? "data-row is-selected" : "data-row"}
                      key={invoice.id}
                      onClick={() => setSelectedId(invoice.id)}
                    >
                      <td>
                        <button
                          className="row-link"
                          onClick={() => setSelectedId(invoice.id)}
                          type="button"
                        >
                          {invoice.displayNumber}
                        </button>
                      </td>
                      <td>{invoice.customerName}</td>
                      <td>{formatDate(invoice.issueDate)}</td>
                      <td>{formatDate(invoice.dueDate)}</td>
                      <td className="amount-cell">{formatKobo(invoice.amountKobo)}</td>
                      <td>
                        <InvoiceStatusChip copy={copy} status={invoice.status} />
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {selectedInvoice ? (
              <InvoiceDetail
                copy={copy}
                invoice={selectedInvoice}
                onSend={() => {
                  setChannel("LINK");
                  setSendError(false);
                  setReminderTarget(selectedInvoice);
                }}
              />
            ) : null}
          </div>
        ) : null}
      </SurfaceCard>

      {reminderTarget ? (
        <Modal onClose={() => !sending && setReminderTarget(null)} title={copy.sendDialogTitle}>
          <div className="modal-body">
            <p className="modal-description">{copy.sendDialogBody}</p>
            <label className="field-label" htmlFor="invoice-channel">
              {copy.channelLabel}
            </label>
            <select
              className="app-input"
              disabled={sending}
              id="invoice-channel"
              onChange={(event) => setChannel(event.target.value as InvoiceReminderChannel)}
              value={channel}
            >
              <option value="LINK">{copy.linkChannel}</option>
              <option value="SMS">{copy.smsChannel}</option>
              <option value="EMAIL">{copy.emailChannel}</option>
            </select>
            {sendError ? (
              <p className="field-error" role="alert">
                {copy.sendError}
              </p>
            ) : null}
            <div className="modal-actions">
              <AppButton
                disabled={sending}
                onClick={() => setReminderTarget(null)}
                type="button"
                variant="secondary"
              >
                {copy.cancel}
              </AppButton>
              <AppButton
                disabled={sending}
                leadingIcon="send"
                onClick={() => void sendReminder()}
                type="button"
                variant="primary"
              >
                {sending ? copy.sending : copy.send}
              </AppButton>
            </div>
          </div>
        </Modal>
      ) : null}
    </div>
  );
}

function InvoiceDetail({
  copy,
  invoice,
  onSend,
}: {
  readonly copy: InvoicesCopy;
  readonly invoice: InvoiceRow;
  readonly onSend: () => void;
}) {
  return (
    <aside aria-label={copy.detailTitle} className="detail-panel">
      <div className="detail-heading">
        <div>
          <p className="eyebrow">{copy.detailTitle}</p>
          <h2>{invoice.displayNumber}</h2>
        </div>
        <InvoiceStatusChip copy={copy} status={invoice.status} />
      </div>
      <div className="detail-customer">
        <span aria-hidden="true" className="detail-avatar">
          {invoice.customerName.trim().slice(0, 1).toUpperCase()}
        </span>
        <div>
          <small>{copy.customer}</small>
          <strong>{invoice.customerName}</strong>
        </div>
      </div>
      <dl className="detail-list">
        <div>
          <dt>{copy.issueDate}</dt>
          <dd>{formatDate(invoice.issueDate)}</dd>
        </div>
        <div>
          <dt>{copy.dueDate}</dt>
          <dd>{formatDate(invoice.dueDate)}</dd>
        </div>
        <div>
          <dt>{copy.amount}</dt>
          <dd className="detail-amount">{formatKobo(invoice.amountKobo)}</dd>
        </div>
      </dl>
      <AppButton
        className="detail-action"
        leadingIcon="send"
        onClick={onSend}
        type="button"
        variant="primary"
      >
        {copy.sendInvoice}
      </AppButton>
    </aside>
  );
}

function InvoiceStatusChip({
  copy,
  status,
}: {
  readonly copy: InvoicesCopy;
  readonly status: InvoiceStatus;
}) {
  const labels: Record<InvoiceStatus, string> = {
    draft: copy.statusDraft,
    sent: copy.statusSent,
    viewed: copy.statusViewed,
    partiallyPaid: copy.statusPartiallyPaid,
    paid: copy.statusPaid,
    overdue: copy.statusOverdue,
    void: copy.statusVoid,
  };
  const tone =
    status === "paid"
      ? "success"
      : status === "overdue"
        ? "error"
        : status === "draft" || status === "sent"
          ? "warning"
          : "neutral";
  return <StatusChip tone={tone}>{labels[status]}</StatusChip>;
}
