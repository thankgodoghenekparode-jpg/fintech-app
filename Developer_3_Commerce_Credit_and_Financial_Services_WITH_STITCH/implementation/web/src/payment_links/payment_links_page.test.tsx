import { fireEvent, render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { testCopy } from "../test_copy";
import { PaymentLinksPage } from "./payment_links_page";
import type {
  CreatePaymentLinkInput,
  PaymentLinkAdapter,
  PaymentLinkFilter,
  PaymentLinkRow,
} from "./payment_link_types";

const link: PaymentLinkRow = {
  id: "host-link-id-1",
  description: "Weekly produce box",
  amountKobo: 125_050,
  expiresAt: "2026-12-01T12:00:00.000Z",
  multiUse: true,
  status: "active",
};

function adapterFixture(rows: readonly PaymentLinkRow[] = [link]) {
  const loadPaymentLinks = vi.fn(
    async (_input: { tenantId: string; filter: PaymentLinkFilter }) => rows,
  );
  const createPaymentLink = vi.fn(
    async (_input: { tenantId: string; request: CreatePaymentLinkInput }) => undefined,
  );
  const adapter: PaymentLinkAdapter = { loadPaymentLinks, createPaymentLink };
  return { adapter, loadPaymentLinks, createPaymentLink };
}

describe("W-MER-003 Payment links", () => {
  it("renders host rows and invokes the selected status filter", async () => {
    const user = userEvent.setup();
    const fixture = adapterFixture();
    render(
      <PaymentLinksPage
        adapter={fixture.adapter}
        copy={testCopy.paymentLinks}
        tenantId="tenant-test"
      />,
    );

    const linkRow = await screen.findByRole("row", { name: /Weekly produce box/ });
    expect(within(linkRow).getByText("Weekly produce box")).toBeInTheDocument();
    expect(within(linkRow).getByText("\u20a61,250.50")).toBeInTheDocument();
    expect(within(linkRow).getByText("Active")).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: /deactivate|analytics/i })).not.toBeInTheDocument();

    await user.click(screen.getByRole("tab", { name: "Expired" }));
    await waitFor(() =>
      expect(fixture.loadPaymentLinks).toHaveBeenLastCalledWith({
        tenantId: "tenant-test",
        filter: "expired",
      }),
    );
  });

  it("maps only documented fixed-link fields to the host adapter", async () => {
    const user = userEvent.setup();
    const fixture = adapterFixture();
    render(
      <PaymentLinksPage
        adapter={fixture.adapter}
        copy={testCopy.paymentLinks}
        tenantId="tenant-test"
      />,
    );
    await user.click(await screen.findByRole("button", { name: "Create payment link" }));

    const dialog = screen.getByRole("dialog", { name: "Create payment link" });
    fireEvent.change(within(dialog).getByLabelText("Amount (NGN)"), {
      target: { value: "1,234.56" },
    });
    fireEvent.change(within(dialog).getByLabelText("Description (optional)"), {
      target: { value: "Event tickets" },
    });
    await user.click(within(dialog).getByRole("button", { name: "Create link" }));

    await waitFor(() => expect(fixture.createPaymentLink).toHaveBeenCalledTimes(1));
    const call = fixture.createPaymentLink.mock.calls[0][0];
    expect(call.tenantId).toBe("tenant-test");
    expect(call.request).toEqual({
      kind: "LINK",
      amountKobo: 123_456,
      description: "Event tickets",
      multiUse: true,
    });
  });

  it("creates an open-amount link without amountKobo and keeps empty/error states usable", async () => {
    const user = userEvent.setup();
    const fixture = adapterFixture([]);
    const view = render(
      <PaymentLinksPage
        adapter={fixture.adapter}
        copy={testCopy.paymentLinks}
        tenantId="tenant-test"
      />,
    );
    expect(await screen.findByText("No payment links yet")).toBeInTheDocument();

    await user.click(screen.getAllByRole("button", { name: "Create payment link" })[0]);
    const dialog = screen.getByRole("dialog", { name: "Create payment link" });
    await user.click(within(dialog).getByLabelText("Open amount"));
    await user.click(within(dialog).getByRole("button", { name: "Create link" }));
    await waitFor(() => expect(fixture.createPaymentLink).toHaveBeenCalledTimes(1));
    expect(fixture.createPaymentLink.mock.calls[0][0].request).toEqual({
      kind: "LINK",
      multiUse: true,
    });
    view.unmount();

    const retryAdapter: PaymentLinkAdapter = {
      loadPaymentLinks: vi
        .fn()
        .mockRejectedValueOnce(new Error("offline in test"))
        .mockResolvedValue([]),
      createPaymentLink: vi.fn(async () => undefined),
    };
    render(
      <PaymentLinksPage
        adapter={retryAdapter}
        copy={testCopy.paymentLinks}
        tenantId="tenant-test"
      />,
    );
    expect(await screen.findByText("Payment links unavailable")).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Retry" }));
    expect(await screen.findByText("No payment links yet")).toBeInTheDocument();
  });
});
