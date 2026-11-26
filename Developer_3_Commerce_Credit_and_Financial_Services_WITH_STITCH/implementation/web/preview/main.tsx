import { useMemo, useRef, useState } from "react";
import { createRoot } from "react-dom/client";
import { renderEscrowPreview } from "./escrow_preview";
import { renderEscrowDisputePreview } from "./escrow_dispute_preview";
import { renderEscrowTemplatesPreview } from "./escrow_templates_preview";
import "./preview.css";
import {
  BusinessDashboardPage,
  InvoicesPage,
  MerchantWorkspaceShell,
  PaymentLinksPage,
  ReportsAndExportsPage,
  TeamVerificationPage,
} from "../src/index";
import type {
  DashboardResult,
  InvoiceRow,
  MerchantWebCopy,
  MerchantWebScreen,
  PaymentLinkRow,
  ReportsResult,
  TeamVerificationAdapter,
  TeamVerificationOverview,
} from "../src/index";

const copy: MerchantWebCopy = {
  common: {
    brand: "Sixth Bank",
    workspaceLabel: "Merchant tools",
    previewLabel: "Isolated preview",
    previewNotice:
      "Synthetic data only. No API, authentication, payment, or document operations are connected.",
    invoicesNav: "Invoices",
    paymentLinksNav: "Payment links",
    dashboardNav: "Dashboard",
    reportsNav: "Reports",
    teamNav: "Team and verification",
    searchLabel: "Search",
    searchPlaceholder: "Search current results",
    close: "Close",
    retry: "Retry",
    loading: "Loading records",
    errorTitle: "Could not load records",
    errorBody: "Try again.",
  },
  dashboard: {
    eyebrow: "MERCHANT TOOLS",
    title: "Business dashboard",
    subtitle: "A current overview of your business activity.",
    loading: "Loading business dashboard",
    retry: "Retry",
    errorTitle: "Dashboard unavailable",
    errorBody: "Try again.",
    restrictedTitle: "Dashboard access restricted",
    restrictedBody: "Your host has restricted access to this business overview.",
    sales: "Sales",
    fees: "Fees",
    refunds: "Refunds",
    outstandingInvoices: "Outstanding invoices",
    chartTitle: "Sales activity",
    chartDescription: "Synthetic sales values for preview only.",
    recentActivity: "Recent activity",
    activityTitle: "Recent business records",
    activityAmount: "Amount",
    activityStatus: "Status",
    activityTime: "Time",
    emptyTitle: "No dashboard data yet",
    emptyBody: "Preview figures will appear here when sample data is supplied.",
    noActivity: "No recent activity is available in this sample.",
    viewReports: "View reports",
    viewInvoices: "View invoices",
    viewDetails: "View details",
  },
  invoices: {
    eyebrow: "MERCHANT TOOLS",
    title: "Invoices",
    subtitle: "Review and send customer invoices.",
    loading: "Loading invoices",
    retry: "Retry",
    errorTitle: "Invoices unavailable",
    errorBody: "Try again.",
    searchLabel: "Search invoices",
    searchPlaceholder: "Invoice number or customer",
    createInvoice: "Create invoice",
    filterLabel: "Invoice status filters",
    all: "All invoices",
    unpaid: "Unpaid",
    overdue: "Overdue",
    paid: "Paid",
    invoiceNumber: "Invoice",
    customer: "Customer",
    issueDate: "Issue date",
    dueDate: "Due date",
    amount: "Amount",
    status: "Status",
    statusDraft: "Draft",
    statusSent: "Sent",
    statusViewed: "Viewed",
    statusPartiallyPaid: "Partially paid",
    statusPaid: "Paid",
    statusOverdue: "Overdue",
    statusVoid: "Void",
    action: "Action",
    emptyTitle: "No invoices yet",
    emptyBody: "Invoices supplied by your host will appear here.",
    noResultsTitle: "No matching invoices",
    noResultsBody: "Try a different search.",
    detailTitle: "Invoice details",
    sendInvoice: "Send or remind",
    sendDialogTitle: "Send invoice",
    sendDialogBody: "Choose the delivery channel for this invoice.",
    channelLabel: "Delivery channel",
    linkChannel: "Link",
    smsChannel: "SMS",
    emailChannel: "Email",
    cancel: "Cancel",
    send: "Send",
    sending: "Sending…",
    sent: "Sent",
    sendSuccess: "Preview request completed locally.",
    sendError: "Could not complete the preview action.",
    selectInvoice: "Select an invoice",
    createUnavailable: "Invoice creation is handled by the host.",
  },
  paymentLinks: {
    eyebrow: "MERCHANT TOOLS",
    title: "Payment links",
    subtitle: "Create and review links for customer payments.",
    loading: "Loading payment links",
    retry: "Retry",
    errorTitle: "Payment links unavailable",
    errorBody: "Try again.",
    searchLabel: "Search payment links",
    searchPlaceholder: "Search current links",
    createLink: "Create payment link",
    filterLabel: "Payment link status filters",
    all: "All links",
    active: "Active",
    expired: "Expired",
    name: "Description",
    type: "Use",
    amount: "Amount",
    uses: "Use limit",
    expires: "Expires",
    status: "Status",
    statusActive: "Active",
    statusExpired: "Expired",
    reusable: "Multiple use",
    singleUse: "Single use",
    noExpiry: "No expiry supplied",
    unnamedLink: "Payment link",
    linkReferenceUnavailable: "Link reference is not returned by this preview.",
    emptyTitle: "No payment links yet",
    emptyBody: "Links supplied by your host will appear here.",
    noResultsTitle: "No matching links",
    noResultsBody: "Try a different search.",
    detailTitle: "Link details",
    selectLink: "Select a link",
    createDialogTitle: "Create payment link",
    createDialogBody: "Enter the documented link settings.",
    amountType: "Amount type",
    fixedAmount: "Fixed amount",
    openAmount: "Open amount",
    amountLabel: "Amount (NGN)",
    amountPlaceholder: "0.00",
    amountRequired: "Enter an amount.",
    amountInvalid: "Enter a positive amount with up to two decimal places.",
    description: "Description (optional)",
    descriptionPlaceholder: "What is this payment for?",
    expiry: "Expiry (optional)",
    expiryInvalid: "Enter a valid expiry date and time.",
    multiUse: "Multiple use",
    cancel: "Cancel",
    create: "Create link",
    creating: "Creating…",
    created: "Preview link created locally; no link URL is generated.",
    createError: "Could not create preview link.",
  },
  reports: {
    eyebrow: "MERCHANT TOOLS",
    title: "Reports and exports",
    subtitle: "Review synthetic sales, fee, refund, and tax summaries.",
    loading: "Loading preview report",
    retry: "Retry",
    errorTitle: "Reports unavailable",
    errorBody: "Try again.",
    restrictedTitle: "Reports access restricted",
    restrictedBody: "Your host has restricted access to these reports.",
    from: "From date",
    to: "To date",
    applyRange: "Apply dates",
    invalidRange: "The start date must be on or before the end date.",
    sales: "Sales",
    fees: "Fees",
    refunds: "Refunds",
    tax: "Tax summary",
    summaryTitle: "Synthetic report summary",
    emptyTitle: "No report data for this period",
    emptyBody: "Choose another period or try again later.",
    export: "Export report",
    exporting: "Generating preview…",
    exportSuccess: "Preview export action completed locally; no file was created.",
    exportError: "The preview export action failed.",
  },
  teamVerification: {
    eyebrow: "MERCHANT TOOLS",
    title: "Team and verification",
    subtitle: "Review synthetic business verification and team access.",
    loading: "Loading preview team and verification",
    retry: "Retry",
    errorTitle: "Team details unavailable",
    errorBody: "Try again.",
    teamTitle: "Team members and permissions",
    teamDescription: "Synthetic role and permission examples supplied by this preview.",
    invite: "Invite team member",
    emptyTitle: "No team members in this preview",
    emptyBody: "Synthetic team rows will appear here when included in preview data.",
    member: "Team member",
    owner: "Owner",
    contact: "Phone or contact",
    role: "Role",
    permissions: "Permissions",
    selectMember: "Select a team member",
    noPermissions: "No permission details are available in this preview row.",
    verificationTitle: "Business verification",
    verificationPending: "Pending verification",
    verificationVerified: "Verified",
    verificationRejected: "Rejected",
    verificationMessage: "Synthetic preview status only. No verification service is connected.",
    rejectedReason: "Sample reason",
    inviteTitle: "Invite team member",
    inviteDescription: "Preview only. No invitation will be sent.",
    phone: "Phone number",
    phoneRequired: "Enter a phone number.",
    roleLabel: "Role",
    manager: "Manager",
    cashier: "Cashier",
    accountant: "Accountant",
    cancel: "Cancel",
    submitInvite: "Preview invite",
    submitting: "Completing preview action…",
    inviteSuccess: "Preview invite action completed locally; no invitation was sent.",
    inviteError: "The local preview action failed.",
  },
};

