/** Host-normalized presentation models; GET /pas/vendor/plans has no response schema. */
export type PasVendorPlanTone = "success" | "warning" | "error" | "neutral";

export interface PasVendorPlan {
  readonly id: string;
  readonly planReference: string;
  readonly customerLabel: string;
  readonly identityLabel?: string;
  readonly verificationLabel?: string;
  readonly productLabel: string;
  readonly planTypeLabel: string;
  readonly statusLabel: string;
  readonly statusTone?: PasVendorPlanTone;
  readonly targetAmountLabel?: string;
  readonly savedAmountLabel?: string;
  /** Host-calculated/normalized only; the feature never computes plan progress. */
  readonly progressPercent?: number;
  readonly progressLabel?: string;
  readonly nextDueLabel?: string;
  readonly repaymentHistoryLabel?: string;
  readonly detailRows?: readonly { readonly label: string; readonly value: string }[];
}

export type PasVendorPlansResult =
  | { readonly state: "ready"; readonly plans: readonly PasVendorPlan[] }
  | { readonly state: "empty" }
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" };

export interface PasVendorPlansAdapter {
  /** Host-mapped GET /pas/vendor/plans data; no API DTO is inferred by this feature. */
  loadPlans(input: { readonly tenantId: string }): Promise<PasVendorPlansResult>;
}

export interface PasVendorPlansCopy {
  readonly eyebrow: string;
  readonly title: string;
  readonly subtitle: string;
  readonly loading: string;
  readonly retry: string;
  readonly errorTitle: string;
  readonly errorBody: string;
  readonly restrictedTitle: string;
  readonly restrictedBody: string;
  readonly unavailableTitle: string;
  readonly unavailableBody: string;
  readonly emptyTitle: string;
  readonly emptyBody: string;
  readonly searchLabel: string;
  readonly searchPlaceholder: string;
  readonly allPlans: string;
  readonly planType: string;
  readonly status: string;
  readonly tableHeading: string;
  readonly planReference: string;
  readonly customer: string;
  readonly product: string;
  readonly target: string;
  readonly saved: string;
  readonly progress: string;
  readonly noResultsTitle: string;
  readonly noResultsBody: string;
  readonly detailHeading: string;
  readonly syntheticLabel: string;
  readonly notSupplied: string;
  readonly identity: string;
  readonly verification: string;
  readonly repaymentHistory: string;
  readonly nextDue: string;
  readonly summaryActive: string;
  readonly summarySaved: string;
  readonly summaryCompletion: string;
  readonly summaryExpiring: string;
  readonly metricUnavailable: string;
  readonly noSelection: string;
}
