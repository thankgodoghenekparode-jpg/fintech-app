import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { LoanApplicationsPage, LoanPortfolioPage } from "./loan_backoffice_pages";
import type { LoanBackofficeCopy } from "./loan_backoffice_copy";
import type {
  LoanApplicationDetail,
  LoanApplicationsAdapter,
  LoanPortfolioAdapter,
} from "./loan_backoffice_types";

const copy: LoanBackofficeCopy = {
  common: {
    brand: "YourApp",
    preview: "Preview",
    nonProduction: "Non-production",
    applicationsNav: "Applications",
    portfolioNav: "Portfolio",
    switchTheme: "Switch theme",
    switchLight: "Light",
    switchDark: "Dark",
    loading: "Loading",
    retry: "Retry",
    unavailableTitle: "Unavailable",
    unavailableBody: "No host data is connected.",
    restrictedTitle: "Restricted",
    restrictedBody: "Host permission is required.",
    emptyTitle: "No records",
    emptyBody: "No host records.",
    errorTitle: "Load failed",
    errorBody: "Try again.",
    hostUnavailable: "Not supplied",
  },
  applications: {
    eyebrow: "Credit operations",
    title: "Applications queue",
    subtitle: "Review referred applications.",
    applicationCount: "applications",
    reference: "Application",
    customer: "Customer",
    score: "Score",
    reasons: "Reasons",
    exposure: "Exposure",
    sla: "SLA",
    action: "Action",
    open: "Review",
    detailTitle: "Application detail",
    customerView: "Masked customer view",
    decisionReason: "Decision reason",
    decisionReasonPlaceholder: "Enter reason",
    approve: "Approve",
    decline: "Decline",
    submit: "Submit decision",
    cancel: "Cancel",
    decisionUnavailable: "Host authorization unavailable",
    decisionPending: "Submitting",
    decisionSubmitted: "Decision request accepted by host",
    decisionError: "Decision not confirmed",
    reasonRequired: "Enter a reason.",
    noReasons: "No reasons supplied.",
    noSelection: "Select an application.",
  },
  portfolio: {
    eyebrow: "Credit operations",
    title: "Portfolio and collections",
    subtitle: "Host-supplied portfolio information.",
    metrics: "Portfolio metrics",
    outstanding: "Outstanding",
    parBuckets: "PAR buckets",
    repaymentRate: "Repayment rate",
    arrears: "Arrears",
    customer: "Customer",
    loan: "Loan",
    daysPastDue: "Days past due",
    amountDue: "Amount due",
    contactHistory: "Contact history",
    approvedScripts: "Approved scripts",
    contactRestrictions: "Only host-provided contact-hour restrictions are displayed.",
    noContactHistory: "No contact history supplied.",
    noApprovedScripts: "No approved script supplied.",
    hardshipCases: "Hardship cases",
    caseStatus: "Case status",
    summary: "Summary",
    openCase: "Open case",
    caseDetails: "Case details",
    noCaseSelected: "Select a case.",
    caseSelected: "Selected case",
  },
};

const application: LoanApplicationDetail = {
  id: "app-1",
  reference: "APP-MASKED-1",
  maskedCustomer: "Customer ••28",
  maskedCustomerReference: "ID •••• 4921",
  scoreLabel: "Host score",
  reasons: ["Host referral reason"],
  exposureLabel: "Host exposure",
  slaLabel: "Host SLA",
  maskedCustomerView: [{ label: "Account", value: "•••• 7788" }],
};

