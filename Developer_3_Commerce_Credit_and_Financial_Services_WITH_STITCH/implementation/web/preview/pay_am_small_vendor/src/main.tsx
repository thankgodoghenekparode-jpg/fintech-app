import { useEffect, useMemo, useState } from "react";
import { createRoot } from "react-dom/client";
import {
  PasVendorDashboardPage,
  PasVendorCreditOffersPage,
  PasVendorOrdersPage,
  PasVendorPayoutsPage,
  PasVendorPlansPage,
  PasVendorProductsPage,
  PasVendorTeamVerificationPage,
  PasVendorWorkspaceShell,
  vendorOrdersCopy,
  vendorPlansCopy,
  type PasVendorCreditAdapter,
  type PasVendorPayoutAdapter,
  type PasVendorFinanceCopy,
  type PasVendorTeamAdapter,
  type PasVendorTeamCopy,
} from "../../../src/index";
import type {
  PasVendorCatalogAdapter,
  PasVendorDashboardAdapter,
  PasVendorDashboardCopy,
  PasVendorOrdersAdapter,
  PasVendorPlansAdapter,
  PasVendorPage,
  PasVendorProductsCopy,
  PasVendorShellCopy,
} from "../../../src/index";

const tenantId = "synthetic-vendor-tenant";
const dashboardPath = `/vendor/${tenantId}/dashboard`;
const productsPath = `/vendor/${tenantId}/products`;
const ordersPath = `/vendor/${tenantId}/orders`;
const plansPath = `/vendor/${tenantId}/plans`;
const creditPath = `/vendor/${tenantId}/credit`;
const payoutsPath = `/vendor/${tenantId}/payouts`;
const teamPath = `/vendor/${tenantId}/team`;

function pageForPath(path: string): PasVendorPage {
  if (path.endsWith("/products")) return "products";
  if (path.endsWith("/orders")) return "orders";
  if (path.endsWith("/plans")) return "plans";
  if (path.endsWith("/credit")) return "credit";
  if (path.endsWith("/payouts")) return "payouts";
  if (path.endsWith("/team")) return "team";
  return "dashboard";
}

const shellCopy: PasVendorShellCopy = {
  brand: "YourApp Merchant",
  workspaceLabel: "Pay Am Small vendor portal",
  previewLabel: "Isolated preview",
  dashboardNav: "Dashboard",
  productsNav: "Products & Prices",
  ordersNav: "Orders & Fulfilment",
  plansNav: "Plans & Customers",
  creditNav: "Credit Offers",
  payoutsNav: "Payouts & Wallet",
  teamNav: "Team & Verification",
  settingsNav: "Settings",
  helpNav: "Help & Support",
  signOutNav: "Sign out",
  switchThemeLight: "Switch to light theme",
  switchThemeDark: "Switch to dark theme",
};

const financeCopy: PasVendorFinanceCopy = {
  credit: {
    title: "Credit Offers",
    subtitle: "Review host-supplied credit requests.",
    loading: "Loading credit requests",
    error: "Credit requests could not be loaded.",
    restricted: "Credit access is restricted by the host.",
    unavailable: "No approved credit-offer list is connected. Offer data is not fabricated.",
    empty: "No credit requests were supplied.",
    search: "Search requests",
    buyer: "Buyer",
    product: "Product",
    requested: "Requested amount",
    status: "Status",
    details: "Request details",
    risk: "Credit decisions require approval",
    riskCopy:
      "Vendor-funded credit is subject to legal and host approval. No decision can be submitted in this preview.",
    notSupplied: "Not supplied",
    disabledDecision:
      "Decision actions remain unavailable until legal approval, host authorization and supported request data are provided.",
    decisionAccepted: "Decision submitted to the host.",
    decisionError: "The host could not process the decision.",
    reason: "Decision reason (if supported)",
  },
  payouts: {
    title: "Payouts & Wallet",
    subtitle: "Review payout information supplied by your host.",
    loading: "Loading payouts",
    error: "Payout information could not be loaded.",
    restricted: "Payout access is restricted by the host.",
    unavailable:
      "Payout values and history are unavailable until the host supplies the documented response data.",
    empty: "No payout records were supplied.",
    available: "Available balance",
    holdback: "Pending holdback",
    settled: "Settled total",
    account: "Settlement account",
    ledger: "Payout history",
    reference: "Reference",
    date: "Date",
    order: "Order",
    gross: "Gross",
    fee: "Fee",
    net: "Net",
    status: "Status",
    notSupplied: "Not supplied",
    exportUnavailable: "Statements unavailable",
  },
};

