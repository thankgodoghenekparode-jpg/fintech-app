import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { EscrowDisputeCasePage, EscrowDisputeQueuePage } from "./dispute_management_pages";
import type {
  EscrowDisputeCaseAdapter,
  EscrowDisputeCaseCopy,
  EscrowDisputeQueueAdapter,
  EscrowDisputeQueueCopy,
  EscrowDisputeQueueItem,
  EscrowDisputeQueueResult,
} from "./dispute_management_types";

const queueCopy = {
  eyebrow: "ESCROW BACK OFFICE",
  title: "Dispute queue",
  subtitle: "Queue help",
  loading: "Loading queue",
  retry: "Retry",
  errorTitle: "Queue error",
  errorBody: "Queue failed",
  unavailableTitle: "Queue unavailable",
  unavailableBody: "Queue unavailable body",
  restrictedTitle: "Queue restricted",
  restrictedBody: "Queue restricted body",
  emptyTitle: "No disputes",
  emptyBody: "Queue empty",
  searchLabel: "Search disputes",
  searchPlaceholder: "Search",
  typeFilter: "Type",
  valueFilter: "Value",
  ageFilter: "Age",
  allTypes: "All types",
  allValues: "All values",
  allAges: "All ages",
  queueCount: (visible: number, total: number) => `${visible}/${total}`,
  caseColumn: "Case",
  dealColumn: "Deal",
  typeColumn: "Type",
  valueColumn: "Value",
  ageColumn: "Age",
  statusColumn: "Status",
  slaColumn: "SLA",
  responsibleColumn: "Responsible",
  openCase: "Open case",
  noResultsTitle: "No results",
  noResultsBody: "Change filters",
  notSupplied: "Not supplied",
  breached: "Breached",
} as unknown as EscrowDisputeQueueCopy;

const caseCopy = {
  eyebrow: "ESCROW BACK OFFICE",
  title: "Dispute case",
  backToQueue: "Back to queue",
  loading: "Loading case",
  retry: "Retry",
  unavailableTitle: "Case unavailable",
  unavailableBody: "Case unavailable body",
  restrictedTitle: "Case restricted",
  restrictedBody: "Case restricted body",
  caseSummary: "Case information",
  termsSnapshot: "Terms snapshot",
  evidence: "Evidence",
  noEvidence: "No evidence supplied",
  caseHistory: "Case history",
  noHistory: "No history supplied",
  decisionDeadline: "Decision deadline",
  feeOutcome: "Fee outcome",
  appealHandling: "Appeal and review",
  secondReview: "Second review",
  decision: "Decision",
  outcome: "Outcome",
  release: "Release",
  refund: "Refund",
  split: "Split",
  splitSellerAmount: "Seller allocation (kobo)",
  splitUnitHelp: "Integer amount supplied by authority",
  rationale: "Rationale",
  rationalePlaceholder: "Rationale",
  reviewDecision: "Review decision",
  confirmTitle: "Confirm decision",
  confirmBody: "Confirm",
  cancel: "Cancel",
  confirmSubmit: "Submit",
  decisionRecorded: "Decision recorded",
  submitError: "Decision failed",
  requiredOutcome: "Select an outcome",
  requiredRationale: "Enter rationale",
  invalidSplitAmount: "Whole number required",
  decisionUnavailable: "Decision unavailable",
  feeOutcomeContractGap: "Fee outcome is host-supplied",
  notSupplied: "Not supplied by host",
} as unknown as EscrowDisputeCaseCopy;

const items: readonly EscrowDisputeQueueItem[] = [
  {
    id: "case-a",
    caseReferenceLabel: "SYNTHETIC-A",
    dealTitle: "Synthetic goods example",
    disputeTypeLabel: "Goods",
    valueBandLabel: "Band A",
    ageBandLabel: "New",
    statusLabel: "Preview only",
  },
  {
    id: "case-b",
    caseReferenceLabel: "SYNTHETIC-B",
    dealTitle: "Synthetic service example",
    disputeTypeLabel: "Service",
    valueBandLabel: "Band B",
    ageBandLabel: "Older",
    statusLabel: "Preview only",
  },
];

function makeQueueAdapter(
  loadQueue = vi.fn(async () => ({ state: "ready" as const, cases: items })),
): EscrowDisputeQueueAdapter {
  return { loadQueue };
}

const detail = {
  id: "case-a",
  caseReferenceLabel: "SYNTHETIC-A",
  dealTitle: "Synthetic example only",
  statusLabel: "Preview only",
  termsSnapshot: [],
  evidence: [],
  history: [],
  canDecide: false,
  restrictionMessage: "Decision unavailable in this preview.",
};

