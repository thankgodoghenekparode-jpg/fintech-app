# Bills & Utilities API Addendum (Draft)

**Scope:** Developer 1 S-CB-041 (bill categories) and S-CB-042 (bill validation/payment), aligned to the two Developer 1 handoffs and Stitch exports.

**Status:** Incorporated into the local Developer 1 OpenAPI contract as v1.2.0 with `frontend-backend-revision-pending-backend-parity`; this is not a claim that the backend implements it. Backend review, implementation and security/product approval remain pending. Amounts are integer kobo, all operations use the existing bearer authentication, and payment submission remains protected by `X-Pin-Token` and `Idempotency-Key`.

## Catalog response for `GET /bills/categories`

Return an array of bill categories. Each category includes `code`, `name`, `description`, `displayOrder`, and `billers`. Each biller includes `code`, `name`, `categoryCode`, `description`, `customerReferenceLabel`, `customerReferencePattern`, and `products`. Each product includes `code`, `name`, `fixedAmountKobo` (nullable), `minimumAmountKobo` (nullable), `maximumAmountKobo` (nullable), and `requiresCustomerReference`.

No category, biller, network, price, fee, official badge, or provider name is to be hard-coded from Stitch sample content.

## Saved billers

Add `GET /bills/saved` returning an array of `{id, billerCode, productCode, billerName, productName, categoryCode, customerReferenceMasked, customerReferenceSuffix, lastPaidAt}`. To avoid returning a full saved meter/decoder/phone reference in a list, allow validation using `savedBillerId` and payment by the resulting one-use `validationId`.

## Validation response

`POST /bills/validate` accepts either `{billerCode, productCode, customerRef?}` or `{savedBillerId}`. `customerRef` is required when the selected product requires it. Return required `validationId`, `customerName`, `billerName`, `productName`, `validatedAt`, and `expiresAt`, plus optional `fixedAmountKobo`, `minimumAmountKobo`, `maximumAmountKobo`, and `feeKobo`. The validation ID is bound to the authenticated account, product, and customer reference and expires quickly; payment must reject expired, consumed, or mismatched validation IDs.

## Payment request and result

`POST /bills/pay` accepts `validationId`, `amountKobo`, optional `saveBiller`, and optional `deliveryPhone`. Keep the existing `Idempotency-Key` and `X-Pin-Token` headers. Return a typed result for both 200 and 202 with `transaction` (the existing Transaction schema), `vendStatus` (`PENDING`, `SUCCESSFUL`, `FAILED`), optional `token` and `tokenType`, `tokenDeliveryStatus` (`NOT_REQUIRED`, `PENDING`, `DELIVERED`, `FAILED`), and `refundStatus` (`NOT_REQUIRED`, `PENDING`, `REFUNDED`, `FAILED`). Never tell the customer a prepaid token was delivered until delivery is confirmed. A failed vend must expose the transaction/refund state so the UI can report the documented automatic refund accurately.

## Confirm before live release

Backend owners must confirm field names, reference validation rules, amount/fee constraints, validation lifetime and single-use behavior, payment state transitions, token delivery, refunds, saved-biller retention/deletion, and error codes. The local screen may preview fictional catalog content only in explicitly enabled demo mode. Live payment controls stay unavailable until the revised contract is implemented and verified by backend integration tests.
