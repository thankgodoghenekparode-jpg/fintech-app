import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { LoanProductsPage, LoanSettlementsPage } from "./loan_admin_pages";
import type { LoanAdminCopy } from "./loan_admin_copy";
import type {
  LoanProductVersion,
  LoanProductsAdapter,
  LoanSettlementsAdapter,
} from "./loan_admin_types";

const copy: LoanAdminCopy = {
  common: {
    loading: "Loading",
    retry: "Retry",
    unavailableTitle: "Unavailable",
    unavailableBody: "No host data.",
    restrictedTitle: "Restricted",
    restrictedBody: "Host permission is required.",
    emptyTitle: "No records",
    emptyBody: "No host records.",
    errorTitle: "Load failed",
    errorBody: "Try again.",
    hostUnavailable: "Not supplied by host",
  },
  products: {
    eyebrow: "Product admin",
    title: "Product configuration",
    subtitle: "Review host-supplied versions.",
    listTitle: "Products and versions",
    product: "Product",
    version: "Version",
    status: "Status",
    effectiveFrom: "Effective from",
    currentConfiguration: "Current configuration",
    chooseProduct: "Choose a product",
    configuration: "Configuration object",
    configHelp: "Host fields only.",
    effectiveDateHelp: "Select date.",
    propose: "Submit for approval",
    proposing: "Submitting",
    proposalPending: "Proposal submitted to host workflow.",
    proposalError: "Proposal not confirmed.",
    permissionUnavailable: "Dual control and product-admin permission are host enforced.",
    validConfig: "Enter a valid JSON object.",
    validDate: "Select an effective date.",
  },
  settlements: {
    eyebrow: "Finance",
    title: "Partner settlement",
    subtitle: "Host-provided settlement statement.",
    period: "Settlement period",
    statement: "Settlement statement",
    status: "Status",
    total: "Statement total",
    splits: "Partner splits",
    exceptions: "Exceptions",
    noSplits: "No splits.",
    noExceptions: "No exceptions.",
    approve: "Approve settlement",
    approving: "Approving",
    approvalAccepted: "Host accepted request.",
    approvalError: "Approval not confirmed.",
    approvalUnavailable: "Host authorization and dual control required.",
    export: "Export statement",
    exportUnavailable: "Export unavailable.",
    exportError: "Export failed.",
    selectPeriod: "Choose a period",
  },
};

const product: LoanProductVersion = {
  id: "version-host-1",
  productLabel: "Host product label",
  versionLabel: "Host version",
  statusLabel: "Pending approval",
  effectiveFromLabel: "Host effective date",
  config: { hostConfigKey: "host supplied value" },
};