const teamCopy: PasVendorTeamCopy = {
  title: "Team & Verification",
  subtitle: "Review team roles and business verification information supplied by your host.",
  loading: "Loading team and verification information",
  error: "Team information could not be loaded.",
  retry: "Retry",
  unavailable:
    "No team-list or business-verification read endpoint is documented. Information is not fabricated.",
  restricted: "Your host has restricted this information.",
  empty: "No team members were supplied.",
  team: "Team members",
  verification: "Business verification",
  search: "Search team members and roles",
  allMembers: "All team members",
  roles: "Roles & access",
  branch: "Branch",
  access: "Access scope",
  authorization: "Handover authorization",
  lastActive: "Last active",
  status: "Status",
  details: "Member permissions",
  permissions: "Permissions matrix",
  noPermissions: "Permission details were not supplied by the host.",
  noDocuments: "No verification documents were supplied by the host.",
  notSupplied: "Not supplied",
  invite: "Invite new team member",
  inviteUnavailable: "No invite API is documented.",
  download: "Download verification dossier",
  update: "Update verification filings",
  security: "Store security protocol",
  rejectedReason: "Reason",
};

const dashboardCopy: PasVendorDashboardCopy = {
  eyebrow: "PAY AM SMALL · VENDOR",
  title: "Vendor dashboard",
  subtitle: "Review host-supplied marketplace activity and operational alerts.",
  loading: "Loading vendor dashboard",
  retry: "Retry",
  errorTitle: "Dashboard unavailable",
  errorBody: "The host could not provide dashboard information. Try again.",
  restrictedTitle: "Dashboard access restricted",
  restrictedBody: "Your host has restricted access to this vendor overview.",
  unavailableTitle: "Dashboard data is not connected",
  unavailableBody:
    "No dashboard endpoint or host data is configured for this preview. Values and activity are not fabricated.",
  emptyTitle: "No dashboard data supplied",
  emptyBody: "The host has not supplied vendor activity for this view.",
  orders: "Orders",
  activePlans: "Active plans",
  payouts: "Payouts",
  disputes: "Disputes",
  salesChart: "Sales activity",
  completionChart: "Plan completion",
  alerts: "Operational alerts",
  noChartData: "Chart values are unavailable without host-supplied data.",
  noAlerts: "No low-stock or late-delivery alerts were supplied.",
  viewProducts: "Products & prices",
  unavailableValue: "Not supplied",
};

const productsCopy: PasVendorProductsCopy = {
  eyebrow: "PAY AM SMALL · CATALOGUE",
  title: "Products & Prices",
  subtitle: "Review host-supplied catalogue entries or prepare a documented product request.",
  loading: "Loading vendor catalogue",
  retry: "Retry",
  errorTitle: "Catalogue unavailable",
  errorBody: "The host could not provide catalogue data. Try again.",
  restrictedTitle: "Catalogue access restricted",
  restrictedBody: "Your host has restricted access to this vendor catalogue.",
  unavailableTitle: "Catalogue data is not connected",
  unavailableBody:
    "No product-list endpoint is documented. The preview shows a synthetic example only.",
  emptyTitle: "No products supplied",
  emptyBody: "No products were returned by the host adapter.",
  search: "Search products",
  searchPlaceholder: "Search name, category, or SKU",
  addProduct: "Add product",
  tableTitle: "Product catalogue",
  product: "Product",
  category: "Category",
  price: "Retail price",
  stock: "Stock",
  modes: "Plan options",
  deliveryDays: "Delivery days",
  lockDays: "Max lock days",
  status: "Price status",
  synthetic: "Synthetic preview item",
  notSupplied: "Not supplied",
  noResultsTitle: "No matching products",
  noResultsBody: "Try another search or category.",
  lockNoticeTitle: "Locked-price commitment",
  lockNoticeBody:
    "For an active Price-lock plan, the vendor commits to honour its locked price for the plan duration and reserve stock when that plan starts.",
  lockedPrice: "Price change blocked · active plans",
  lockStatusUnavailable: "Lock status not supplied",
  detailTitle: "Product details",
  createTitle: "Add product",
  createDescription:
    "Enter the documented product fields. Values remain with the injected host adapter; this preview is not connected to a live service.",
  titleField: "Product name",
  priceField: "Retail price (NGN)",
  stockField: "Stock quantity",
  modeField: "Plan options",
  deliveryField: "Committed delivery days",
  lockDaysField: "Maximum lock days (optional)",
  modesUnavailable:
    "Approved plan-mode values were not provided by the host. Submission is unavailable until those values are confirmed.",
  required: "Complete this required field.",
  integerInvalid: "Enter a whole-number value.",
  priceInvalid: "Enter a naira amount with up to two decimal places.",
  retryAction: "Retry",
  cancel: "Cancel",
  save: "Submit product request",
  saving: "Submitting…",
  createSuccess:
    "The host adapter accepted the request; no response schema or product record is assumed.",
  createError: "The host adapter could not complete the product request.",
};