function makeCaseAdapter(
  overrides: Partial<EscrowDisputeCaseAdapter> = {},
): EscrowDisputeCaseAdapter {
  return {
    loadCase: vi.fn(async () => ({ state: "ready" as const, detail })),
    authorizeDecision: vi.fn(async () => null),
    submitDecision: vi.fn(async () => undefined),
    ...overrides,
  };
}

describe("Escrow dispute management", () => {
  it("loads the queue and searches host-mapped rows", async () => {
    const onOpenCase = vi.fn();
    render(
      <EscrowDisputeQueuePage
        adapter={makeQueueAdapter()}
        copy={queueCopy}
        onOpenCase={onOpenCase}
        tenantId="tenant"
      />,
    );
    expect(await screen.findByText("SYNTHETIC-A")).toBeInTheDocument();
    fireEvent.change(screen.getByRole("searchbox", { name: "Search disputes" }), {
      target: { value: "service" },
    });
    expect(screen.queryByText("SYNTHETIC-A")).not.toBeInTheDocument();
    expect(screen.getByText("SYNTHETIC-B")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Open case: SYNTHETIC-B" }));
    expect(onOpenCase).toHaveBeenCalledWith("case-b");
  });

  it("shows loading and safely handles unavailable queue data", async () => {
    let resolve!: (result: EscrowDisputeQueueResult) => void;
    const adapter = makeQueueAdapter(
      vi.fn(
        () =>
          new Promise<EscrowDisputeQueueResult>((done) => {
            resolve = done;
          }),
      ),
    );
    render(
      <EscrowDisputeQueuePage
        adapter={adapter}
        copy={queueCopy}
        onOpenCase={vi.fn()}
        tenantId="tenant"
      />,
    );
    expect(screen.getByRole("status", { name: "Loading queue" })).toBeInTheDocument();
    resolve({ state: "unavailable" });
    expect(await screen.findByText("Queue unavailable")).toBeInTheDocument();
  });

  it("renders case information without enabling unsupported decisions", async () => {
    const adapter = makeCaseAdapter();
    render(
      <EscrowDisputeCasePage
        adapter={adapter}
        caseId="case-a"
        copy={caseCopy}
        onBackToQueue={vi.fn()}
        tenantId="tenant"
      />,
    );
    expect(await screen.findByText("Synthetic example only")).toBeInTheDocument();
    expect(screen.getByText("No evidence supplied")).toBeInTheDocument();
    expect(screen.getByText("No history supplied")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Review decision" })).toBeDisabled();
    expect(adapter.submitDecision).not.toHaveBeenCalled();
  });

  it("requires decision fields and does not submit without host PIN authorization", async () => {
    const authorizedDetail = { ...detail, canDecide: true, restrictionMessage: undefined };
    const submitDecision = vi.fn(async () => undefined);
    const adapter = makeCaseAdapter({
      loadCase: vi.fn(async () => ({ state: "ready" as const, detail: authorizedDetail })),
      authorizeDecision: vi.fn(async () => null),
      submitDecision,
    });
    render(
      <EscrowDisputeCasePage
        adapter={adapter}
        caseId="case-a"
        copy={caseCopy}
        onBackToQueue={vi.fn()}
        tenantId="tenant"
      />,
    );
    await screen.findByText("Synthetic example only");
    fireEvent.click(screen.getByRole("button", { name: "Review decision" }));
    expect(screen.getByText("Select an outcome")).toBeInTheDocument();
    expect(screen.getByText("Enter rationale")).toBeInTheDocument();
    fireEvent.change(screen.getByLabelText("Outcome"), { target: { value: "RELEASE" } });
    fireEvent.change(screen.getByLabelText("Rationale"), {
      target: { value: "Documented review rationale" },
    });
    fireEvent.click(screen.getByRole("button", { name: "Review decision" }));
    expect(await screen.findByText("Confirm decision")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Submit" }));
    await waitFor(() =>
      expect(adapter.authorizeDecision).toHaveBeenCalledWith({
        tenantId: "tenant",
        caseId: "case-a",
      }),
    );
    expect(submitDecision).not.toHaveBeenCalled();
    expect(await screen.findByRole("alert")).toHaveTextContent("Decision failed");
  });

  it("shows a retryable error when case loading fails", async () => {
    const adapter = makeCaseAdapter({
      loadCase: vi
        .fn()
        .mockRejectedValueOnce(new Error("offline"))
        .mockResolvedValue({ state: "ready", detail }),
    });
    render(
      <EscrowDisputeCasePage
        adapter={adapter}
        caseId="case-a"
        copy={caseCopy}
        onBackToQueue={vi.fn()}
        tenantId="tenant"
      />,
    );
    expect(await screen.findByText("Case unavailable")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Retry" }));
    await waitFor(() => expect(screen.getByText("Synthetic example only")).toBeInTheDocument());
  });
});
