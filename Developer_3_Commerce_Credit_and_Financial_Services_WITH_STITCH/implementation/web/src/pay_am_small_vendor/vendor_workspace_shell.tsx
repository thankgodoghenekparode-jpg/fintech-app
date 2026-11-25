import type { PropsWithChildren } from "react";
import { Icon } from "../components/ui";
import "./pay_am_small_vendor.css";
import type { PasVendorShellCopy } from "./vendor_copy";

export type PasVendorPage =
  "dashboard" | "products" | "orders" | "plans" | "credit" | "payouts" | "team";

interface PasVendorWorkspaceShellProps extends PropsWithChildren {
  readonly copy: PasVendorShellCopy;
  readonly activePage: PasVendorPage;
  readonly vendorName: string;
  readonly darkMode: boolean;
  readonly onNavigate: (page: PasVendorPage) => void;
  readonly onToggleTheme: () => void;
  readonly previewNotice: string;
}

export function PasVendorWorkspaceShell({
  activePage,
  children,
  copy,
  darkMode,
  onNavigate,
  onToggleTheme,
  previewNotice,
  vendorName,
}: PasVendorWorkspaceShellProps) {
  return (
    <div
      className="merchant-workspace pas-vendor-workspace"
      data-theme={darkMode ? "dark" : "light"}
    >
      <aside aria-label={copy.workspaceLabel} className="workspace-sidebar">
        <div className="workspace-brand">
          <span aria-hidden="true" className="brand-mark">
            Y
          </span>
          <span>
            <strong>{copy.brand}</strong>
            <small>{copy.workspaceLabel}</small>
          </span>
        </div>
        <div className="tenant-card">
          <span aria-hidden="true" className="tenant-avatar">
            {vendorName.trim().slice(0, 1).toUpperCase() || "V"}
          </span>
          <span className="tenant-name">{vendorName}</span>
          <span className="tenant-caption">{copy.workspaceLabel}</span>
        </div>
        <nav aria-label={copy.workspaceLabel} className="workspace-nav">
          <button
            aria-current={activePage === "dashboard" ? "page" : undefined}
            className={activePage === "dashboard" ? "nav-item is-active" : "nav-item"}
            disabled={activePage === "dashboard"}
            onClick={() => onNavigate("dashboard")}
            type="button"
          >
            <Icon name="dashboard" />
            <span>{copy.dashboardNav}</span>
          </button>
          <button
            aria-current={activePage === "products" ? "page" : undefined}
            className={activePage === "products" ? "nav-item is-active" : "nav-item"}
            disabled={activePage === "products"}
            onClick={() => onNavigate("products")}
            type="button"
          >
            <Icon name="invoice" />
            <span>{copy.productsNav}</span>
          </button>
          <button
            aria-current={activePage === "orders" ? "page" : undefined}
            className={activePage === "orders" ? "nav-item is-active" : "nav-item"}
            disabled={activePage === "orders"}
            onClick={() => onNavigate("orders")}
            type="button"
          >
            <Icon name="send" />
            <span>{copy.ordersNav}</span>
          </button>
          <button
            aria-current={activePage === "plans" ? "page" : undefined}
            className={activePage === "plans" ? "nav-item is-active" : "nav-item"}
            disabled={activePage === "plans"}
            onClick={() => onNavigate("plans")}
            type="button"
          >
            <Icon name="reports" />
            <span>{copy.plansNav}</span>
          </button>
          <button
            aria-current={activePage === "credit" ? "page" : undefined}
            className={activePage === "credit" ? "nav-item is-active" : "nav-item"}
            disabled={activePage === "credit"}
            onClick={() => onNavigate("credit")}
            type="button"
          >
            <Icon name="shield" />
            <span>{copy.creditNav}</span>
          </button>
          <button
            aria-current={activePage === "payouts" ? "page" : undefined}
            className={activePage === "payouts" ? "nav-item is-active" : "nav-item"}
            disabled={activePage === "payouts"}
            onClick={() => onNavigate("payouts")}
            type="button"
          >
            <Icon name="fees" />
            <span>{copy.payoutsNav}</span>
          </button>
          <button
            aria-current={activePage === "team" ? "page" : undefined}
            className={activePage === "team" ? "nav-item is-active" : "nav-item"}
            disabled={activePage === "team"}
            onClick={() => onNavigate("team")}
            type="button"
          >
            <Icon name="team" />
            <span>{copy.teamNav}</span>
          </button>
        </nav>
        <div className="sidebar-footer">
          <span>{copy.settingsNav}</span>
          <span>{copy.helpNav}</span>
          <span>{copy.signOutNav}</span>
          <small>{copy.previewLabel}</small>
        </div>
      </aside>
      <div className="workspace-main">
        <header className="workspace-topbar">
          <span className="workspace-context">{copy.workspaceLabel}</span>
          <div className="topbar-actions">
            <button
              aria-label={darkMode ? copy.switchThemeLight : copy.switchThemeDark}
              className="icon-button"
              onClick={onToggleTheme}
              type="button"
            >
              <Icon name={darkMode ? "sun" : "moon"} />
            </button>
            <span aria-label={vendorName} className="profile-chip">
              {vendorName.trim().slice(0, 1).toUpperCase() || "V"}
            </span>
          </div>
        </header>
        <div className="workspace-content">
          <div className="preview-notice pas-vendor-preview-notice" role="note">
            <Icon name="info" />
            <span>{previewNotice}</span>
          </div>
          {children}
        </div>
      </div>
    </div>
  );
}
