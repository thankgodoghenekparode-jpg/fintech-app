import { fireEvent, render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { testCopy } from "../test_copy";
import { InvoicesPage } from "./invoices_page";
import type {
  InvoiceAdapter,
  InvoiceFilter,
  InvoiceReminderChannel,
  InvoiceRow,
} from "./invoice_types";

const invoice: InvoiceRow = {
  id: "host-invoice-id-1",
  displayNumber: "INV-1042",
  customerName: "Amina Textiles",
  issueDate: "2026-10-14",
  dueDate: "2026-11-14",
  amountKobo: 2_450_000,
  status: "overdue",
};

function adapterFixture(rows: readonly InvoiceRow[] = [invoice]) {
  const loadInvoices = vi.fn(async (_input: { tenantId: string; filter: InvoiceFilter }) => rows);
  const sendInvoice = vi.fn(
    async (_input: { tenantId: string; invoiceId: string; channel: InvoiceReminderChannel }) =>
      undefined,
  );
  const adapter: InvoiceAdapter = { loadInvoices, sendInvoice };
  return { adapter, loadInvoices, sendInvoice };
}

describe("W-MER-002 Invoices", () => {
  it("delegates invoice creation to an optional host navigation callback", async () => {
    const user = userEvent.setup();
    const fixture = adapterFixture();
    const onCreateInvoice = vi.fn();
    render(
      <InvoicesPage
        adapter={fixture.adapter}
        copy={testCopy.invoices}
        onCreateInvoice={onCreateInvoice}
        tenantId="tenant-test"
      />,
    );

    await user.click(screen.getByRole("button", { name: "Create invoice" }));
    expect(onCreateInvoice).toHaveBeenCalledOnce();
  });

  it("renders host rows, status filters and the selected detail", async () => {
    const user = userEvent.setup();
    const fixture = adapterFixture();
    render(
      <InvoicesPage adapter={fixture.adapter} copy={testCopy.invoices} tenantId="tenant-test" />,
    );

    expect(await screen.findByRole("heading", { name: "INV-1042" })).toBeInTheDocument();
    const row = screen.getByRole("row", { name: /INV-1042/ });
    expect(within(row).getByText("Amina Textiles")).toBeInTheDocument();
    expect(within(row).getByText("Overdue")).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: /bulk/i })).not.toBeInTheDocument();

    await user.click(screen.getByRole("tab", { name: "Paid" }));
    await waitFor(() =>
      expect(fixture.loadInvoices).toHaveBeenLastCalledWith({
        tenantId: "tenant-test",
        filter: "paid",
      }),
    );
  });

  it("sends one selected invoice using the documented channel through the adapter", async () => {
    const user = userEvent.setup();
    const fixture = adapterFixture();
    render(
      <InvoicesPage adapter={fixture.adapter} copy={testCopy.invoices} tenantId="tenant-test" />,
    );

    await user.click(await screen.findByRole("button", { name: "Send or remind" }));
    const dialog = screen.getByRole("dialog", { name: "Send invoice" });
    fireEvent.change(within(dialog).getByLabelText("Delivery channel"), {
      target: { value: "EMAIL" },
    });
    await user.click(within(dialog).getByRole("button", { name: "Send" }));

    await waitFor(() =>
      expect(fixture.sendInvoice).toHaveBeenCalledWith({
        tenantId: "tenant-test",
        invoiceId: "host-invoice-id-1",
        channel: "EMAIL",
      }),
    );
    expect(await screen.findByText("Send request completed.")).toBeInTheDocument();
  });

  it("renders empty and retryable error states", async () => {
    const user = userEvent.setup();
    const empty = adapterFixture([]);
    const emptyView = render(
      <InvoicesPage adapter={empty.adapter} copy={testCopy.invoices} tenantId="tenant-test" />,
    );
    expect(await screen.findByText("No invoices yet")).toBeInTheDocument();
    emptyView.unmount();

    let attempts = 0;
    const retryAdapter: InvoiceAdapter = {
      loadInvoices: vi.fn(async () => {
        attempts += 1;
        if (attempts === 1) throw new Error("offline in test");
        return [invoice];
      }),
      sendInvoice: vi.fn(async () => undefined),
    };
    render(<InvoicesPage adapter={retryAdapter} copy={testCopy.invoices} tenantId="tenant-test" />);
    expect(await screen.findByText("Invoices unavailable")).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Retry" }));
    expect(await screen.findByRole("heading", { name: "INV-1042" })).toBeInTheDocument();
  });
});
