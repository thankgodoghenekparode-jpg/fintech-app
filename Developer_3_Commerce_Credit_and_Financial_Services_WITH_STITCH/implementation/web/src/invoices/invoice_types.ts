export type InvoiceFilter = "all" | "unpaid" | "overdue" | "paid";
export type InvoiceStatus =
  "draft" | "sent" | "viewed" | "partiallyPaid" | "paid" | "overdue" | "void";
export type InvoiceReminderChannel = "LINK" | "SMS" | "EMAIL";

/** Host-facing presentation record. This is not an API response DTO. */
export interface InvoiceRow {
  readonly id: string;
  readonly displayNumber: string;
  readonly customerName: string;
  readonly issueDate: string;
  readonly dueDate: string;
  readonly amountKobo: number;
  readonly status: InvoiceStatus;
}

export interface InvoiceAdapter {
  loadInvoices(input: {
    readonly tenantId: string;
    readonly filter: InvoiceFilter;
  }): Promise<readonly InvoiceRow[]>;
  sendInvoice(input: {
    readonly tenantId: string;
    readonly invoiceId: string;
    readonly channel: InvoiceReminderChannel;
  }): Promise<void>;
}

export interface InvoiceAdapterError extends Error {
  readonly kind: "offline" | "rejected" | "unknown";
}

export function isInvoiceAdapterError(error: unknown): error is InvoiceAdapterError {
  return (
    error instanceof Error &&
    "kind" in error &&
    ["offline", "rejected", "unknown"].includes(String(error.kind))
  );
}
