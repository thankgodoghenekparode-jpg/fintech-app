import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { testCopy } from "../test_copy";
import { BusinessDashboardPage } from "./business_dashboard_page";
import type { BusinessDashboardAdapter, DashboardResult } from "./dashboard_types";

const readyDashboard: DashboardResult = {
  state: "ready",
  snapshot: {
    metrics: {
      salesKobo: 12_500_000,
      feesKobo: 125_000,
      refundsKobo: 80_000,
      outstandingInvoicesKobo: 450_000,
    },
    salesSeries: [
      { label: "Mon", amountKobo: 500_000 },
      { label: "Tue", amountKobo: 750_000 },
    ],
    recentActivity: [
      {
        id: "preview-record-1",
        title: "Counter sale",
        amountKobo: 125_000,
        statusLabel: "Completed",
        statusTone: "success",
        timeLabel: "Today, 10:14",
      },
    ],
  },
};

function makeAdapter(loadDashboard = vi.fn(async () => readyDashboard)) {
  return { loadDashboard } satisfies BusinessDashboardAdapter;
}

describe("W-MER-001 Business dashboard", () => {
  it("renders host metrics, sales chart and recent activity with drill-down navigation", async () => {
    const user = userEvent.setup();
    const adapter = makeAdapter();
    const onNavigate = vi.fn();
    render(
      <BusinessDashboardPage
        adapter={adapter}
        copy={testCopy.dashboard}
        onNavigate={onNavigate}
        tenantId="tenant-test"
      />,
    );

    expect(await screen.findByRole("heading", { name: "Business dashboard" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /Sales/ })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /Outstanding invoices/ })).toBeInTheDocument();
    expect(screen.getByRole("img", { name: "Sales activity" })).toBeInTheDocument();
    expect(screen.getByText("Counter sale")).toBeInTheDocument();
    expect(screen.getByText("Completed")).toBeInTheDocument();

    await user.click(screen.getByRole("button", { name: /Outstanding invoices/ }));
    expect(onNavigate).toHaveBeenCalledWith("invoices");
    const reportLinks = screen.getAllByRole("button", { name: "View reports" });
    await user.click(reportLinks[0]);
    expect(onNavigate).toHaveBeenLastCalledWith("reports");
  });

  it("renders a restricted state and a retryable adapter error", async () => {
    const restricted = makeAdapter(vi.fn(async () => ({ state: "restricted" as const })));
    const view = render(
      <BusinessDashboardPage
        adapter={restricted}
        copy={testCopy.dashboard}
        tenantId="tenant-test"
      />,
    );
    expect(await screen.findByText("Dashboard access restricted")).toBeInTheDocument();
    view.unmount();

    const loadDashboard = vi
      .fn()
      .mockRejectedValueOnce(new Error("offline"))
      .mockResolvedValue(readyDashboard);
    render(
      <BusinessDashboardPage
        adapter={makeAdapter(loadDashboard)}
        copy={testCopy.dashboard}
        tenantId="tenant-test"
      />,
    );
    expect(await screen.findByText("Dashboard unavailable")).toBeInTheDocument();
    await userEvent.setup().click(screen.getByRole("button", { name: "Retry" }));
    await waitFor(() => expect(screen.getByText("Counter sale")).toBeInTheDocument());
  });
});
