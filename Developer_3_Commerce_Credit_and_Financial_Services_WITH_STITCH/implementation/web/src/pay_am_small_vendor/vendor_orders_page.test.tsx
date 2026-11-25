import { fireEvent, render, screen, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { vendorOrdersCopy } from "./vendor_batch_8_copy";
import { PasVendorOrdersPage } from "./vendor_orders_page";
import type {
  PasVendorOrder,
  PasVendorOrdersAdapter,
  PasVendorOrdersResult,
} from "./vendor_orders_types";

const sampleOrders: readonly PasVendorOrder[] = [
  {
    id: "order-1",
    orderReference: "SYN-ORD-001",
    buyerLabel: "Synthetic buyer A",
    itemLabel: "Synthetic product A",
    statusLabel: "Awaiting delivery code",
    statusTone: "warning",
    canConfirmDelivery: true,
    details: [{ label: "Order value", value: "Not supplied" }],
  },
  {
    id: "order-2",
    orderReference: "SYN-ORD-002",
    buyerLabel: "Synthetic buyer B",
    itemLabel: "Synthetic product B",
    statusLabel: "In transit",
    statusTone: "neutral",
    details: [{ label: "Order value", value: "Not supplied" }],
  },
];

function makeAdapter(
  loadOrders: () => Promise<PasVendorOrdersResult> = async () => ({
    state: "ready",
    orders: sampleOrders,
  }),
  confirmDelivered?: PasVendorOrdersAdapter["confirmDelivered"],
): PasVendorOrdersAdapter {
  return { loadOrders, ...(confirmDelivered ? { confirmDelivered } : {}) };
}

describe("W-PAS-003 Orders & Fulfilment", () => {
  it("shows host-supplied orders and filters by search and supplied status labels", async () => {
    const user = userEvent.setup();
    render(
      <PasVendorOrdersPage adapter={makeAdapter()} copy={vendorOrdersCopy} tenantId="tenant-1" />,
    );

    expect(await screen.findAllByText("SYN-ORD-001")).not.toHaveLength(0);
    expect(screen.getAllByText("SYN-ORD-002")).not.toHaveLength(0);
    await user.click(screen.getByRole("button", { name: /In transit/ }));
    expect(screen.queryByText("SYN-ORD-001")).not.toBeInTheDocument();
    expect(screen.getAllByText("SYN-ORD-002")).not.toHaveLength(0);
    await user.click(screen.getByRole("button", { name: /All orders/ }));
    fireEvent.change(screen.getByRole("searchbox", { name: "Search orders" }), {
      target: { value: "buyer b" },
    });
    expect(screen.queryByText("SYN-ORD-001")).not.toBeInTheDocument();
    expect(screen.getAllByText("SYN-ORD-002")).not.toHaveLength(0);
  });

  it("validates the documented six-digit code and sends it only through the host adapter", async () => {
    const user = userEvent.setup();
    const confirm = vi.fn(async () => undefined);
    render(
      <PasVendorOrdersPage
        adapter={makeAdapter(undefined, confirm)}
        copy={vendorOrdersCopy}
        tenantId="tenant-1"
      />,
    );
    await screen.findAllByText("SYN-ORD-001");
    const code = screen.getByRole("textbox", { name: "Buyer delivery code" });
    await user.type(code, "12a");
    await user.click(screen.getByRole("button", { name: "Confirm delivered" }));
    expect(await screen.findByRole("alert")).toHaveTextContent("Enter exactly six digits.");
    expect(confirm).not.toHaveBeenCalled();

    await user.clear(code);
    await user.type(code, "123456");
    await user.click(screen.getByRole("button", { name: "Confirm delivered" }));
    expect(await screen.findByRole("status")).toHaveTextContent(
      "The host accepted the delivery confirmation",
    );
    expect(confirm).toHaveBeenCalledWith({
      tenantId: "tenant-1",
      orderId: "order-1",
      deliveryCode: "123456",
    });
  });

  it("keeps delivery unavailable when host capability or adapter action is absent", async () => {
    render(
      <PasVendorOrdersPage adapter={makeAdapter()} copy={vendorOrdersCopy} tenantId="tenant-1" />,
    );
    await screen.findAllByText("SYN-ORD-001");
    expect(screen.getByRole("button", { name: "Confirm delivered" })).toBeDisabled();
    expect(screen.getByRole("button", { name: /Mark shipped is unavailable/ })).toBeDisabled();
    expect(screen.getByText(/no upload contract is documented/i)).toBeInTheDocument();
  });

  it("shows loading, retryable error, empty and restricted states", async () => {
    let resolveLoad!: (result: PasVendorOrdersResult) => void;
    const load = vi.fn(
      () =>
        new Promise<PasVendorOrdersResult>((resolve) => {
          resolveLoad = resolve;
        }),
    );
    const view = render(
      <PasVendorOrdersPage
        adapter={makeAdapter(load)}
        copy={vendorOrdersCopy}
        tenantId="tenant-1"
      />,
    );
    expect(screen.getByRole("status", { name: "Loading vendor orders" })).toBeInTheDocument();
    resolveLoad({ state: "empty" });
    expect(await screen.findByText("No orders supplied")).toBeInTheDocument();

    view.rerender(
      <PasVendorOrdersPage
        adapter={makeAdapter(async () => {
          throw new Error("offline");
        })}
        copy={vendorOrdersCopy}
        tenantId="tenant-1"
      />,
    );
    expect(await screen.findByText("Orders unavailable")).toBeInTheDocument();
    const retry = screen.getByRole("button", { name: "Retry" });
    expect(retry).toBeEnabled();

    view.rerender(
      <PasVendorOrdersPage
        adapter={makeAdapter(async () => ({ state: "restricted" }))}
        copy={vendorOrdersCopy}
        tenantId="tenant-1"
      />,
    );
    expect(await screen.findByText("Order access restricted")).toBeInTheDocument();
  });

  it("shows operation errors without changing host-supplied order state", async () => {
    const user = userEvent.setup();
    const confirm = vi.fn(async () => {
      throw new Error("rejected");
    });
    render(
      <PasVendorOrdersPage
        adapter={makeAdapter(undefined, confirm)}
        copy={vendorOrdersCopy}
        tenantId="tenant-1"
      />,
    );
    await screen.findAllByText("SYN-ORD-001");
    await user.type(screen.getByRole("textbox", { name: "Buyer delivery code" }), "654321");
    await user.click(screen.getByRole("button", { name: "Confirm delivered" }));
    expect(await screen.findByRole("alert")).toHaveTextContent(
      "The host could not confirm delivery",
    );
    expect(
      within(screen.getByRole("row", { name: /SYN-ORD-001/ })).getByText("Awaiting delivery code"),
    ).toBeInTheDocument();
  });
});
