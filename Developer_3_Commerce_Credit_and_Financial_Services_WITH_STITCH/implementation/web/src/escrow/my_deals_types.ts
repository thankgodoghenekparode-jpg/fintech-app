/** Host-mapped presentation models; these are not Escrow API DTOs. */
export type EscrowBusinessTone = "success" | "warning" | "error" | "neutral";

export interface EscrowBusinessDeal {
  readonly id: string;
  readonly referenceLabel: string;
  readonly title: string;
  readonly counterpartyLabel?: string;
  readonly typeLabel?: string;
  readonly roleLabel?: string;
  /** Already formatted by the host, including currency and tabular formatting. */
  readonly amountLabel?: string;
  readonly statusLabel: string;
  readonly statusTone?: EscrowBusinessTone;
  readonly updatedLabel?: string;
}

export interface EscrowBusinessDealDetail {
  readonly title: string;
  readonly referenceLabel: string;
  readonly statusLabel: string;
  readonly statusTone?: EscrowBusinessTone;
  readonly rows: readonly { readonly label: string; readonly value: string }[];
  /** Host-provided next action. The UI does not derive permissions from it. */
  readonly nextActionLabel?: string;
}

export type EscrowBusinessDealsResult =
  | { readonly state: "ready"; readonly deals: readonly EscrowBusinessDeal[] }
  | { readonly state: "empty" }
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" };

export type EscrowBusinessDealDetailResult =
  | { readonly state: "ready"; readonly detail: EscrowBusinessDealDetail }
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" };

/**
 * Host owns authentication, tenant scoping, GET /escrow/deals mapping,
 * GET /escrow/deals/{dealId} mapping, and the unspecified export operation.
 */
export interface EscrowBusinessDealsAdapter {
  loadDeals(input: { readonly tenantId: string }): Promise<EscrowBusinessDealsResult>;
  loadDealDetail(input: {
    readonly tenantId: string;
    readonly dealId: string;
  }): Promise<EscrowBusinessDealDetailResult>;
  /** No export endpoint/schema is documented; the host may supply this action. */
  exportDeals?(input: {
    readonly tenantId: string;
    readonly deals: readonly EscrowBusinessDeal[];
  }): Promise<void>;
}

export interface EscrowBusinessDealsCopy {
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
  readonly searchLabel: string;
  readonly searchPlaceholder: string;
  readonly statusFilterLabel: string;
  readonly allStatuses: string;
  readonly exportLabel: string;
  readonly exportUnavailable: string;
  readonly exportError: string;
  readonly exportSuccess: string;
  readonly countLabel: (filtered: number, total: number) => string;
  readonly dealColumn: string;
  readonly counterpartyColumn: string;
  readonly typeColumn: string;
  readonly amountColumn: string;
  readonly roleColumn: string;
  readonly statusColumn: string;
  readonly updatedColumn: string;
  readonly actionsColumn: string;
  readonly openDetails: string;
  readonly noResultsTitle: string;
  readonly noResultsBody: string;
  readonly drawerTitle: string;
  readonly drawerLoading: string;
  readonly drawerUnavailable: string;
  readonly drawerRestricted: string;
  readonly nextAction: string;
  readonly notSupplied: string;
  readonly close: string;
}