const initialInvoices: InvoiceRow[] = [
  {
    id: "preview-invoice-1",
    displayNumber: "INV-2048",
    customerName: "Amina Textiles",
    issueDate: "2026-10-14",
    dueDate: "2026-11-14",
    amountKobo: 2450000,
    status: "overdue",
  },
  {
    id: "preview-invoice-2",
    displayNumber: "INV-2051",
    customerName: "Northstar Foods",
    issueDate: "2026-11-03",
    dueDate: "2026-12-03",
    amountKobo: 875000,
    status: "sent",
  },
  {
    id: "preview-invoice-3",
    displayNumber: "INV-2054",
    customerName: "Olive House Studio",
    issueDate: "2026-11-18",
    dueDate: "2026-12-18",
    amountKobo: 1299900,
    status: "paid",
  },
];
const initialLinks: PaymentLinkRow[] = [
  {
    id: "preview-link-1",
    description: "Weekly produce box",
    amountKobo: 125050,
    expiresAt: "2026-12-01T12:00:00.000Z",
    multiUse: true,
    status: "active",
  },
  {
    id: "preview-link-2",
    description: "Workshop registration",
    amountKobo: null,
    expiresAt: null,
    multiUse: false,
    status: "active",
  },
  {
    id: "preview-link-3",
    description: "Autumn market stall",
    amountKobo: 500000,
    expiresAt: "2026-10-30T12:00:00.000Z",
    multiUse: true,
    status: "expired",
  },
];

