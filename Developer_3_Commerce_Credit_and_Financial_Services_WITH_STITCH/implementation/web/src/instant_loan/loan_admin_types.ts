/** Host-facing UI models. They do not describe the undocumented API response schemas. */
export interface LoanProductVersion {
  readonly id: string;
  readonly productLabel: string;
  readonly versionLabel: string;
  readonly statusLabel: string;
  readonly effectiveFromLabel?: string;
  readonly config: Readonly<Record<string, unknown>>;
}

export type LoanProductsResult =
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" }
  | { readonly state: "empty" }
  | {
      readonly state: "ready";
      readonly products: readonly LoanProductVersion[];
      readonly canPropose: boolean;
    };

export interface LoanProductsAdapter {
  loadProducts(input: { readonly tenantId: string }): Promise<LoanProductsResult>;
  proposeProductVersion(input: {
    readonly config: Readonly<Record<string, unknown>>;
    readonly effectiveFrom: string;
    readonly tenantId: string;
  }): Promise<void>;
}

export interface LoanSettlementSplit {
  readonly label: string;
  readonly valueLabel: string;
}

export interface LoanSettlementException {
  readonly id: string;
  readonly label: string;
  readonly detail?: string;
}

export interface LoanSettlementPeriod {
  readonly id: string;
  readonly periodLabel: string;
  readonly statementReference: string;
  readonly statusLabel: string;
  readonly totalLabel?: string;
  readonly splits: readonly LoanSettlementSplit[];
  readonly exceptions: readonly LoanSettlementException[];
  readonly canApprove: boolean;
}

export type LoanSettlementsResult =
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" }
  | { readonly state: "empty" }
  | { readonly state: "ready"; readonly periods: readonly LoanSettlementPeriod[] };

export interface LoanSettlementsAdapter {
  loadSettlements(input: { readonly tenantId: string }): Promise<LoanSettlementsResult>;
  approveSettlement(input: {
    readonly settlementId: string;
    readonly idempotencyKey: string;
    readonly pinToken: string;
    readonly tenantId: string;
  }): Promise<void>;
}
