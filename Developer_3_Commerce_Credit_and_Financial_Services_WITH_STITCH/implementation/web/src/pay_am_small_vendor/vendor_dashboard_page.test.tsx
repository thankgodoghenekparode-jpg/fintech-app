import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { PasVendorDashboardPage } from "./vendor_dashboard_page";
import type { PasVendorDashboardCopy } from "./vendor_copy";
import type { PasVendorDashboardAdapter, PasVendorDashboardResult } from "./vendor_types";

const copy: PasVendorDashboardCopy = {
  eyebrow: "PAY AM SMALL · VENDOR",
  title: "Vendor dashboard",
  subtitle: "Host-supplied activity.",
  loading: "Loading vendor dashboard",
  retry: "Retry",
  errorTitle: "Dashboard unavailable",
  errorBody: "Try again.",
  restrictedTitle: "Dashboard access restricted",
  restrictedBody: "Host restricted.",
  unavailableTitle: "Dashboard data is not connected",
  unavailableBody: "No dashboard endpoint or host data is configured.",
  emptyTitle: "No dashboard data supplied",
  emptyBody: "No host data.",
  orders: "Orders",
  activePlans: "Active plans",
  payouts: "Payouts",
  disputes: "Disputes",
  salesChart: "Sales activity",
  completionChart: "Plan completion",
  alerts: "Operational alerts",
  noChartData: "Chart data unavailable.",
  noAlerts: "No alerts supplied.",
  viewProducts: "Products & prices",
  unavailableValue: "Not supplied",
};

const unavailable: PasVendorDashboardResult = { state: "unavailable" };

function makeAdapter(loadDashboard: PasVendorDashboardAdapter["loadDashboard"]) {
  return { loadDashboard } satisfies PasVendorDashboardAdapter;
}

describe("W-PAS-001 Vendor dashboard", () => {
  it("keeps KPI and chart structure without inventing dashboard figures", async () => {
    const loadDashboard = vi.fn(async () => unavailable);
    const onOpenProducts = vi.fn();
    render(
      <PasVendorDashboardPage
        adapter={makeAdapter(loadDashboard)}
        copy={copy}
        onOpenProducts={onOpenProducts}
        tenantId="host-tenant"
      />,
    );

    expect(await screen.findByText("Dashboard data is not connected")).toBeInTheDocument();
    expect(screen.getAllByText("Not supplied")).toHaveLength(4);
    expect(screen.getByRole("heading", { name: "Sales activity" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Plan completion" })).toBeInTheDocument();
    expect(screen.getByText("No alerts supplied.")).toBeInTheDocument();
    expect(screen.queryByText(/₦\d/)).not.toBeInTheDocument();
    expect(loadDashboard).toHaveBeenCalledWith({ tenantId: "host-tenant" });

    await userEvent.setup().click(screen.getByRole("button", { name: "Products & prices" }));
    expect(onOpenProducts).toHaveBeenCalledOnce();
  });

  it("renders supplied dashboard data and restricted state", async () => {
    const ready: PasVendorDashboardResult = {
      state: "ready",
      snapshot: {
        metrics: {
          orders: { label: "Orders", valueLabel: "Host count A" },
          activePlans: { label: "Active plans", valueLabel: "Host count B" },
          payouts: { label: "Payouts", valueLabel: "Host supplied payout label" },
          disputes: { label: "Disputes", valueLabel: "Host count C" },
        },
        salesTrend: [
          { periodLabel: "Host period", valueLabel: "Host sales label", displayFraction: 0.5 },
        ],
        planCompletion: [],
        alerts: [{ title: "Host stock alert", detail: "Host alert details", tone: "warning" }],
      },
    };
    const view = render(
      <PasVendorDashboardPage
        adapter={makeAdapter(vi.fn(async () => ready))}
        copy={copy}
        tenantId="tenant"
      />,
    );
    expect(await screen.findByText("Host supplied payout label")).toBeInTheDocument();
    expect(screen.getByText("Host stock alert")).toBeInTheDocument();
    view.unmount();

    render(
      <PasVendorDashboardPage
        adapter={makeAdapter(vi.fn(async () => ({ state: "restricted" as const })))}
        copy={copy}
        tenantId="tenant"
      />,
    );
    expect(await screen.findByText("Dashboard access restricted")).toBeInTheDocument();
  });

  it("shows loading and retries a failed host adapter", async () => {
    const loadDashboard = vi
      .fn()
      .mockRejectedValueOnce(new Error("unavailable"))
      .mockResolvedValue(unavailable);
    render(
      <PasVendorDashboardPage adapter={makeAdapter(loadDashboard)} copy={copy} tenantId="tenant" />,
    );
    expect(screen.getByRole("status", { name: "Loading vendor dashboard" })).toBeInTheDocument();
    expect(await screen.findByText("Dashboard unavailable")).toBeInTheDocument();
    await userEvent.setup().click(screen.getByRole("button", { name: "Retry" }));
    await waitFor(() =>
      expect(screen.getByText("Dashboard data is not connected")).toBeInTheDocument(),
    );
  });
});