const initialDashboard: DashboardResult = {
  state: "ready",
  snapshot: {
    metrics: {
      salesKobo: 1_248_050_000,
      feesKobo: 12_400_000,
      refundsKobo: 8_250_000,
      outstandingInvoicesKobo: 465_000_000,
    },
    salesSeries: [
      { label: "Mon", amountKobo: 142_000_000 },
      { label: "Tue", amountKobo: 186_000_000 },
      { label: "Wed", amountKobo: 124_000_000 },
      { label: "Thu", amountKobo: 208_000_000 },
      { label: "Fri", amountKobo: 242_000_000 },
      { label: "Sat", amountKobo: 176_000_000 },
      { label: "Sun", amountKobo: 170_000_000 },
    ],
    recentActivity: [
      {
        id: "preview-activity-1",
        title: "Counter sale",
        amountKobo: 12_500_000,
        statusLabel: "Completed",
        statusTone: "success",
        timeLabel: "Today, 10:14",
      },
      {
        id: "preview-activity-2",
        title: "Payment link",
        amountKobo: 8_450_000,
        statusLabel: "Pending",
        statusTone: "warning",
        timeLabel: "Today, 09:42",
      },
      {
        id: "preview-activity-3",
        title: "Invoice payment",
        amountKobo: 45_000_000,
        statusLabel: "Completed",
        statusTone: "success",
        timeLabel: "Yesterday",
      },
    ],
  },
};

const initialReport: ReportsResult = {
  state: "ready",
  summary: {
    salesKobo: 8_465_000_000,
    feesKobo: 73_750_000,
    refundsKobo: 12_500_000,
    taxKobo: 241_000_000,
  },
};

const initialTeam: TeamVerificationOverview = {
  verification: {
    state: "pending",
    message: "Synthetic preview status only. No verification service is connected.",
  },
  members: [
    {
      id: "preview-owner",
      name: "Sample Business Owner",
      contact: "+234 800 000 0001",
      role: "OWNER",
      permissions: ["Business overview", "Team access review"],
    },
    {
      id: "preview-manager",
      name: "Sample Team Manager",
      contact: "+234 800 000 0002",
      role: "MANAGER",
      permissions: ["Invoice and payment-link management"],
    },
    {
      id: "preview-cashier",
      name: "Sample Cashier",
      contact: "+234 800 000 0003",
      role: "CASHIER",
      permissions: ["Payment collection"],
    },
  ],
};

