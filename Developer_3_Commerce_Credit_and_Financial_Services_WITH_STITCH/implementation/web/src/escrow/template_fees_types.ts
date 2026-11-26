/** Presentation contracts for host-mapped Escrow configuration; not API DTOs. */

export type EscrowTemplateSectionId = "checkpoints" | "timers" | "documents" | "fees";
export type EscrowTemplateSettingKind = "text" | "number" | "toggle";

export interface EscrowTemplateSetting {
  readonly id: string;
  readonly label: string;
  /** Host-formatted display/input value. Financial values are never calculated here. */
  readonly value: string | boolean | null;
  readonly kind: EscrowTemplateSettingKind;
  readonly helperText?: string;
  /** Host-supplied requirements; this feature does not infer validation rules. */
  readonly required?: boolean;
  readonly editable: boolean;
}

export interface EscrowTemplateSection {
  readonly id: EscrowTemplateSectionId;
  readonly title: string;
  readonly description?: string;
  readonly settings: readonly EscrowTemplateSetting[];
}

export interface EscrowTemplateConfiguration {
  /** Must be the UUID used as the documented `{type}` path parameter. */
  readonly id: string;
  readonly name: string;
  readonly statusLabel?: string;
  readonly statusTone?: "success" | "warning" | "error" | "neutral";
  readonly sections: readonly EscrowTemplateSection[];
  readonly canPropose: boolean;
  readonly restrictionMessage?: string;
  /** Host-supplied dual-control state; no approval operation is defined here. */
  readonly approvalStatusLabel?: string;
  readonly approvalStatusTone?: "success" | "warning" | "error" | "neutral";
}

export type EscrowTemplatesFeesLoadResult =
  | { readonly state: "ready"; readonly templates: readonly EscrowTemplateConfiguration[] }
  | { readonly state: "empty" }
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" };

export type EscrowTemplateProposalResult =
  | { readonly state: "pending_approval"; readonly statusLabel?: string }
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" };

export interface EscrowTemplatesFeesAdapter {
  /** Host supplies/maps the configuration; no documented GET endpoint exists. */
  loadConfigurations(input: { readonly tenantId: string }): Promise<EscrowTemplatesFeesLoadResult>;
  /** Host maps setting IDs/values into the documented opaque `config` object. */
  proposeConfiguration(input: {
    readonly tenantId: string;
    readonly templateId: string;
    readonly changes: readonly {
      readonly settingId: string;
      readonly value: string | boolean | null;
    }[];
  }): Promise<EscrowTemplateProposalResult>;
}

export interface EscrowTemplatesFeesCopy {
  readonly eyebrow: string;
  readonly title: string;
  readonly subtitle: string;
  readonly loading: string;
  readonly retry: string;
  readonly errorTitle: string;
  readonly errorBody: string;
  readonly unavailableTitle: string;
  readonly unavailableBody: string;
  readonly restrictedTitle: string;
  readonly restrictedBody: string;
  readonly emptyTitle: string;
  readonly emptyBody: string;
  readonly templateLabel: string;
  readonly templatePlaceholder: string;
  readonly templateSection: string;
  readonly checkpointSection: string;
  readonly checkpointHelp: string;
  readonly timerSection: string;
  readonly timerHelp: string;
  readonly documentSection: string;
  readonly documentHelp: string;
  readonly feesSection: string;
  readonly feesHelp: string;
  readonly unavailableValue: string;
  readonly approval: string;
  readonly approvalPending: string;
  readonly dualControlHelp: string;
  readonly restrictedAction: string;
  readonly submit: string;
  readonly submitting: string;
  readonly reviewTitle: string;
  readonly reviewBody: string;
  readonly cancel: string;
  readonly confirmSubmit: string;
  readonly pendingTitle: string;
  readonly pendingBody: string;
  readonly submitErrorTitle: string;
  readonly submitErrorBody: string;
  readonly requiredField: (label: string) => string;
}
