# Pay Am Small Vendor Web — Batch 8 API Gaps

This note records the contract limits for W-PAS-003 and W-PAS-004. The feature uses host-injected adapters and does not define API DTOs.

## W-PAS-003 — Orders & Fulfilment

- `GET /pas/vendor/orders` (or another vendor order-list operation) is not documented. The host must supply an approved order-list source, status mapping, search/pagination semantics, detail fields, overdue indicators, and the capability that determines which order may be confirmed.
- `POST /pas/vendor/orders/{orderId}/delivered` is documented with `X-Tenant-Id`, `Idempotency-Key`, `X-PIN-Token`, `deliveryCode`, and optional `proofFileKey`. Its success response schema is unspecified. The host adapter owns auth, idempotency, request mapping, result reconciliation, and retry safety.
- The delivery code is documented as six digits (`pas.code.invalid`). The contract does not define order status enums or a `shipped` operation, so marking an order shipped remains unavailable. UI status filters use only labels supplied by the host.
- The API accepts an optional `proofFileKey`, but there is no file upload/storage endpoint or file constraints. Proof attachment remains unavailable until the host provides a file key and upload integration.
- The Stitch export depicts buyer identity, serial/IMEI validation, courier and release/settlement controls. These data sources and operations are not defined by the vendor order contracts and are not fabricated by this feature.

## W-PAS-004 — Plans & Customers

- `GET /pas/vendor/plans` is documented with `X-Tenant-Id`, but the `200` response has no schema. The host must define the normalized mapping for plan/customer references, identity and verification summaries, product, plan type/status, progress, amount labels, due information, and repayment history.
- Pagination, sorting, filtering, and aggregation semantics are undocumented. The feature filters only the host-supplied records in the current adapter result and does not claim server-wide counts or calculate financial values.
- No vendor-plan detail or plan/customer action endpoint is defined for this screen. Selecting a row opens a local inspector using fields already supplied by the host; no additional customer data is fetched.
- Vendor-funded credit legal/product approval is unresolved (O-009). The preview contains only synthetic Price-lock plan examples and the screen exposes no credit decision action.

## Stitch references and themes

- Light references inspected: `shared_reference/06_stitch-ui-ux/screens/orders_and_fulfilment_w_pas_003/{screen.png,code.html}` and `shared_reference/06_stitch-ui-ux/screens/plans_and_customers_w_pas_004/{screen.png,code.html}`.
- No dark-mode Stitch folders for these screen IDs were present in the approved `shared_reference/06_stitch-ui-ux/screens` inventory. The implementation retains the same layout in dark mode using the approved shared dark tokens.
