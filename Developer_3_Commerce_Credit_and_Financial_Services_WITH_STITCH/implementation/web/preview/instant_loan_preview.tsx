import { useState } from "react";
import { createRoot } from "react-dom/client";
import { Icon } from "../src/components/ui";
import { LoanApplicationsPage, LoanPortfolioPage } from "../src/instant_loan/loan_backoffice_pages";
import type { LoanBackofficeCopy } from "../src/instant_loan/loan_backoffice_copy";
import type {
  LoanApplicationsAdapter,
  LoanPortfolioAdapter,
} from "../src/instant_loan/loan_backoffice_types";
import { LoanProductsPage, LoanSettlementsPage } from "../src/instant_loan/loan_admin_pages";
import type { LoanAdminCopy } from "../src/instant_loan/loan_admin_copy";
import type {
  LoanProductsAdapter,
  LoanSettlementsAdapter,
} from "../src/instant_loan/loan_admin_types";
import "./instant_loan_preview.css";

const copy: LoanBackofficeCopy = {
  common: {
    brand: "YourApp",
    preview: "Instant Loan back office",
    nonProduction:
      "NON-PRODUCTION PREVIEW · No live API, authentication, authorization, loan decision, contact or collection operation is connected.",
    applicationsNav: "Applications queue",
    portfolioNav: "Portfolio and collections",
    switchTheme: "Switch theme",
    switchLight: "Switch to light theme",
    switchDark: "Switch to dark theme",
    loading: "Loading host-provided loan information",
    retry: "Retry",
    unavailableTitle: "Host data unavailable",
    unavailableBody:
      "This isolated preview does not connect to the back-office API. No customer, application or portfolio records are included.",
    restrictedTitle: "Access restricted",
    restrictedBody: "The host has not confirmed permission to view this information.",
    emptyTitle: "No records available",
    emptyBody: "No host-provided records are available for this view.",
    errorTitle: "Information could not be loaded",
    errorBody: "Try loading the host-provided information again.",
    hostUnavailable: "Not supplied by host",
  },
  applications: {
    eyebrow: "INSTANT LOAN · CREDIT OPERATIONS",
    title: "Applications queue",
    subtitle: "Review referred applications with masked customer information.",
    applicationCount: "applications",
    reference: "Application",
    customer: "Customer",
    score: "Score",
    reasons: "Referral reasons",
    exposure: "Exposure",
    sla: "SLA",
    action: "Action",
    open: "Review",
    detailTitle: "Application detail",
    customerView: "Masked customer view",
    decisionReason: "Decision reason",
    decisionReasonPlaceholder: "Enter the documented decision reason",
    approve: "Approve",
    decline: "Decline",
    submit: "Submit decision",
    cancel: "Cancel",
    decisionUnavailable:
      "Decision submission is unavailable until host authorization and API integration are supplied.",
    decisionPending: "Submitting decision…",
    decisionSubmitted: "The host accepted the decision request.",
    decisionError: "The host could not confirm the decision. Check its status before retrying.",
    reasonRequired: "Enter a reason before submitting.",
    noReasons: "No reason details supplied.",
    noSelection: "Select an application to review.",
  },
  portfolio: {
    eyebrow: "INSTANT LOAN · CREDIT OPERATIONS",
    title: "Portfolio and collections",
    subtitle: "Monitor host-supplied portfolio performance, arrears and hardship cases.",
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
    contactRestrictions:
      "Contact-hour restrictions are shown only when supplied by the host. No customer contact actions are connected.",
    noContactHistory: "No host contact history supplied.",
    noApprovedScripts: "No host-approved script supplied.",
    hardshipCases: "Hardship cases",
    caseStatus: "Case status",
    summary: "Summary",
    openCase: "Open case",
    caseDetails: "Case details",
    noCaseSelected: "Select a host-provided case to review its details.",
    caseSelected: "Selected case",
  },
};

const applicationsAdapter: LoanApplicationsAdapter = {
  loadApplications: async () => ({ state: "unavailable" }),
  decideApplication: async () => {
    throw new Error("No decision service is connected in preview.");
  },
};
const portfolioAdapter: LoanPortfolioAdapter = {
  loadPortfolio: async () => ({ state: "unavailable" }),
};

const adminCopy: LoanAdminCopy = {
  common: copy.common,
  products: {
    eyebrow: "INSTANT LOAN · PRODUCT ADMIN",
    title: "Product configuration",
    subtitle: "Review product versions and submit host-authorized configuration proposals.",
    listTitle: "Products and versions",
    product: "Product",
    version: "Version",
    status: "Status",
    effectiveFrom: "Effective from",
    currentConfiguration: "Current host configuration",
    chooseProduct: "Select a host-provided product",
    configuration: "Configuration object",
    configHelp:
      "Edit only the configuration supplied by the host. No product terms or fee values are included in this preview.",
    effectiveDateHelp: "Select the requested effective date and time.",
    propose: "Submit for approval",
    proposing: "Submitting proposal…",
    proposalPending: "The host accepted the proposal for its configured approval workflow.",
    proposalError: "The host could not confirm the proposal. Check its status before retrying.",
    permissionUnavailable:
      "Proposal submission is available only when the host confirms product-admin permission. Approval remains subject to server-enforced dual control.",
    validConfig: "Enter a valid JSON object.",
    validDate: "Select an effective date and time.",
  },
  settlements: {
    eyebrow: "INSTANT LOAN · FINANCE",
    title: "Partner settlement",
    subtitle: "Review host-provided settlement statements, partner splits and exceptions.",
    period: "Settlement period",
    statement: "Settlement statement",
    status: "Status",
    total: "Statement total",
    splits: "Partner splits",
    exceptions: "Exceptions",
    noSplits: "No split details were supplied by the host.",
    noExceptions: "No exceptions were supplied by the host.",
    approve: "Approve settlement",
    approving: "Submitting approval…",
    approvalAccepted:
      "The host accepted the approval request; settlement status remains host-controlled.",
    approvalError: "The host could not confirm approval. Check the host status before retrying.",
    approvalUnavailable:
      "Approval requires host-confirmed Finance permission, dual control, a PIN token and an idempotency key.",
    export: "Export statement",
    exportUnavailable: "Export is unavailable until the host provides an export handler.",
    exportError: "The host could not export this statement.",
    selectPeriod: "Choose a settlement period",
  },
};

