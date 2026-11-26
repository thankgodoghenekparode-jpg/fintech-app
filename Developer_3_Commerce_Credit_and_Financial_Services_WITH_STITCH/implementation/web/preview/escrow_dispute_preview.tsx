import { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import { Icon } from "../src/components/ui";
import {
  EscrowDisputeCasePage,
  EscrowDisputeQueuePage,
} from "../src/escrow/dispute_management_pages";
import type {
  EscrowDisputeCaseAdapter,
  EscrowDisputeCaseCopy,
  EscrowDisputeQueueAdapter,
  EscrowDisputeQueueCopy,
} from "../src/escrow/dispute_management_types";
import "./escrow_preview.css";

const tenantId = "synthetic-escrow-backoffice-preview";
const caseId = "synthetic-preview-case";
const queuePath = "/backoffice/escrow/disputes";
const casePath = `${queuePath}/${caseId}`;

const queueCopy: EscrowDisputeQueueCopy = {
  eyebrow: "ESCROW · BACK OFFICE",
  title: "Dispute queue",
  subtitle: "Review disputes supplied by the authorized host.",
  loading: "Loading dispute queue",
  retry: "Try again",
  errorTitle: "Dispute queue could not be loaded",
  errorBody: "The host could not provide the dispute queue. Try again.",
  unavailableTitle: "Dispute queue unavailable",
  unavailableBody: "A dispute queue adapter is not connected to this isolated preview.",
  restrictedTitle: "Dispute queue access restricted",
  restrictedBody: "The host has not supplied access to dispute records.",
  emptyTitle: "No dispute records supplied",
  emptyBody: "Disputes supplied by the host will appear here.",
  searchLabel: "Search disputes",
  searchPlaceholder: "Case, deal, type or responsible party",
  typeFilter: "Dispute type",
  valueFilter: "Value band",
  ageFilter: "Case age",
  allTypes: "All types",
  allValues: "All values",
  allAges: "All ages",
  queueCount: (visible, total) => `Showing ${visible} of ${total} synthetic preview rows`,
  caseColumn: "Case reference",
  dealColumn: "Deal",
  typeColumn: "Type",
  valueColumn: "Value",
  ageColumn: "Age",
  statusColumn: "Status",
  slaColumn: "SLA",
  responsibleColumn: "Responsible party",
  openCase: "Open case",
  noResultsTitle: "No matching preview rows",
  noResultsBody: "Change the search or filters.",
  notSupplied: "Not supplied by host",
  breached: "SLA breach reported by host",
};

const caseCopy: EscrowDisputeCaseCopy = {
  eyebrow: "ESCROW · BACK OFFICE",
  title: "Dispute case",
  backToQueue: "Back to queue",
  loading: "Loading dispute case",
  retry: "Try again",
  unavailableTitle: "Dispute case unavailable",
  unavailableBody: "Case information is not available from the host in this preview.",
  restrictedTitle: "Dispute case access restricted",
  restrictedBody: "The host has not supplied permission to view this case.",
  caseSummary: "Case information",
  termsSnapshot: "Deal terms snapshot",
  evidence: "Evidence and supporting information",
  noEvidence: "No evidence has been supplied by the host.",
  caseHistory: "Case history",
  noHistory: "No case history has been supplied by the host.",
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
  splitUnitHelp:
    "Enter a server-authorized integer value; the preview does not calculate allocations.",
  rationale: "Decision rationale",
  rationalePlaceholder: "Enter the rationale required by the authorized decision workflow",
  reviewDecision: "Review decision",
  confirmTitle: "Confirm decision",
  confirmBody: "This action requires host authorization and is disabled in this preview.",
  cancel: "Cancel",
  confirmSubmit: "Confirm and submit",
  decisionRecorded: "Decision recorded by host.",
  submitError: "The host could not confirm the decision.",
  requiredOutcome: "Select an outcome.",
  requiredRationale: "Enter a rationale.",
  invalidSplitAmount: "Enter a whole-number kobo value.",
  decisionUnavailable: "Decision submission is unavailable in this preview.",
  feeOutcomeContractGap:
    "Fee outcome is host-supplied; the documented contract does not define a fee decision field.",
  notSupplied: "Not supplied by host",
};

const queueAdapter: EscrowDisputeQueueAdapter = {
  async loadQueue() {
    return {
      state: "ready",
      cases: [
        {
          id: caseId,
          caseReferenceLabel: "SYNTHETIC-PREVIEW-CASE",
          dealReferenceLabel: "Synthetic reference only",
          dealTitle: "Example dispute layout · not a customer case",
          disputeTypeLabel: "Preview category",
          valueBandLabel: "Not supplied",
          ageBandLabel: "Not supplied",
          statusLabel: "Preview status · synthetic",
          statusTone: "neutral",
          slaLabel: "Not supplied",
        },
      ],
    };
  },
};

const caseAdapter: EscrowDisputeCaseAdapter = {
  async loadCase({ caseId: requestedCaseId }) {
    if (requestedCaseId !== caseId) return { state: "unavailable" };
    return {
      state: "ready",
      detail: {
        id: caseId,
        caseReferenceLabel: "SYNTHETIC-PREVIEW-CASE",
        dealReferenceLabel: "Synthetic reference only",
        dealTitle: "Example dispute layout · not a customer case",
        caseTypeLabel: "Preview category",
        statusLabel: "Preview status · synthetic",
        statusTone: "neutral",
        summary:
          "Synthetic preview fixture used to inspect the case layout. No customer dispute is represented.",
        termsSnapshot: [],
        evidence: [],
        history: [],
        canDecide: false,
        restrictionMessage:
          "Decision actions are unavailable. No authorized host data or PIN flow is connected.",
        secondReviewStatusLabel: "Not supplied by host",
        appealStatusLabel: "Not supplied by host",
      },
    };
  },
  async authorizeDecision() {
    return null;
  },
  async submitDecision() {
    throw new Error("Decision submission is disabled in the synthetic preview.");
  },
};

function EscrowDisputePreview() {
  const [dark, setDark] = useState(false);
  const [path, setPath] = useState(window.location.pathname.replace(/\/$/, ""));
  const isCase = path.startsWith(`${queuePath}/`);
  const activeCaseId = isCase ? path.slice(queuePath.length + 1) : caseId;

  useEffect(() => {
    document.title = `${isCase ? "Dispute Case" : "Dispute Queue"} · Escrow · Non-production`;
  }, [isCase]);

  const navigate = (nextPath: string) => {
    window.history.pushState({}, "", nextPath);
    setPath(nextPath);
  };

  useEffect(() => {
    const onPopState = () => setPath(window.location.pathname.replace(/\/$/, ""));
    window.addEventListener("popstate", onPopState);
    return () => window.removeEventListener("popstate", onPopState);
  }, []);

  return (
    <div className="merchant-workspace escrow-preview-shell" data-theme={dark ? "dark" : "light"}>
      <aside aria-label="Escrow workspace navigation" className="workspace-sidebar">
        <div className="workspace-brand">
          <span aria-hidden="true" className="brand-mark">
            S
          </span>
          <span>
            <strong>Sixth Bank</strong>
            <small>Escrow back office</small>
          </span>
        </div>
        <div className="tenant-card">
          <span aria-hidden="true" className="tenant-avatar">
            P
          </span>
          <span className="tenant-name">Synthetic preview</span>
          <span className="tenant-caption">No host data connected</span>
        </div>
        <nav aria-label="Escrow screens" className="workspace-nav">
          <a className="nav-item" href="/escrow/web/deals">
            <Icon name="invoice" />
            <span>My deals</span>
          </a>
          <a
            aria-current={isCase ? undefined : "page"}
            className={`nav-item${!isCase ? " is-active" : ""}`}
            href={queuePath}
            onClick={(event) => {
              event.preventDefault();
              navigate(queuePath);
            }}
          >
            <Icon name="warning" />
            <span>Dispute queue</span>
          </a>
          <a className="nav-item" href="/backoffice/escrow/config">
            <Icon name="fees" />
            <span>Templates and fees</span>
          </a>
        </nav>
        <div className="sidebar-footer">
          <small>Isolated non-production preview</small>
        </div>
      </aside>
      <div className="workspace-main">
        <header className="workspace-topbar">
          <span className="workspace-context">Escrow · Back office</span>
          <div className="topbar-actions">
            <button
              aria-label={dark ? "Switch to light theme" : "Switch to dark theme"}
              className="icon-button"
              onClick={() => setDark((value) => !value)}
              type="button"
            >
              <Icon name={dark ? "sun" : "moon"} />
            </button>
            <span aria-label="Synthetic preview" className="profile-chip">
              P
            </span>
          </div>
        </header>
        <section className="workspace-content">
          <div className="preview-notice preview-banner-content escrow-preview-notice" role="note">
            <p>
              <strong>NON-PRODUCTION PREVIEW</strong> · Synthetic layout fixture only. No case
              records, evidence, authorization, decisions or outcomes are connected.
            </p>
          </div>
          {isCase ? (
            <EscrowDisputeCasePage
              adapter={caseAdapter}
              caseId={activeCaseId}
              copy={caseCopy}
              onBackToQueue={() => navigate(queuePath)}
              tenantId={tenantId}
            />
          ) : (
            <EscrowDisputeQueuePage
              adapter={queueAdapter}
              copy={queueCopy}
              onOpenCase={() => navigate(casePath)}
              tenantId={tenantId}
            />
          )}
        </section>
      </div>
    </div>
  );
}

export function renderEscrowDisputePreview(element: HTMLElement) {
  createRoot(element).render(<EscrowDisputePreview />);
}
