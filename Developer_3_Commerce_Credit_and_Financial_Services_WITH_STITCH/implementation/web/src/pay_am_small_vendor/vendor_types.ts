/** Host presentation models, not API response DTOs. */
export interface PasVendorDashboardMetric {
  readonly label: string;
  readonly valueLabel: string;
  readonly supportingLabel?: string;
}

export interface PasVendorDashboardChartPoint {
  readonly periodLabel: string;
  readonly valueLabel: string;
  /** Host-normalized display fraction; the feature does not derive it. */
  readonly displayFraction: number;
}

export interface PasVendorDashboardAlert {
  readonly title: string;
  readonly detail: string;
  readonly tone: "warning" | "error" | "neutral";
}

export interface PasVendorDashboardSnapshot {
  readonly metrics: {
    readonly orders: PasVendorDashboardMetric;
    readonly activePlans: PasVendorDashboardMetric;
    readonly payouts: PasVendorDashboardMetric;
    readonly disputes: PasVendorDashboardMetric;
  };
  readonly salesTrend: readonly PasVendorDashboardChartPoint[];
  readonly planCompletion: readonly PasVendorDashboardChartPoint[];
  readonly alerts: readonly PasVendorDashboardAlert[];
}

export type PasVendorDashboardResult =
  | { readonly state: "ready"; readonly snapshot: PasVendorDashboardSnapshot }
  | { readonly state: "empty" }
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" };

export interface PasVendorDashboardAdapter {
  /** Host-mapped dashboard data. No dashboard endpoint is currently documented. */
  loadDashboard(input: { readonly tenantId: string }): Promise<PasVendorDashboardResult>;
}

export interface PasVendorModeOption {
  /** Exact host-approved string accepted for the API `modes` field. */
  readonly value: string;
  readonly label: string;
}

/** A host-mapped catalogue row. No product-list response schema is defined. */
export interface PasVendorProduct {
  readonly id: string;
  readonly title: string;
  readonly categoryLabel?: string;
  readonly skuLabel?: string;
  readonly priceKobo?: number;
  readonly stock?: number;
  readonly modeLabels?: readonly string[];
  readonly lockDaysMax?: number;
  readonly deliveryDays?: number;
  /** Null means the host has not supplied a confirmed lock state. */
  readonly priceChangeBlockedByActivePlans?: boolean;
}

export interface PasVendorCatalog {
  readonly products: readonly PasVendorProduct[];
  /** Host-approved values for the API's currently unconstrained `modes` array. */
  readonly createModeOptions: readonly PasVendorModeOption[];
}

export type PasVendorCatalogResult =
  | { readonly state: "ready"; readonly catalog: PasVendorCatalog }
  | { readonly state: "empty"; readonly createModeOptions: readonly PasVendorModeOption[] }
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" };

export interface PasVendorCreateProductRequest {
  readonly title: string;
  readonly priceKobo: number;
  readonly stock: number;
  readonly modes: readonly string[];
  readonly deliveryDays: number;
  readonly lockDaysMax?: number;
}

export interface PasVendorCatalogAdapter {
  /** Host-supplied catalogue seam; this feature invents no list endpoint. */
  loadCatalog(input: { readonly tenantId: string }): Promise<PasVendorCatalogResult>;

  /** Maps only the documented POST /pas/vendor/products body fields. */
  createProduct(input: {
    readonly tenantId: string;
    readonly request: PasVendorCreateProductRequest;
  }): Promise<void>;
}
