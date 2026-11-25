# Local Target Savings API mock

This development mock implements only operations with request fields used by the current mobile Target Savings flow, plus the PIN verification response shape from the core OpenAPI contract.

## Contract sources

- `../front-end extracted/front-end extracted/04_products/target-savings/04_api_spec.yaml`
- `../front-end extracted/front-end extracted/07_api-contracts/openapi_core.yaml`
- `../front-end extracted/front-end extracted/04_products/target-savings/04_validation_and_errors.md`
- `../front-end extracted/front-end extracted/07_api-contracts/ERROR_CODES.md`

The Target Savings success responses for `GET /targets`, `GET /targets/{goalId}`, `POST /targets`, `POST /targets/{goalId}/topups`, and `PUT /targets/{goalId}/auto-save` specify status codes but no response content. The mock therefore returns empty success bodies for these routes; it does not invent goal IDs, balances, progress, or schedule projections. It also does not persist successful writes.

## Run

From the frontend workspace root:

```powershell
node .\mock-api\server.mjs
```

The mock listens on port `8787` by default. Set `MOCK_API_PORT` to use another port. The `GET /health` endpoint reports whether it is running.

Run the mobile app against it with an explicit development token:

```powershell
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8787 --dart-define=MOCK_API_ACCESS_TOKEN=mock-access-token
```

For an Android emulator, use `http://10.0.2.2:8787` as the API base URL. The mobile API client accepts the compile-time mock token only when the API host is loopback or the Android emulator loopback alias. A token already stored in secure storage takes precedence.

To preview the Target Savings home with sample values from the supplied Stitch design, run the app with `--dart-define=TARGET_SAVINGS_DEMO=true`. This screen is explicitly labeled, read-only, and separate from API responses; real mode remains the default.

## Implemented behavior

- `POST /auth/pin/verify` accepts any four-digit PIN in mock mode and returns `pinToken` plus `expiresInSeconds`, matching the core response fields. The issued token can authorize one write and expires after 60 seconds. This is mock behavior, not PIN authentication.
- Requests without a bearer header receive the mock-only `MOCK_BEARER_REQUIRED` error; the server does not authenticate or validate account tokens.
- `POST /targets`, `POST /targets/{goalId}/topups`, and `PUT /targets/{goalId}/auto-save` check the documented request fields, UUID path/key formats, bearer header, and one-use PIN token, then return the status specified by the product contract with no body.
- `GET /targets` and `GET /targets/{goalId}` return the documented success status with no body because the specs define no response schema or content.
- Other operations return `501 MOCK_OPERATION_UNIMPLEMENTED` and are outside the mock's contract coverage.

The mock does not validate account credentials, model balances or goal state, apply idempotent replay behavior, or simulate product error conditions whose status/response is unspecified. It is for local UI request and success-flow development only; do not use it as a backend or financial behavior reference.
