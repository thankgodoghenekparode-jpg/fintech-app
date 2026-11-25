# Extracted Frontend Reference Sources

The user identified `front-end extracted/front-end extracted/` at the workspace root as a reference source. Use it alongside this isolated Developer 2 workspace when resolving frontend behavior.

## Target Savings and core security

- `07_api-contracts/openapi_core.yaml` defines `POST /auth/pin/verify`: four-digit PIN request and a one-action `pinToken` response. It also defines login and refresh token exchanges.
- `04_products/target-savings/04_api_spec.yaml` defines create, list, detail, top-up, auto-save, withdrawal, what-if, and rule operations. Amounts are integer kobo; money actions require an idempotency key and PIN token.
- `04_products/target-savings/03_ui_ux_spec.md` defines the mobile screen layouts and navigation.
- `04_products/target-savings/04_validation_and_errors.md` defines the 2–40 character goal name rule and server error behavior.
- `04_products/target-savings/05_api_consumption.md` maps operations to screens and specifies tenant headers.
- `08_security/FE_SECURITY_SPEC.md` requires secure token storage, no PIN persistence, an in-app keypad, and screenshot protection on sensitive screens.

## Contract limits still present in those references

- Target Savings success responses have no schemas, including list/detail/history and create. The create response therefore provides no goal ID for detail navigation.
- The create request's `autoSave` is an unconstrained object. A separate auto-save operation defines frequency, amount in kobo, and start date.
- The isolated app has no shared `SessionManager` or `SecurityService`, no token refresh interceptor, and no platform screenshot-protection integration. The Target Savings PIN dialog keeps input in memory and calls the documented PIN endpoint; core security integration remains an integration task.
- Target Savings validation refers to a configured maximum amount and deadline horizon, but the values are not present in the frontend contract set.
- The current date picker uses a 20-year horizon because Flutter requires a bounded picker range; replace that provisional cap with the backend's configured maximum when it is published.
