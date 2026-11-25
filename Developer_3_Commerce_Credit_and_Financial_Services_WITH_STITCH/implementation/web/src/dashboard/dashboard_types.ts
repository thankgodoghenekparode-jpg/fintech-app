export interface DashboardMetricSet {
  readonly salesKobo: number;
  readonly feesKobo: number;
  readonly refundsKobo: number;
  readonly outstandingInvoicesKobo: number;
}

/** Host-facing presentation point; not a GET /business/home response DTO. */
export interface DashboardSalesPoint {
  readonly label: string;
  readonly amountKobo: number;
}

/** Host-facing activity presentation row; not an API response DTO. */
export interface DashboardActivityRow {
  readonly id: string;
  readonly title: string;
  readonly amountKobo: number;
  readonly statusLabel: string;
  readonly statusTone: "success" | "warning" | "error" | "neutral";
  readonly timeLabel: string;
}

export interface DashboardSnapshot {
  readonly metrics: DashboardMetricSet;
  readonly salesSeries: readonly DashboardSalesPoint[];
  readonly recentActivity: readonly DashboardActivityRow[];
}

export type DashboardResult =
  | { readonly state: "restricted" }
  | { readonly state: "empty" }
  | { readonly state: "ready"; readonly snapshot: DashboardSnapshot };

export interface BusinessDashboardAdapter {
  loadDashboard(input: { readonly tenantId: string }): Promise<DashboardResult>;
}