describe("Instant Loan product configuration and settlement", () => {
  it("submits only host-supplied config with the documented effectiveFrom field", async () => {
    const proposeProductVersion = vi.fn().mockResolvedValue(undefined);
    const adapter: LoanProductsAdapter = {
      loadProducts: async () => ({ state: "ready", products: [product], canPropose: true }),
      proposeProductVersion,
    };
    render(<LoanProductsPage adapter={adapter} copy={copy} tenantId="tenant-host" />);
    expect(await screen.findAllByText("Host product label")).toHaveLength(2);
    fireEvent.click(screen.getByRole("button", { name: /Host product label/ }));
    fireEvent.change(screen.getByRole("textbox", { name: "Configuration object" }), {
      target: { value: '{"hostConfigKey":"host edited value"}' },
    });
    fireEvent.change(screen.getByLabelText("Effective from"), {
      target: { value: "2026-12-01T09:30" },
    });
    fireEvent.click(screen.getByRole("button", { name: "Submit for approval" }));
    await waitFor(() =>
      expect(proposeProductVersion).toHaveBeenCalledWith({
        config: { hostConfigKey: "host edited value" },
        effectiveFrom: new Date("2026-12-01T09:30").toISOString(),
        tenantId: "tenant-host",
      }),
    );
    expect(await screen.findByText("Proposal submitted to host workflow.")).toBeInTheDocument();
  });

  it("keeps configuration proposals disabled without host permission", async () => {
    const adapter: LoanProductsAdapter = {
      loadProducts: async () => ({ state: "ready", products: [product], canPropose: false }),
      proposeProductVersion: vi.fn(),
    };
    render(<LoanProductsPage adapter={adapter} copy={copy} tenantId="tenant-host" />);
    await screen.findByRole("button", { name: /Host product label/ });
    expect(screen.getByRole("button", { name: "Submit for approval" })).toBeDisabled();
    expect(screen.getByText(/Dual control and product-admin permission/)).toBeInTheDocument();
  });

  it("shows unavailable, empty, restricted and error states for products", async () => {
    const unavailable: LoanProductsAdapter = {
      loadProducts: async () => ({ state: "unavailable" }),
      proposeProductVersion: vi.fn(),
    };
    const { rerender } = render(
      <LoanProductsPage adapter={unavailable} copy={copy} tenantId="tenant-host" />,
    );
    expect(await screen.findByText("Unavailable")).toBeInTheDocument();
    rerender(
      <LoanProductsPage
        adapter={{ ...unavailable, loadProducts: async () => ({ state: "empty" }) }}
        copy={copy}
        tenantId="tenant-host"
      />,
    );
    expect(await screen.findByText("No records")).toBeInTheDocument();
    rerender(
      <LoanProductsPage
        adapter={{ ...unavailable, loadProducts: async () => ({ state: "restricted" }) }}
        copy={copy}
        tenantId="tenant-host"
      />,
    );
    expect(await screen.findByText("Restricted")).toBeInTheDocument();
    rerender(
      <LoanProductsPage
        adapter={{
          ...unavailable,
          loadProducts: async () => {
            throw new Error("offline");
          },
        }}
        copy={copy}
        tenantId="tenant-host"
      />,
    );
    expect(await screen.findByText("Load failed")).toBeInTheDocument();
  });

  it("renders host settlement splits and exceptions and requires host approval authorization", async () => {
    const approveSettlement = vi.fn().mockResolvedValue(undefined);
    const adapter: LoanSettlementsAdapter = {
      loadSettlements: async () => ({
        state: "ready",
        periods: [
          {
            id: "host-period",
            periodLabel: "Host period",
            statementReference: "Host statement",
            statusLabel: "Pending",
            totalLabel: "Host total",
            splits: [{ label: "Host partner", valueLabel: "Host split value" }],
            exceptions: [
              { id: "exception-host", label: "Host exception", detail: "Host exception detail" },
            ],
            canApprove: true,
          },
        ],
      }),
      approveSettlement,
    };
    render(
      <LoanSettlementsPage
        adapter={adapter}
        authorizeApproval={async () => ({
          idempotencyKey: "host-idempotency",
          pinToken: "host-pin",
        })}
        copy={copy}
        tenantId="tenant-host"
      />,
    );
    expect(await screen.findByText("Host statement")).toBeInTheDocument();
    expect(screen.getByText("Host split value")).toBeInTheDocument();
    expect(screen.getByText("Host exception detail")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Approve settlement" }));
    await waitFor(() =>
      expect(approveSettlement).toHaveBeenCalledWith({
        settlementId: "host-period",
        idempotencyKey: "host-idempotency",
        pinToken: "host-pin",
        tenantId: "tenant-host",
      }),
    );
  });

  it("disables settlement approval and export without host capabilities", async () => {
    const adapter: LoanSettlementsAdapter = {
      loadSettlements: async () => ({
        state: "ready",
        periods: [
          {
            id: "host-period",
            periodLabel: "Host period",
            statementReference: "Host statement",
            statusLabel: "Pending",
            splits: [],
            exceptions: [],
            canApprove: false,
          },
        ],
      }),
      approveSettlement: vi.fn(),
    };
    render(<LoanSettlementsPage adapter={adapter} copy={copy} tenantId="tenant-host" />);
    await screen.findByText("Host statement");
    expect(screen.getByRole("button", { name: "Approve settlement" })).toBeDisabled();
    expect(screen.getByRole("button", { name: "Export statement" })).toBeDisabled();
    expect(screen.getByText("Host authorization and dual control required.")).toBeInTheDocument();
  });

  it("shows empty and restricted settlement states", async () => {
    const adapter: LoanSettlementsAdapter = {
      loadSettlements: async () => ({ state: "empty" }),
      approveSettlement: vi.fn(),
    };
    const { rerender } = render(
      <LoanSettlementsPage adapter={adapter} copy={copy} tenantId="tenant-host" />,
    );
    expect(await screen.findByText("No records")).toBeInTheDocument();
    rerender(
      <LoanSettlementsPage
        adapter={{ ...adapter, loadSettlements: async () => ({ state: "restricted" }) }}
        copy={copy}
        tenantId="tenant-host"
      />,
    );
    expect(await screen.findByText("Restricted")).toBeInTheDocument();
  });
});
