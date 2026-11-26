import { useEffect, useMemo, useState } from "react";
import { createRoot } from "react-dom/client";
import { Icon } from "../src/components/ui";
import { EscrowBusinessDealsPage } from "../src/escrow/my_deals_page";
import "./escrow_preview.css";
import type {
  EscrowBusinessDeal,
  EscrowBusinessDealsAdapter,
  EscrowBusinessDealsCopy,
} from "../src/escrow/my_deals_types";

const tenantId = "synthetic-escrow-business";

const copy: EscrowBusinessDealsCopy = {
  eyebrow: "ESCROW · BUSINESS",
  title: "My deals",
  subtitle: "Review and manage the Escrow deals available to your business.",
  loading: "Loading Escrow deals",
  retry: "Try again",
  errorTitle: "Deals could not be loaded",
  errorBody: "The host could not provide your deal list. Try again.",
  unavailableTitle: "Deal listing unavailable",
  unavailableBody: "Your host has not connected the Escrow deal list for this preview.",
  restrictedTitle: "Deal access restricted",
  restrictedBody: "Your host has restricted access to these deals.",
  emptyTitle: "No deals supplied",
  emptyBody: "Deals supplied by your host will appear here.",
  searchLabel: "Search deals",
  searchPlaceholder: "Deal, reference, counterparty or type",
  statusFilterLabel: "Status",
  allStatuses: "All statuses",
  exportLabel: "Export",
  exportUnavailable: "Export requires a host-provided export operation in production.",
  exportError: "The preview export could not be prepared.",
  exportSuccess: "Synthetic preview rows exported locally. No production records were accessed.",
  countLabel: (filtered, total) => `Showing ${filtered} of ${total} synthetic preview records`,
  dealColumn: "Deal",
  counterpartyColumn: "Counterparty",
  typeColumn: "Type",
  amountColumn: "Amount",
  roleColumn: "Your role",
  statusColumn: "Status",
  updatedColumn: "Updated",
  actionsColumn: "Actions",
  openDetails: "Open details",
  noResultsTitle: "No matching deals",
  noResultsBody: "Change your search or status filter.",
  drawerTitle: "Deal details",
  drawerLoading: "Loading deal details",
  drawerUnavailable: "Deal details unavailable",
  drawerRestricted: "Deal details restricted",
  nextAction: "Next action",
  notSupplied: "Not supplied by host",
  close: "Close deal details",
};

const deals: readonly EscrowBusinessDeal[] = [
  {
    id: "synthetic-deal-001",
    referenceLabel: "SYNTHETIC-ESC-001",
    title: "Synthetic goods deal example 01",
    counterpartyLabel: "Synthetic preview participant A",
    typeLabel: "Goods · preview sample",
    roleLabel: "Seller · preview sample",
    amountLabel: "Not supplied",
    statusLabel: "Active · preview sample",
    statusTone: "neutral",
    updatedLabel: "Not supplied",
  },
  {
    id: "synthetic-deal-002",
    referenceLabel: "SYNTHETIC-ESC-002",
    title: "Synthetic service deal example 02",
    counterpartyLabel: "Synthetic preview participant B",
    typeLabel: "Service · preview sample",
    roleLabel: "Buyer · preview sample",
    amountLabel: "Not supplied",
    statusLabel: "Waiting · preview sample",
    statusTone: "neutral",
    updatedLabel: "Not supplied",
  },
  {
    id: "synthetic-deal-003",
    referenceLabel: "SYNTHETIC-ESC-003",
    title: "Synthetic vehicle deal example 03",
    counterpartyLabel: "Synthetic preview participant C",
    typeLabel: "Vehicle · preview sample",
    roleLabel: "Seller · preview sample",
    amountLabel: "Not supplied",
    statusLabel: "Completed · preview sample",
    statusTone: "neutral",
    updatedLabel: "Not supplied",
  },
];

