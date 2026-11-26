import { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import { Icon } from "../src/components/ui";
import { EscrowTemplatesFeesPage } from "../src/escrow/template_fees_page";
import type {
  EscrowTemplateConfiguration,
  EscrowTemplatesFeesAdapter,
  EscrowTemplatesFeesCopy,
} from "../src/escrow/template_fees_types";
import "./escrow_preview.css";

const tenantId = "synthetic-escrow-backoffice-preview";
const template: EscrowTemplateConfiguration = {
  id: "00000000-0000-4000-8000-000000000004",
  name: "Synthetic configuration example · no production template",
  statusLabel: "Synthetic preview only",
  statusTone: "neutral",
  canPropose: false,
  restrictionMessage:
    "No authorized configuration values or product-admin permission are connected to this preview.",
  sections: [
    {
      id: "checkpoints",
      title: "Checkpoints",
      description: "Host-defined checkpoints for this template.",
      settings: [],
    },
    {
      id: "timers",
      title: "Timers and reminders",
      description: "Host-defined release timers and reminders.",
      settings: [],
    },
    {
      id: "documents",
      title: "Required documents",
      description: "Host-defined document requirements.",
      settings: [],
    },
    {
      id: "fees",
      title: "Fee schedule and minimum charge",
      description: "Values and rules must be supplied by the authorized host.",
      settings: [],
    },
  ],
};

const adapter: EscrowTemplatesFeesAdapter = {
  async loadConfigurations() {
    return { state: "ready", templates: [template] };
  },
  async proposeConfiguration() {
    return { state: "unavailable" };
  },
};

const copy: EscrowTemplatesFeesCopy = {
  eyebrow: "ESCROW · BACK OFFICE",
  title: "Templates and fees",
  subtitle: "Review template configuration and host-supplied fee settings.",
  loading: "Loading configuration",
  retry: "Try again",
  errorTitle: "Configuration could not be loaded",
  errorBody: "The host could not provide configuration data. Try again.",
  unavailableTitle: "Configuration unavailable",
  unavailableBody: "No configuration provider is connected to this preview.",
  restrictedTitle: "Configuration access restricted",
  restrictedBody: "The host has not supplied access to configuration data.",
  emptyTitle: "No templates supplied",
  emptyBody: "Templates supplied by the host will appear here.",
  templateLabel: "Template",
  templatePlaceholder: "Select a host-supplied template",
  templateSection: "Selected template",
  checkpointSection: "Checkpoints",
  checkpointHelp: "Define host-approved checkpoints.",
  timerSection: "Timers and reminders",
  timerHelp: "Review the configured timers supplied by the host.",
  documentSection: "Documents",
  documentHelp: "Review required documents supplied by the host.",
  feesSection: "Fee schedule and minimum charge",
  feesHelp: "Only host-supplied fee values and fields can be reviewed or proposed.",
  unavailableValue: "Not supplied by host · synthetic preview contains no configuration values.",
  approval: "Dual-control approval",
  approvalPending: "Pending approval",
  dualControlHelp: "Configuration proposals are subject to the documented dual-control workflow.",
  restrictedAction: "Submit for approval is unavailable in this non-production preview.",
  submit: "Submit for approval",
  submitting: "Submitting proposal…",
  reviewTitle: "Review configuration proposal",
  reviewBody:
    "Confirm the changes to send them to the host for approval. No values are submitted by this preview.",
  cancel: "Cancel",
  confirmSubmit: "Submit proposal",
  pendingTitle: "Proposal pending approval",
  pendingBody: "The host reported that this proposal is awaiting the required approval.",
  submitErrorTitle: "Proposal unavailable",
  submitErrorBody:
    "The host could not confirm the proposal state. Review the configuration and retry if appropriate.",
  requiredField: (label) => `${label} is required by the host configuration.`,
};

function EscrowTemplatesPreview() {
  const [dark, setDark] = useState(false);

  useEffect(() => {
    document.title = "Templates and Fees · Escrow · Non-production";
  }, []);

  return (
    <div className="merchant-workspace escrow-preview-shell" data-theme={dark ? "dark" : "light"}>
      <aside aria-label="Escrow workspace navigation" className="workspace-sidebar">
        <div className="workspace-brand">
          <span aria-hidden="true" className="brand-mark">
            S
          </span>
          <span>
            <strong>YourApp</strong>
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
          <a className="nav-item" href="/backoffice/escrow/disputes">
            <Icon name="warning" />
            <span>Dispute queue</span>
          </a>
          <a aria-current="page" className="nav-item is-active" href="/backoffice/escrow/config">
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
              <strong>NON-PRODUCTION PREVIEW</strong> · Synthetic layout fixture only. No real
              templates, fees, configuration changes or approvals are connected.
            </p>
          </div>
          <EscrowTemplatesFeesPage adapter={adapter} copy={copy} tenantId={tenantId} />
        </section>
      </div>
    </div>
  );
}

export function renderEscrowTemplatesPreview(element: HTMLElement) {
  createRoot(element).render(<EscrowTemplatesPreview />);
}
