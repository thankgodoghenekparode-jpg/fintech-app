# Statements API Addendum (Draft)

**Scope:** Developer 1 S-CB-076 / CB-ACC-005 and CB-SET-004.

**Status:** Proposed local frontend/backend contract revision for OpenAPI 1.5.0. This is not evidence that the bank backend implements these operations. Backend, security, records-retention and product approval remain required before release.

## Account-scoped archive and capabilities

`GET /accounts/me/statements` returns `{items, maximumRangeDays, emailDeliveryAvailable, registeredEmailMasked}`. `items` contains only statement requests owned by the authenticated account, newest first. `maximumRangeDays` is the server-configured inclusive maximum range; the client must not invent a regulatory or product threshold. A non-empty `registeredEmailMasked` is required when email delivery is available and is otherwise omitted or null. It is informational and cannot be supplied or changed by the client.

Each item contains `requestId`, `fromDate`, `toDate`, `format` (`PDF`), `deliveryMethod` (`DOWNLOAD` or `EMAIL`), `status` (`QUEUED`, `GENERATING`, `READY`, `FAILED`), `deliveryStatus` (`NOT_APPLICABLE`, `PENDING`, `SENT`, `FAILED`), `createdAt`, optional `completedAt`, and optional `failureCode`. Do not return sample rows or expose generated document URLs in the list.

## Request a statement

`POST /accounts/me/statements` accepts `{fromDate, toDate, format: "PDF", deliveryMethod}` and requires the existing UUID `Idempotency-Key` header. It returns `202` and the typed request item. The service validates range ordering and its configured `maximumRangeDays`; an oversized range returns `422` with `code: "STATEMENT_RANGE_TOO_LARGE"` and `details.maximumRangeDays`. Email delivery uses only the account's verified registered email; there is no arbitrary recipient field. If email delivery is unavailable or the account has no verified email, return `422` with `code: "STATEMENT_EMAIL_UNAVAILABLE"`.

## Download a ready PDF

`GET /accounts/me/statements/{requestId}/download` returns `application/pdf` bytes only when the request belongs to the authenticated account and is `READY`. The server must check ownership and readiness, set `Content-Disposition: attachment`, and send `Cache-Control: private, no-store`. A not-ready request returns `409`; unknown or foreign requests return a non-enumerating `404`. The Flutter client obtains the bytes through the authenticated API and hands the file to the platform share/save sheet. No long-lived or unauthenticated document URL is returned.

## Security and operations to confirm

- Confirm date inclusivity, timezone and maximum supported period configuration.
- Define idempotency retention, per-account request throttles, job expiry, and retry behavior.
- Confirm delivery status semantics, verified-email source, and email failure handling.
- Ensure statement generation/download access is audited and account-scoped; documents contain sensitive financial data.
- Confirm file size limits, PDF content type, antivirus/scanning requirements, and whether statements require an issuer label or certification. The current UI makes no certification, regulator acceptance, fee, or sponsor-bank claim.


## Source references

- Developer 1 behavior and route: [UI_UX_SPEC.md](Developer_1_Core_Banking_and_Backoffice/work_scope/03_core-banking/UI_UX_SPEC.md) (S-CB-076) and [F-10_statements.md](Developer_1_Core_Banking_and_Backoffice/work_scope/05_flowcharts-drawio/F-10_statements.md).
- Original consolidated flow: [F-10_statements.md](front-end%20extracted/05_flowcharts-drawio/F-10_statements.md).
- Stitch layout: [S-CB-076 light](Developer_1_Core_Banking_and_Backoffice_WITH_STITCH/Developer_1_Core_Banking_and_Backoffice/shared_reference/06_stitch-ui-ux/screens/statements_s_cb_076/) and dark mode reference in the adjacent `statements_dark_mode_s_cb_076/` folder.
- The Flutter screen deliberately omits the Stitch sample account choices, CSV option, certificate/QR and regulatory-acceptance claims, fees, fictional archive rows, and clear-all control because those are absent from the functional/API sources.
