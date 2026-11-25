import { fireEvent, render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { vendorPlansCopy } from "./vendor_batch_8_copy";
import { PasVendorPlansPage } from "./vendor_plans_page";
import type {
  PasVendorPlan,
  PasVendorPlansAdapter,
  PasVendorPlansResult,
} from "./vendor_plans_types";

const samplePlans: readonly PasVendorPlan[] = [
  {
    id: "plan-1",
    planReference: "SYN-PLAN-001",
    customerLabel: "Synthetic buyer A",
    identityLabel: "Synthetic preview identity",
    verificationLabel: "Not supplied",
    productLabel: "Synthetic product A",
    planTypeLabel: "Price-lock",
    statusLabel: "In progress · preview",
    statusTone: "warning",
    progressPercent: 64,
    progressLabel: "Synthetic preview · 64%",
    targetAmountLabel: "Not supplied",
    savedAmountLabel: "Not supplied",
    repaymentHistoryLabel: "Not supplied",
    nextDueLabel: "Not supplied",
  },
  {
    id: "plan-2",
    planReference: "SYN-PLAN-002",
    customerLabel: "Synthetic buyer B",
    productLabel: "Synthetic product B",
    planTypeLabel: "Price-lock",
    statusLabel: "Status not supplied",
  },
];

function makeAdapter(
  loadPlans: () => Promise<PasVendorPlansResult> = async () => ({
    state: "ready",
    plans: samplePlans,
  }),
): PasVendorPlansAdapter {
  return { loadPlans };
}

describe("W-PAS-004 Plans & Customers", () => {
  it("renders host-mapped progress and customer information without calculating missing values", async () => {
    render(
      <PasVendorPlansPage adapter={makeAdapter()} copy={vendorPlansCopy} tenantId="tenant-1" />,
    );
    expect(await screen.findAllByText("SYN-PLAN-001")).not.toHaveLength(0);
    expect(screen.getAllByText("Synthetic preview · 64%")).not.toHaveLength(0);
    expect(screen.getAllByText("Not supplied").length).toBeGreaterThan(2);
    expect(screen.getByText("Synthetic preview record")).toBeInTheDocument();
    expect(screen.getAllByText("Synthetic buyer A")).not.toHaveLength(0);
  });

  it("filters only the host-supplied plan type, status and search results", async () => {
    const user = userEvent.setup();
    render(
      <PasVendorPlansPage adapter={makeAdapter()} copy={vendorPlansCopy} tenantId="tenant-1" />,
    );
    await screen.findAllByText("SYN-PLAN-001");
    await user.selectOptions(screen.getByRole("combobox", { name: "Plan type" }), "Price-lock");
    await user.selectOptions(
      screen.getByRole("combobox", { name: "Plan status" }),
      "Status not supplied",
    );
    expect(screen.queryByText("SYN-PLAN-001")).not.toBeInTheDocument();
    expect(screen.getAllByText("SYN-PLAN-002")).not.toHaveLength(0);
    fireEvent.change(screen.getByRole("searchbox", { name: "Search plans and customers" }), {
      target: { value: "buyer b" },
    });
    expect(screen.getAllByText("SYN-PLAN-002")).not.toHaveLength(0);
  });

  it("renders loading, empty, unavailable, restricted and retryable error states", async () => {
    let resolveLoad!: (result: PasVendorPlansResult) => void;
    const load = vi.fn(
      () =>
        new Promise<PasVendorPlansResult>((resolve) => {
          resolveLoad = resolve;
        }),
    );
    const view = render(
      <PasVendorPlansPage adapter={makeAdapter(load)} copy={vendorPlansCopy} tenantId="tenant-1" />,
    );
    expect(screen.getByRole("status", { name: "Loading vendor plans" })).toBeInTheDocument();
    resolveLoad({ state: "empty" });
    expect(await screen.findByText("No plans supplied")).toBeInTheDocument();

    view.rerender(
      <PasVendorPlansPage
        adapter={makeAdapter(async () => ({ state: "unavailable" }))}
        copy={vendorPlansCopy}
        tenantId="tenant-1"
      />,
    );
    expect(await screen.findByText("Plan data is not connected")).toBeInTheDocument();
    view.rerender(
      <PasVendorPlansPage
        adapter={makeAdapter(async () => ({ state: "restricted" }))}
        copy={vendorPlansCopy}
        tenantId="tenant-1"
      />,
    );
    expect(await screen.findByText("Plan access restricted")).toBeInTheDocument();
    view.rerender(
      <PasVendorPlansPage
        adapter={makeAdapter(async () => {
          throw new Error("offline");
        })}
        copy={vendorPlansCopy}
        tenantId="tenant-1"
      />,
    );
    expect(await screen.findByText("Plans unavailable")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Retry" })).toBeEnabled();
  });
});
