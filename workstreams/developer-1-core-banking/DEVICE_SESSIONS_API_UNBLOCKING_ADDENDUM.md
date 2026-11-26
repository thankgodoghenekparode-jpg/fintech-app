# Linked Devices API Unblocking Addendum

## Source contract and missing details

The Developer 1 handoff and `front-end extracted/07_api-contracts/openapi_core.yaml` already define `GET /security/devices` and `DELETE /security/devices/{id}`. The GET operation has no response schema. The DELETE operation has a UUID path parameter but no PIN-token parameter, success response details, current-device rule, or revocation behavior. S-CB-074 requires a device list, a current-device badge, a confirmation step, and PIN verification before removing a non-current device.

This proposal does not edit either source OpenAPI file. Backend approval and implementation are required before treating the client integration as production-ready.

## Proposed list response

```json
{
  "items": [
    {
      "id": "20000000-0000-4000-8000-000000000001",
      "name": "Android phone",
      "platform": "Android",
      "appVersion": "1.0.0",
      "lastUsedAt": "2026-11-25T16:00:00Z",
      "approximateLocation": "Lagos area",
      "isCurrent": true
    }
  ]
}
```

`items` is required. `id`, `name`, and `isCurrent` are required per item. `platform`, `appVersion`, `lastUsedAt`, and `approximateLocation` may be omitted when unavailable. `isCurrent` must be derived by the server for the authenticated device. Approximate location should be city/region level only. Do not return IP addresses, device secrets, session tokens, or biometric credentials to this UI.

## Proposed removal behavior

- Retain `DELETE /security/devices/{id}` and require the existing one-use `X-Pin-Token` header obtained through `POST /auth/pin/verify`.
- Return `204` only after removal/revocation is committed. Confirm whether revocation immediately invalidates that device's active sessions and how the device observes revocation.
- Reject removal of the current authenticated device server-side with a documented `409`/business error; the UI also disables this action locally.
- Use documented generic error bodies for authorization, unknown IDs and PIN failures. Confirm rate limits and PIN-token consumption on failures.
- There is no bulk "log out all other devices" operation in the supplied contract; the UI does not send one.

## Frontend implementation boundary

`/more/devices` is implemented against this isolated response proposal. It validates UUIDs, lengths, timestamps, duplicate IDs and the single-current-device invariant; it sanitizes display labels and omits network addresses. Removal confirms intent, verifies PIN, sends `DELETE` with `X-Pin-Token`, then reloads the list. `/demo/devices` uses visibly fictional sample entries and disables removal. Backend parity, approved error behavior, and revocation semantics remain required before release.
