export type PaymentLinkFilter = "all" | "active" | "expired";
export type PaymentLinkStatus = "active" | "expired";

/** Host-facing presentation row. This is not an API response DTO. */
export interface PaymentLinkRow {
  readonly id: string;
  readonly description: string;
  readonly amountKobo: number | null;
  readonly expiresAt: string | null;
  readonly multiUse: boolean;
  readonly status: PaymentLinkStatus;
}

/** Frontend request intent matching documented fields; it is not a wire DTO. */
export interface CreatePaymentLinkInput {
  readonly kind: "LINK";
  readonly amountKobo?: number;
  readonly description?: string;
  readonly expiresAt?: string;
  readonly multiUse?: boolean;
}

export interface PaymentLinkAdapter {
  loadPaymentLinks(input: {
    readonly tenantId: string;
    readonly filter: PaymentLinkFilter;
  }): Promise<readonly PaymentLinkRow[]>;
  createPaymentLink(input: {
    readonly tenantId: string;
    readonly request: CreatePaymentLinkInput;
  }): Promise<void>;
}
