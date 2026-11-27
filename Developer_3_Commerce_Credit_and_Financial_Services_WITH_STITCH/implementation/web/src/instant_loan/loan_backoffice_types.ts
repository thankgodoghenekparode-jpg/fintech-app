/** Host-facing UI models; these are not API response DTOs. */
export interface LoanApplicationRow {
  readonly id: string;
  readonly reference: string;
  readonly maskedCustomer: string;
  readonly maskedCustomerReference: string;
  readonly scoreLabel: string;
  readonly reasons: readonly string[];
  readonly exposureLabel: string;
  readonly slaLabel?: string;
}

export interface LoanApplicationDetail extends LoanApplicationRow {
  readonly maskedCustomerView: readonly { readonly label: string; readonly value: string }[];
}

export type LoanApplicationsResult =
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" }
  | { readonly state: "empty" }
  | { readonly state: "ready"; readonly applications: readonly LoanApplicationDetail[] };

export type LoanDecision = "APPROVE" | "DECLINE";

export interface LoanApplicationsAdapter {
  loadApplications(input: { readonly tenantId: string }): Promise<LoanApplicationsResult>;
  decideApplication(input: {
    readonly applicationId: string;
    readonly decision: LoanDecision;
    readonly reason: string;
    readonly pinToken: string;
    readonly idempotencyKey: string;
    readonly tenantId: string;
  }): Promise<void>;
}

export interface LoanArrearsRow {
  readonly id: string;
  readonly maskedCustomer: string;
  readonly loanReference: string;
  readonly daysPastDueLabel: string;
  readonly amountDueLabel: string;
  readonly contactHistory: readonly string[];
  readonly approvedScripts: readonly string[];
  readonly contactRestrictionLabel?: string;
}

export interface LoanHardshipCase {
  readonly id: string;
  readonly maskedCustomer: string;
  readonly caseStatusLabel: string;
  readonly summary: string;
}

export interface LoanPortfolioSnapshot {
  /** Host-mapped display values; no financial calculations are performed by this feature. */
  readonly outstandingLabel?: string;
  readonly parBuckets: readonly { readonly label: string; readonly value: string }[];
  readonly repaymentRateLabel?: string;
  readonly arrears: readonly LoanArrearsRow[];
  readonly hardshipCases: readonly LoanHardshipCase[];
}

export type LoanPortfolioResult =
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" }
  | { readonly state: "empty" }
  | { readonly state: "ready"; readonly snapshot: LoanPortfolioSnapshot };

export interface LoanPortfolioAdapter {
  loadPortfolio(input: { readonly tenantId: string }): Promise<LoanPortfolioResult>;
}
