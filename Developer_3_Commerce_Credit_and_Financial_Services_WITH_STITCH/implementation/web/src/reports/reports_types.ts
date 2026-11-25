export interface ReportsQuery {
  readonly tenantId: string;
  /** Opaque host-supplied type; the API's allowed report types are unspecified. */
  readonly reportType: string;
  readonly from?: string;
  readonly to?: string;
}

/** Host-facing summary values; not a GET /business/reports/{type} response DTO. */
export interface ReportsSummary {
  readonly salesKobo: number;
  readonly feesKobo: number;
  readonly refundsKobo: number;
  readonly taxKobo: number;
}

export type ReportsResult =
  | { readonly state: "restricted" }
  | { readonly state: "empty" }
  | { readonly state: "ready"; readonly summary: ReportsSummary };

export interface ReportsAdapter {
  loadReport(query: ReportsQuery): Promise<ReportsResult>;
  /** The host owns report format, response mapping, and any resulting file delivery. */
  exportReport(query: ReportsQuery): Promise<void>;
}