const adapter: EscrowBusinessDealsAdapter = {
  async loadDeals() {
    return { state: "ready", deals };
  },
  async loadDealDetail({ dealId }) {
    const deal = deals.find((candidate) => candidate.id === dealId);
    if (!deal) return { state: "unavailable" };
    return {
      state: "ready",
      detail: {
        title: deal.title,
        referenceLabel: deal.referenceLabel,
        statusLabel: deal.statusLabel,
        statusTone: "neutral",
        rows: [
          { label: "Counterparty", value: deal.counterpartyLabel ?? "Not supplied" },
          { label: "Deal type", value: deal.typeLabel ?? "Not supplied" },
          { label: "Your role", value: deal.roleLabel ?? "Not supplied" },
          { label: "Amount", value: "Not supplied by host" },
          { label: "Updated", value: "Not supplied by host" },
          { label: "Preview data", value: "Synthetic example only · not a customer deal" },
        ],
        nextActionLabel: "Not supplied by host; no deal action is enabled in this preview.",
      },
    };
  },
  async exportDeals({ deals: rows }) {
    const fields = ["Reference", "Deal", "Counterparty", "Type", "Role", "Amount", "Status"];
    const csv = [
      fields,
      ...rows.map((deal) => [
        deal.referenceLabel,
        deal.title,
        deal.counterpartyLabel ?? "Not supplied",
        deal.typeLabel ?? "Not supplied",
        deal.roleLabel ?? "Not supplied",
        deal.amountLabel ?? "Not supplied",
        deal.statusLabel,
      ]),
    ]
      .map((row) => row.map((value) => `"${value.replaceAll('"', '""')}"`).join(","))
      .join("\r\n");
    const url = URL.createObjectURL(new Blob([csv], { type: "text/csv;charset=utf-8" }));
    const link = document.createElement("a");
    link.href = url;
    link.download = "escrow-synthetic-preview-deals.csv";
    link.click();
    URL.revokeObjectURL(url);
  },
};

function EscrowDealsPreview() {
  const [dark, setDark] = useState(false);

  useEffect(() => {
    document.title = "Escrow My Deals Preview · Non-production";
  }, []);

  const currentAdapter = useMemo(() => adapter, []);

  return (
    <div className="merchant-workspace escrow-preview-shell" data-theme={dark ? "dark" : "light"}>
      <aside aria-label="Escrow workspace navigation" className="workspace-sidebar">
        <div className="workspace-brand">
          <span aria-hidden="true" className="brand-mark">
            Y
          </span>
          <span>
            <strong>YourApp</strong>
            <small>Escrow business</small>
          </span>
        </div>
        <div className="tenant-card">
          <span aria-hidden="true" className="tenant-avatar">
            S
          </span>
          <span className="tenant-name">Synthetic business</span>
          <span className="tenant-caption">Preview workspace</span>
        </div>
        <nav aria-label="Escrow screens" className="workspace-nav">
          <a aria-current="page" className="nav-item is-active" href="/escrow/web/deals">
            <Icon name="invoice" />
            <span>My deals</span>
          </a>
          <a className="nav-item" href="/backoffice/escrow/disputes">
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
          <span className="workspace-context">Escrow business</span>
          <div className="topbar-actions">
            <button
              aria-label={dark ? "Switch to light theme" : "Switch to dark theme"}
              className="icon-button"
              onClick={() => setDark((value) => !value)}
              type="button"
            >
              <Icon name={dark ? "sun" : "moon"} />
            </button>
            <span aria-label="Synthetic preview business" className="profile-chip">
              S
            </span>
          </div>
        </header>
        <section className="workspace-content">
          <div className="preview-notice preview-banner-content escrow-preview-notice" role="note">
            <p>
              <strong>NON-PRODUCTION PREVIEW</strong> · Synthetic rows only. No API, authentication,
              transaction or production export is connected.
            </p>
          </div>
          <EscrowBusinessDealsPage adapter={currentAdapter} copy={copy} tenantId={tenantId} />
        </section>
      </div>
    </div>
  );
}

export function renderEscrowPreview(element: HTMLElement) {
  createRoot(element).render(<EscrowDealsPreview />);
}
