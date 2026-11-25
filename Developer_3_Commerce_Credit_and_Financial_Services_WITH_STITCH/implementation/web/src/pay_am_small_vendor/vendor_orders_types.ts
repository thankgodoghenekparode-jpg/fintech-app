/** Host-normalized presentation models; the order list response is not specified by the API. */
export type PasVendorOrderTone = "success" | "warning" | "error" | "neutral";

export interface PasVendorOrderDetail {
  readonly label: string;
  readonly value: string;
}

export interface PasVendorOrder {
  readonly id: string;
  readonly orderReference: string;
  readonly buyerLabel: string;
  readonly itemLabel: string;
  readonly orderValueLabel?: string;
  readonly planTypeLabel?: string;
  readonly statusLabel: string;
  readonly statusTone?: PasVendorOrderTone;
  readonly overdue?: boolean;
  /** Host-derived capability; the page does not infer eligibility from a status string. */
  readonly canConfirmDelivery?: boolean;
  readonly details: readonly PasVendorOrderDetail[];
}

export type PasVendorOrdersResult =
  | { readonly state: "ready"; readonly orders: readonly PasVendorOrder[] }
  | { readonly state: "empty" }
  | { readonly state: "unavailable" }
  | { readonly state: "restricted" };

export interface PasVendorOrdersAdapter {
  /** Host-mapped list data. No vendor order-list endpoint or response schema is documented. */
  loadOrders(input: { readonly tenantId: string }): Promise<PasVendorOrdersResult>;
  /** Host owns tenant auth, PIN, Idempotency-Key, request mapping and status reconciliation. */
  confirmDelivered?(input: {
    readonly tenantId: string;
    readonly orderId: string;
    readonly deliveryCode: string;
    readonly proofFileKey?: string;
  }): Promise<void>;
}

export interface PasVendorOrdersCopy {
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
  readonly allOrders: string;
  readonly ordersHeading: string;
  readonly order: string;
  readonly buyer: string;
  readonly item: string;
  readonly value: string;
  readonly planType: string;
  readonly status: string;
  readonly overdue: string;
  readonly noResultsTitle: string;
  readonly noResultsBody: string;
  readonly detailHeading: string;
  readonly syntheticLabel: string;
  readonly notSupplied: string;
  readonly deliveryHeading: string;
  readonly deliveryCode: string;
  readonly deliveryCodeHint: string;
  readonly deliveryCodeInvalid: string;
  readonly confirmDelivery: string;
  readonly confirmingDelivery: string;
  readonly deliveryUnavailable: string;
  readonly deliverySuccess: string;
  readonly deliveryError: string;
  readonly proofUnavailable: string;
  readonly shippedUnavailable: string;
  readonly noSelection: string;
  readonly summaryOrders: string;
  readonly summaryPending: string;
  readonly summaryInTransit: string;
  readonly summaryOverdue: string;
  readonly metricUnavailable: string;
}
