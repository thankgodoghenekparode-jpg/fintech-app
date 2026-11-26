import { fireEvent, render, screen, waitFor, within } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { EscrowBusinessDealsPage } from "./my_deals_page";
import type {
  EscrowBusinessDeal,
  EscrowBusinessDealsAdapter,
  EscrowBusinessDealsCopy,
} from "./my_deals_types";

const rows: readonly EscrowBusinessDeal[] = [
  {
    id: "deal-a",
    referenceLabel: "SYN-001",
    title: "Synthetic goods example",
    counterpartyLabel: "Preview participant A",
    typeLabel: "Goods · sample",
    roleLabel: "Seller · sample",
    amountLabel: "Not supplied",
    statusLabel: "Active · sample",
    statusTone: "neutral",
    updatedLabel: "Not supplied",
  },
  {
    id: "deal-b",
    referenceLabel: "SYN-002",
    title: "Synthetic service example",
    counterpartyLabel: "Preview participant B",
    typeLabel: "Service · sample",
    roleLabel: "Buyer · sample",
    amountLabel: "Not supplied",
    statusLabel: "Waiting · sample",
    statusTone: "neutral",
  },
];

const copy: EscrowBusinessDealsCopy = {
  eyebrow: "ESCROW BUSINESS",
  title: "My deals",
  subtitle: "Synthetic preview records only.",
  loading: "Loading deals",
  retry: "Retry",
  errorTitle: "Deals unavailable",
  errorBody: "Try again.",
  unavailableTitle: "Listing unavailable",
  unavailableBody: "Host list is not connected.",
  restrictedTitle: "Access restricted",
  restrictedBody: "Access is restricted.",
  emptyTitle: "No deals supplied",
  emptyBody: "The host supplied no deals.",
  searchLabel: "Search deals",
  searchPlaceholder: "Search deals",
  statusFilterLabel: "Status",
  allStatuses: "All statuses",
  exportLabel: "Export",
  exportUnavailable: "Host export not connected.",
  exportError: "Export failed.",
  exportSuccess: "Host export completed.",
  countLabel: (filtered, total) => `${filtered} of ${total}`,
  dealColumn: "Deal",
  counterpartyColumn: "Counterparty",
  typeColumn: "Type",
  amountColumn: "Amount",
  roleColumn: "Role",
  statusColumn: "Status",
  updatedColumn: "Updated",
  actionsColumn: "Actions",
  openDetails: "Open details",
  noResultsTitle: "No matching deals",
  noResultsBody: "Change the search or filter.",
  drawerTitle: "Deal details",
  drawerLoading: "Loading details",
  drawerUnavailable: "Details unavailable",
  drawerRestricted: "Details restricted",
  nextAction: "Next action",
  notSupplied: "Not supplied",
  close: "Close details",
};

function makeAdapter(
  overrides: Partial<EscrowBusinessDealsAdapter> = {},
): EscrowBusinessDealsAdapter {
  return {
    loadDeals: vi.fn(async () => ({ state: "ready" as const, deals: rows })),
    loadDealDetail: vi.fn(async ({ dealId }) => ({
      state: "ready" as const,
      detail: {
        title: rows.find((deal) => deal.id === dealId)!.title,
        referenceLabel: "SYN-001",
        statusLabel: "Active · sample",
        rows: [{ label: "Data source", value: "Synthetic preview only" }],
        nextActionLabel: "Not supplied by host",
      },
    })),
    ...overrides,
  };
}

function renderPage(adapter: EscrowBusinessDealsAdapter = makeAdapter()) {
  return render(
    <EscrowBusinessDealsPage adapter={adapter} copy={copy} tenantId="synthetic-tenant" />,
  );
}

describe("Escrow business My Deals", () => {
  it("lists host-mapped deals and filters by search and status", async () => {
    renderPage();
    expect(await screen.findByText("Synthetic goods example")).toBeInTheDocument();
    expect(screen.getByText("Synthetic service example")).toBeInTheDocument();

    fireEvent.change(screen.getByRole("searchbox", { name: "Search deals" }), {
      target: { value: "service" },
    });
    expect(screen.getByText("Synthetic service example")).toBeInTheDocument();
    expect(screen.queryByText("Synthetic goods example")).not.toBeInTheDocument();

    fireEvent.change(screen.getByRole("combobox", { name: "Status" }), {
      target: { value: "Waiting · sample" },
    });
    expect(screen.getByText("Synthetic service example")).toBeInTheDocument();
  });

  it("loads the documented detail adapter in a closable detail drawer", async () => {
    const adapter = makeAdapter();
    renderPage(adapter);
    fireEvent.click(
      (await screen.findAllByRole("button", { name: "Open details: Synthetic goods example" }))[0],
    );
    expect(await screen.findByText("Synthetic preview only")).toBeInTheDocument();
    expect(adapter.loadDealDetail).toHaveBeenCalledWith({
      tenantId: "synthetic-tenant",
      dealId: "deal-a",
    });
    fireEvent.click(screen.getByRole("button", { name: "Close details" }));
    await waitFor(() => expect(screen.queryByRole("dialog")).not.toBeInTheDocument());
  });

  it("keeps export unavailable without a host export operation", async () => {
    renderPage(makeAdapter());
    const exportButton = await screen.findByRole("button", { name: "Export" });
    expect(exportButton).toBeDisabled();
    expect(screen.getByText("Host export not connected.")).toBeInTheDocument();
  });

  it("delegates export of filtered host records to the host adapter", async () => {
    const exportDeals = vi.fn(async () => undefined);
    renderPage(makeAdapter({ exportDeals }));
    fireEvent.click(await screen.findByRole("button", { name: "Export" }));
    await waitFor(() =>
      expect(exportDeals).toHaveBeenCalledWith({ tenantId: "synthetic-tenant", deals: rows }),
    );
    expect(await screen.findByText("Host export completed.")).toBeInTheDocument();
  });

  it("renders retry, unavailable, restricted, empty, and no-results states", async () => {
    const failed = makeAdapter({
      loadDeals: vi.fn().mockRejectedValueOnce(new Error()).mockResolvedValue({ state: "empty" }),
    });
    const first = renderPage(failed);
    expect(await screen.findByText("Deals unavailable")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Retry" }));
    expect(await screen.findByText("No deals supplied")).toBeInTheDocument();
    first.unmount();

    const unavailable = renderPage(
      makeAdapter({ loadDeals: vi.fn().mockResolvedValue({ state: "unavailable" }) }),
    );
    expect(await screen.findByText("Listing unavailable")).toBeInTheDocument();
    unavailable.unmount();

    const restricted = renderPage(
      makeAdapter({ loadDeals: vi.fn().mockResolvedValue({ state: "restricted" }) }),
    );
    expect(await screen.findByText("Access restricted")).toBeInTheDocument();
    restricted.unmount();

    renderPage();
    fireEvent.change(await screen.findByRole("searchbox", { name: "Search deals" }), {
      target: { value: "nothing matches" },
    });
    expect(await screen.findByText("No matching deals")).toBeInTheDocument();
  });

  it("keeps table fields available for the narrow responsive row layout", async () => {
    renderPage();
    const table = await screen.findByRole("table");
    const row = within(table).getByRole("row", { name: /Synthetic goods example/ });
    expect(within(row).getByText("Preview participant A")).toBeInTheDocument();
    expect(row.querySelector('[data-label="Amount"]')).toHaveTextContent("Not supplied");
    expect(row.querySelectorAll("td[data-label]")).toHaveLength(8);
  });
});