describe("Instant Loan back-office screens", () => {
  it("loads the referred queue and submits only a host-authorized documented decision", async () => {
    const decideApplication = vi.fn().mockResolvedValue(undefined);
    const adapter: LoanApplicationsAdapter = {
      loadApplications: vi.fn().mockResolvedValue({ state: "ready", applications: [application] }),
      decideApplication,
    };
    const authorizeDecision = vi
      .fn()
      .mockResolvedValue({ pinToken: "host-pin", idempotencyKey: "host-key" });
    render(
      <LoanApplicationsPage
        adapter={adapter}
        authorizeDecision={authorizeDecision}
        copy={copy}
        tenantId="tenant-host"
      />,
    );

    expect(await screen.findByText("APP-MASKED-1")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Review" }));
    expect(screen.getByText("ID •••• 4921")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Approve" }));
    fireEvent.change(screen.getByLabelText("Decision reason"), {
      target: { value: "Host-supported review outcome" },
    });
    fireEvent.click(screen.getByRole("button", { name: "Submit decision" }));
    await waitFor(() =>
      expect(decideApplication).toHaveBeenCalledWith({
        applicationId: "app-1",
        decision: "APPROVE",
        reason: "Host-supported review outcome",
        pinToken: "host-pin",
        idempotencyKey: "host-key",
        tenantId: "tenant-host",
      }),
    );
    expect(authorizeDecision).toHaveBeenCalledWith("app-1");
  });

  it("keeps decisions unavailable when host authorization is not injected", async () => {
    const adapter: LoanApplicationsAdapter = {
      loadApplications: async () => ({ state: "ready", applications: [application] }),
      decideApplication: vi.fn(),
    };
    render(<LoanApplicationsPage adapter={adapter} copy={copy} tenantId="tenant-host" />);
    await screen.findByText("APP-MASKED-1");
    fireEvent.click(screen.getByRole("button", { name: "Review" }));
    expect(screen.getByRole("button", { name: "Approve" })).toBeDisabled();
    expect(screen.getByText("Host authorization unavailable")).toBeInTheDocument();
  });

  it("shows restricted, empty and error states without fabricating queue records", async () => {
    const restricted: LoanApplicationsAdapter = {
      loadApplications: async () => ({ state: "restricted" }),
      decideApplication: vi.fn(),
    };
    const { rerender } = render(
      <LoanApplicationsPage adapter={restricted} copy={copy} tenantId="tenant-host" />,
    );
    expect(await screen.findByText("Restricted")).toBeInTheDocument();
    const empty: LoanApplicationsAdapter = {
      loadApplications: async () => ({ state: "empty" }),
      decideApplication: vi.fn(),
    };
    rerender(<LoanApplicationsPage adapter={empty} copy={copy} tenantId="tenant-host" />);
    expect(await screen.findByText("No records")).toBeInTheDocument();
    const failed: LoanApplicationsAdapter = {
      loadApplications: async () => {
        throw new Error("offline");
      },
      decideApplication: vi.fn(),
    };
    rerender(<LoanApplicationsPage adapter={failed} copy={copy} tenantId="tenant-host" />);
    expect(await screen.findByText("Load failed")).toBeInTheDocument();
  });

  it("renders host portfolio metrics, arrears history and selectable hardship case", async () => {
    const adapter: LoanPortfolioAdapter = {
      loadPortfolio: async () => ({
        state: "ready",
        snapshot: {
          outstandingLabel: "Host amount",
          parBuckets: [{ label: "Host PAR bucket", value: "Host bucket value" }],
          repaymentRateLabel: "Host rate",
          arrears: [
            {
              id: "arrears-1",
              maskedCustomer: "Customer ••28",
              loanReference: "LOAN ••17",
              daysPastDueLabel: "Host days",
              amountDueLabel: "Host amount due",
              contactHistory: ["Host contact event"],
              approvedScripts: ["Approved host script"],
              contactRestrictionLabel: "Host contact-hour restriction",
            },
          ],
          hardshipCases: [
            {
              id: "case-1",
              maskedCustomer: "Customer ••28",
              caseStatusLabel: "Host status",
              summary: "Host-provided case summary",
            },
          ],
        },
      }),
    };
    render(<LoanPortfolioPage adapter={adapter} copy={copy} tenantId="tenant-host" />);
    expect(await screen.findByText("Host amount")).toBeInTheDocument();
    expect(screen.getByText("Host bucket value")).toBeInTheDocument();
    expect(screen.getByText("Host rate")).toBeInTheDocument();
    expect(screen.getByText("Host contact event")).toBeInTheDocument();
    expect(screen.getByText("Approved host script")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Customer ••28.*Host status/ }));
    expect(screen.getAllByText("Host-provided case summary")).toHaveLength(2);
  });

  it("shows portfolio empty and restricted states", async () => {
    const empty: LoanPortfolioAdapter = { loadPortfolio: async () => ({ state: "empty" }) };
    const { rerender } = render(
      <LoanPortfolioPage adapter={empty} copy={copy} tenantId="tenant-host" />,
    );
    expect(await screen.findByText("No records")).toBeInTheDocument();
    const restricted: LoanPortfolioAdapter = {
      loadPortfolio: async () => ({ state: "restricted" }),
    };
    rerender(<LoanPortfolioPage adapter={restricted} copy={copy} tenantId="tenant-host" />);
    expect(await screen.findByText("Restricted")).toBeInTheDocument();
  });
});