function PreviewApp() {
  const [screen, setScreen] = useState<MerchantWebScreen>("dashboard");
  const [darkMode, setDarkMode] = useState(false);
  const [paymentLinks, setPaymentLinks] = useState(initialLinks);
  const invoiceStore = useRef(initialInvoices);
  const linkStore = useRef(paymentLinks);
  linkStore.current = paymentLinks;

  const invoiceAdapter = useMemo(
    () => ({
      loadInvoices: async ({ filter }: { filter: "all" | "unpaid" | "overdue" | "paid" }) => {
        const rows = invoiceStore.current;
        if (filter === "all") return rows;
        return rows.filter((row) =>
          filter === "unpaid"
            ? row.status !== "paid" && row.status !== "void"
            : row.status === filter,
        );
      },
      sendInvoice: async () => undefined,
    }),
    [],
  );
  const paymentLinkAdapter = useMemo(
    () => ({
      loadPaymentLinks: async ({ filter }: { filter: "all" | "active" | "expired" }) => {
        const rows = linkStore.current;
        return filter === "all" ? rows : rows.filter((row) => row.status === filter);
      },
      createPaymentLink: async ({
        request,
      }: {
        request: {
          amountKobo?: number;
          description?: string;
          expiresAt?: string;
          multiUse?: boolean;
        };
      }) => {
        const row: PaymentLinkRow = {
          id: `preview-link-${Date.now()}`,
          description: request.description ?? "Payment link",
          amountKobo: request.amountKobo ?? null,
          expiresAt: request.expiresAt ?? null,
          multiUse: request.multiUse ?? false,
          status: "active",
        };
        const next = [row, ...linkStore.current];
        linkStore.current = next;
        setPaymentLinks(next);
      },
    }),
    [],
  );
  const dashboardAdapter = useMemo(() => ({ loadDashboard: async () => initialDashboard }), []);
  const reportsAdapter = useMemo(
    () => ({
      loadReport: async () => initialReport,
      exportReport: async () => undefined,
    }),
    [],
  );
  const teamVerificationAdapter = useMemo<TeamVerificationAdapter>(
    () => ({
      loadOverview: async () => initialTeam,
      inviteMember: async () => undefined,
    }),
    [],
  );

  return (
    <MerchantWorkspaceShell
      activeScreen={screen}
      businessName="Sample business"
      copy={copy.common}
      darkMode={darkMode}
      onNavigate={setScreen}
      onToggleTheme={() => setDarkMode((current) => !current)}
      notice={
        <div className="preview-banner-content">
          <p>
            <strong>NON-PRODUCTION PREVIEW</strong> · Synthetic records only. No API,
            authentication, payment, or document operation is connected.
          </p>
        </div>
      }
    >
      {screen === "dashboard" ? (
        <BusinessDashboardPage
          adapter={dashboardAdapter}
          copy={copy.dashboard}
          onNavigate={setScreen}
          tenantId="preview-tenant"
        />
      ) : screen === "invoices" ? (
        <InvoicesPage adapter={invoiceAdapter} copy={copy.invoices} tenantId="preview-tenant" />
      ) : screen === "paymentLinks" ? (
        <PaymentLinksPage
          adapter={paymentLinkAdapter}
          copy={copy.paymentLinks}
          tenantId="preview-tenant"
        />
      ) : screen === "reports" ? (
        <ReportsAndExportsPage
          adapter={reportsAdapter}
          copy={copy.reports}
          reportType="preview-only-report"
          tenantId="preview-tenant"
        />
      ) : (
        <TeamVerificationPage
          adapter={teamVerificationAdapter}
          copy={copy.teamVerification}
          tenantId="preview-tenant"
        />
      )}
    </MerchantWorkspaceShell>
  );
}

const root = document.getElementById("root")!;
const previewPath = window.location.pathname.replace(/\/$/, "");
if (previewPath === "/escrow/web/deals") {
  renderEscrowPreview(root);
} else if (
  previewPath === "/backoffice/escrow/disputes" ||
  /^\/backoffice\/escrow\/disputes\/[^/]+$/.test(previewPath)
) {
  renderEscrowDisputePreview(root);
} else if (previewPath === "/backoffice/escrow/config") {
  renderEscrowTemplatesPreview(root);
} else {
  createRoot(root).render(<PreviewApp />);
}