function PreviewApp() {
  const [page, setPage] = useState<PasVendorPage>(() => pageForPath(window.location.pathname));
  const [darkMode, setDarkMode] = useState(false);

  useEffect(() => {
    const syncRoute = () => setPage(pageForPath(window.location.pathname));
    window.addEventListener("popstate", syncRoute);
    return () => window.removeEventListener("popstate", syncRoute);
  }, []);

  const navigate = (next: PasVendorPage) => {
    const path =
      next === "dashboard"
        ? dashboardPath
        : next === "products"
          ? productsPath
          : next === "orders"
            ? ordersPath
            : next === "plans"
              ? plansPath
              : next === "credit"
                ? creditPath
                : next === "payouts"
                  ? payoutsPath
                  : teamPath;
    window.history.pushState({}, "", path);
    setPage(next);
  };

  const dashboardAdapter = useMemo<PasVendorDashboardAdapter>(
    () => ({
      async loadDashboard() {
        return { state: "unavailable" };
      },
    }),
    [],
  );
  const catalogAdapter = useMemo<PasVendorCatalogAdapter>(
    () => ({
      async loadCatalog() {
        return {
          state: "ready",
          catalog: {
            products: [
              {
                id: "synthetic-preview-product-01",
                title: "Synthetic preview product 01",
                categoryLabel: "Preview example",
              },
            ],
            createModeOptions: [],
          },
        };
      },
      async createProduct() {
        throw new Error("No backend is connected to the non-production preview.");
      },
    }),
    [],
  );
  const ordersAdapter = useMemo<PasVendorOrdersAdapter>(
    () => ({
      async loadOrders() {
        return {
          state: "ready",
          orders: [
            {
              id: "synthetic-order-01",
              orderReference: "SYN-ORD-2041",
              buyerLabel: "Synthetic buyer 01",
              itemLabel: "Synthetic preview product A",
              planTypeLabel: "Price-lock",
              statusLabel: "Awaiting delivery code",
              statusTone: "warning",
              canConfirmDelivery: true,
              details: [
                { label: "Buyer identity", value: "Synthetic preview data only" },
                { label: "Product", value: "Synthetic preview product A" },
                { label: "Order value", value: "Not supplied" },
                { label: "Delivery location", value: "Not supplied" },
              ],
            },
            {
              id: "synthetic-order-02",
              orderReference: "SYN-ORD-2042",
              buyerLabel: "Synthetic buyer 02",
              itemLabel: "Synthetic preview product B",
              planTypeLabel: "Not supplied",
              statusLabel: "In transit",
              statusTone: "neutral",
              details: [
                { label: "Buyer identity", value: "Synthetic preview data only" },
                { label: "Product", value: "Synthetic preview product B" },
                { label: "Order value", value: "Not supplied" },
                { label: "Delivery location", value: "Not supplied" },
              ],
            },
            {
              id: "synthetic-order-03",
              orderReference: "SYN-ORD-2043",
              buyerLabel: "Synthetic buyer 03",
              itemLabel: "Synthetic preview product C",
              planTypeLabel: "Price-lock",
              statusLabel: "Delivered",
              statusTone: "success",
              details: [
                { label: "Buyer identity", value: "Synthetic preview data only" },
                { label: "Product", value: "Synthetic preview product C" },
                { label: "Order value", value: "Not supplied" },
                { label: "Delivery location", value: "Not supplied" },
              ],
            },
          ],
        };
      },
      async confirmDelivered() {
        throw new Error("Delivery confirmation is not connected in the non-production preview.");
      },
    }),
    [],
  );
  const plansAdapter = useMemo<PasVendorPlansAdapter>(
    () => ({
      async loadPlans() {
        return {
          state: "ready",
          plans: [
            {
              id: "synthetic-plan-01",
              planReference: "SYN-PLAN-001",
              customerLabel: "Synthetic buyer 01",
              identityLabel: "Synthetic preview identity",
              verificationLabel: "Not supplied",
              productLabel: "Synthetic preview product A",
              planTypeLabel: "Price-lock",
              statusLabel: "In progress · preview",
              statusTone: "warning",
              targetAmountLabel: "Not supplied",
              savedAmountLabel: "Not supplied",
              progressPercent: 64,
              progressLabel: "Synthetic preview · 64%",
              nextDueLabel: "Not supplied",
              repaymentHistoryLabel: "Not supplied",
              detailRows: [{ label: "Record type", value: "Synthetic preview only" }],
            },
            {
              id: "synthetic-plan-02",
              planReference: "SYN-PLAN-002",
              customerLabel: "Synthetic buyer 02",
              identityLabel: "Synthetic preview identity",
              verificationLabel: "Not supplied",
              productLabel: "Synthetic preview product B",
              planTypeLabel: "Price-lock",
              statusLabel: "Status not supplied",
              statusTone: "neutral",
              targetAmountLabel: "Not supplied",
              savedAmountLabel: "Not supplied",
              progressLabel: "Not supplied",
              nextDueLabel: "Not supplied",
              repaymentHistoryLabel: "Not supplied",
              detailRows: [{ label: "Record type", value: "Synthetic preview only" }],
            },
          ],
        };
      },
    }),
    [],
  );
  const creditAdapter = useMemo<PasVendorCreditAdapter>(
    () => ({
      async loadOffers() {
        return { state: "unavailable" };
      },
    }),
    [],
  );
  const payoutsAdapter = useMemo<PasVendorPayoutAdapter>(
    () => ({
      async loadPayouts() {
        return { state: "unavailable" };
      },
    }),
    [],
  );
  const teamAdapter = useMemo<PasVendorTeamAdapter>(
    () => ({
      async loadTeam() {
        return { state: "unavailable" };
      },
    }),
    [],
  );

  return (
    <PasVendorWorkspaceShell
      activePage={page}
      copy={shellCopy}
      darkMode={darkMode}
      onNavigate={navigate}
      onToggleTheme={() => setDarkMode((current) => !current)}
      previewNotice="NON-PRODUCTION PREVIEW · Synthetic catalogue, order, and plan examples only. No live API, authentication, delivery, credit, payout, or product operation is connected."
      vendorName="Synthetic preview vendor"
    >
      {page === "dashboard" ? (
        <PasVendorDashboardPage
          adapter={dashboardAdapter}
          copy={dashboardCopy}
          onOpenProducts={() => navigate("products")}
          tenantId={tenantId}
        />
      ) : page === "products" ? (
        <PasVendorProductsPage adapter={catalogAdapter} copy={productsCopy} tenantId={tenantId} />
      ) : page === "orders" ? (
        <PasVendorOrdersPage adapter={ordersAdapter} copy={vendorOrdersCopy} tenantId={tenantId} />
      ) : page === "plans" ? (
        <PasVendorPlansPage adapter={plansAdapter} copy={vendorPlansCopy} tenantId={tenantId} />
      ) : page === "credit" ? (
        <PasVendorCreditOffersPage
          adapter={creditAdapter}
          copy={financeCopy.credit}
          tenantId={tenantId}
        />
      ) : page === "payouts" ? (
        <PasVendorPayoutsPage
          adapter={payoutsAdapter}
          copy={financeCopy.payouts}
          tenantId={tenantId}
        />
      ) : (
        <PasVendorTeamVerificationPage adapter={teamAdapter} copy={teamCopy} tenantId={tenantId} />
      )}
    </PasVendorWorkspaceShell>
  );
}

createRoot(document.getElementById("root")!).render(<PreviewApp />);
