# Agent Locator API Unblocking Addendum

**Status: Frontend integration proposal. Backend/product approval and parity are required before production use.**

## Handoff references

- Developer 1 S-CB-082 (`/locator`) requires a map, search, list toggle, location permission handling, result details and directions.
- `front-end extracted/04_products/agent-network/PRD.md`, AGT-LOC-001, requires nearby-agent map/list results with distance, hours and services.
- `front-end extracted/04_products/agent-network/04_api_spec.yaml` documents `GET /agents/nearby` with `lat`, `lng` and `radius`, but gives no response schema and no text-query parameter.
- The Stitch export includes branch examples, but no branch endpoint/contract is supplied. Its example names, addresses, distance, hours, phone and float status are illustrative and must not be shipped as real locations.

## Proposed extension to the existing operation

Keep `GET /agents/nearby`. Add optional `q` for a customer-entered area/landmark search when device location is unavailable. Require either `q` or the complete `lat` + `lng` pair; accept `radius` in metres, bounded by the server's approved maximum. The server must validate location values and return only active, customer-visible agents.

Proposed success response:

```json
{
  "items": [
    {
      "id": "agent-id",
      "name": "Agent display name",
      "address": "Customer-visible address",
      "latitude": 6.45,
      "longitude": 3.42,
      "distanceMeters": 350,
      "verified": true,
      "services": ["CASH_IN", "CASH_OUT"],
      "openingHours": "Customer-safe opening hours",
      "openNow": null
    }
  ],
  "searchArea": "Resolved area label or null",
  "radiusMeters": 2500
}
```

`openNow` may be returned only when the server has authoritative hours/time-zone rules; otherwise the client must not infer it. Phone numbers, float balance/status, customer ratings, branches and cash services beyond the allow-listed enum are omitted until approved data fields and rules are defined. No request in this screen moves money.

## Frontend behaviour and remaining gates

- Ask for device location only after the customer taps **Use my location**. If permission is denied, explain it and allow `q` search.
- Render API results in a list and show directions using the selected agent coordinates. Validate all server coordinates before using them.
- No tile/map provider or branch endpoint is supplied. The map panel remains an explicit unavailable state until a map provider and branch API/data are approved; Stitch fixture pins are not used.
- Backend must implement and approve the proposed query/response schema before the live locator can load production results. See `SPEC_GAPS.md`.
