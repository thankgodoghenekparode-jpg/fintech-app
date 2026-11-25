import type { PropsWithChildren, ReactNode } from "react";
import type { CommonCopy } from "../shared/copy";
import { Icon } from "./ui";

export type MerchantWebScreen =
  "dashboard" | "invoices" | "paymentLinks" | "reports" | "teamVerification";

interface MerchantWorkspaceShellProps extends PropsWithChildren {
  readonly copy: CommonCopy;
  readonly activeScreen: MerchantWebScreen;
  readonly businessName: string;
  readonly darkMode: boolean;
  readonly onNavigate?: (screen: MerchantWebScreen) => void;
  readonly onToggleTheme: () => void;
  readonly notice?: ReactNode;
}

export function MerchantWorkspaceShell({
  copy,
  activeScreen,
  businessName,
  darkMode,
  onNavigate,
  onToggleTheme,
  notice,
  children,
}: MerchantWorkspaceShellProps) {
  return (
    <div className="merchant-workspace" data-theme={darkMode ? "dark" : "light"}>
      <aside className="workspace-sidebar" aria-label={copy.workspaceLabel}>
        <div className="workspace-brand">
          <span className="brand-mark" aria-hidden="true">
            {copy.brand.trim().slice(0, 1).toUpperCase() || "M"}
          </span>
          <span>
            <strong>{copy.brand}</strong>
            <small>{copy.workspaceLabel}</small>
          </span>
        </div>

        <div className="tenant-card">
          <span className="tenant-avatar" aria-hidden="true">
            {businessName.trim().slice(0, 1).toUpperCase() || "B"}
          </span>
          <span className="tenant-name">{businessName}</span>
          <span className="tenant-caption">{copy.workspaceLabel}</span>
        </div>

        <nav className="workspace-nav" aria-label={copy.workspaceLabel}>
          <button
            aria-current={activeScreen === "dashboard" ? "page" : undefined}
            className={activeScreen === "dashboard" ? "nav-item is-active" : "nav-item"}
            disabled={!onNavigate || activeScreen === "dashboard"}
            onClick={() => onNavigate?.("dashboard")}
            type="button"
          >
            <Icon name="dashboard" />
            <span>{copy.dashboardNav}</span>
          </button>
          <button
            aria-current={activeScreen === "invoices" ? "page" : undefined}
            className={activeScreen === "invoices" ? "nav-item is-active" : "nav-item"}
            disabled={!onNavigate || activeScreen === "invoices"}
            onClick={() => onNavigate?.("invoices")}
            type="button"
          >
            <Icon name="invoice" />
            <span>{copy.invoicesNav}</span>
          </button>
          <button
            aria-current={activeScreen === "paymentLinks" ? "page" : undefined}
            className={activeScreen === "paymentLinks" ? "nav-item is-active" : "nav-item"}
            disabled={!onNavigate || activeScreen === "paymentLinks"}
            onClick={() => onNavigate?.("paymentLinks")}
            type="button"
          >
            <Icon name="link" />
            <span>{copy.paymentLinksNav}</span>
          </button>
          <button
            aria-current={activeScreen === "reports" ? "page" : undefined}
            className={activeScreen === "reports" ? "nav-item is-active" : "nav-item"}
            disabled={!onNavigate || activeScreen === "reports"}
            onClick={() => onNavigate?.("reports")}
            type="button"
          >
            <Icon name="reports" />
            <span>{copy.reportsNav}</span>
          </button>
          <button
            aria-current={activeScreen === "teamVerification" ? "page" : undefined}
            className={activeScreen === "teamVerification" ? "nav-item is-active" : "nav-item"}
            disabled={!onNavigate || activeScreen === "teamVerification"}
            onClick={() => onNavigate?.("teamVerification")}
            type="button"
          >
            <Icon name="team" />
            <span>{copy.teamNav}</span>
          </button>
        </nav>

        <div className="sidebar-footer">{copy.previewLabel}</div>
      </aside>

      <div className="workspace-main">
        <header className="workspace-topbar">
          <span className="workspace-context">{copy.workspaceLabel}</span>
          <div className="topbar-actions">
            <button
              aria-label={darkMode ? "Switch to light theme" : "Switch to dark theme"}
              className="icon-button"
              onClick={onToggleTheme}
              type="button"
            >
              <Icon name={darkMode ? "sun" : "moon"} />
            </button>
            <span className="profile-chip" aria-label={businessName}>
              {businessName.trim().slice(0, 1).toUpperCase() || "B"}
            </span>
          </div>
        </header>

        <div className="workspace-content">
          {notice ? <div className="preview-notice">{notice}</div> : null}
          {children}
        </div>
      </div>
    </div>
  );
}