const productsAdapter: LoanProductsAdapter = {
  loadProducts: async () => ({ state: "unavailable" }),
  proposeProductVersion: async () => {
    throw new Error("No product configuration service is connected in preview.");
  },
};
const settlementsAdapter: LoanSettlementsAdapter = {
  loadSettlements: async () => ({ state: "unavailable" }),
  approveSettlement: async () => {
    throw new Error("No settlement service is connected in preview.");
  },
};

function InstantLoanPreview({ route }: { readonly route: string }) {
  const [dark, setDark] = useState(false);
  const screen = route.endsWith("/products")
    ? "products"
    : route.endsWith("/settlement")
      ? "settlement"
      : route.endsWith("/portfolio")
        ? "portfolio"
        : "applications";
  const portfolio = screen === "portfolio";
  return (
    <div className="merchant-workspace loan-preview-workspace" data-theme={dark ? "dark" : "light"}>
      <aside aria-label={copy.common.preview} className="workspace-sidebar">
        <div className="workspace-brand">
          <span aria-hidden="true" className="brand-mark">
            Y
          </span>
          <span>
            <strong>{copy.common.brand}</strong>
            <small>{copy.common.preview}</small>
          </span>
        </div>
        <nav aria-label="Instant Loan screens" className="workspace-nav">
          <a
            aria-current={!portfolio ? "page" : undefined}
            className={!portfolio ? "nav-item is-active" : "nav-item"}
            href="/backoffice/loans/applications"
          >
            <Icon name="team" />
            <span>{copy.common.applicationsNav}</span>
          </a>
          <a
            aria-current={portfolio ? "page" : undefined}
            className={portfolio ? "nav-item is-active" : "nav-item"}
            href="/backoffice/loans/portfolio"
          >
            <Icon name="chart" />
            <span>{copy.common.portfolioNav}</span>
          </a>
          <a
            aria-current={screen === "products" ? "page" : undefined}
            className={screen === "products" ? "nav-item is-active" : "nav-item"}
            href="/backoffice/loans/products"
          >
            <Icon name="invoice" />
            <span>Product configuration</span>
          </a>
          <a
            aria-current={screen === "settlement" ? "page" : undefined}
            className={screen === "settlement" ? "nav-item is-active" : "nav-item"}
            href="/backoffice/loans/settlement"
          >
            <Icon name="chart" />
            <span>Partner settlement</span>
          </a>
        </nav>
        <div className="sidebar-footer">{copy.common.preview}</div>
      </aside>
      <div className="workspace-main">
        <header className="workspace-topbar">
          <span className="workspace-context">{copy.common.preview}</span>
          <button
            aria-label={dark ? copy.common.switchLight : copy.common.switchDark}
            className="icon-button"
            onClick={() => setDark((value) => !value)}
            type="button"
          >
            <Icon name={dark ? "sun" : "moon"} />
          </button>
        </header>
        <div className="workspace-content">
          <div className="preview-notice">
            <p>
              <strong>NON-PRODUCTION PREVIEW</strong> ·{" "}
              {copy.common.nonProduction.split("· ").at(-1)}
            </p>
          </div>
          <div className="loan-preview-screen-list">
            <span>Implemented screens</span>
            <a href="/backoffice/loans/applications">W-LOAN-001</a>
            <a href="/backoffice/loans/portfolio">W-LOAN-002</a>
            <a href="/backoffice/loans/products">W-LOAN-003</a>
            <a href="/backoffice/loans/settlement">W-LOAN-004</a>
          </div>
          {screen === "products" ? (
            <LoanProductsPage
              adapter={productsAdapter}
              copy={adminCopy}
              tenantId="preview-tenant"
            />
          ) : screen === "settlement" ? (
            <LoanSettlementsPage
              adapter={settlementsAdapter}
              copy={adminCopy}
              tenantId="preview-tenant"
            />
          ) : portfolio ? (
            <LoanPortfolioPage adapter={portfolioAdapter} copy={copy} tenantId="preview-tenant" />
          ) : (
            <LoanApplicationsPage
              adapter={applicationsAdapter}
              copy={copy}
              tenantId="preview-tenant"
            />
          )}
        </div>
      </div>
    </div>
  );
}

export function renderInstantLoanPreview(root: HTMLElement, route: string) {
  createRoot(root).render(<InstantLoanPreview route={route} />);
}

export { InstantLoanPreview };
