# Force Update API Unblocking Addendum

**Status: Frontend policy model and route are implemented against this proposal. Backend and release-owner approval/parity are required before enforcing updates in production.**

## Handoff references

- Developer 1 S-CB-092 requires a message and an Update action to the app store.
- Developer 1 `shared_reference/11_release-devops/FE_RELEASE_AND_CICD.md` says the minimum supported version is served by the backend and S-CB-092 triggers below that minimum.
- The supplied API contract has no version-policy operation. The app identifiers remain development `com.example.yourapp_mobile`; no production Android application ID, iOS bundle ID, or store URLs are supplied.
- Stitch example versions, release claims, download size, security feature list, CBN/NIBSS language and app-store CTA must not be treated as approved release metadata.

## Proposed public policy operation

`GET /app/version-policy?platform=ANDROID&currentVersion=1.0.0`

The backend returns the supported policy for the client platform and current semantic version:

```json
{
  "required": true,
  "minimumSupportedVersion": "1.1.0",
  "latestVersion": "1.2.0",
  "storeUrl": "https://play.google.com/store/apps/details?id=<approved-android-application-id>",
  "releaseNotesUrl": "https://<approved-bank-domain>/releases/1.2.0",
  "message": "Update the app to continue using banking services."
}
```

The example values are schema illustrations, not production values. iOS policy returns an approved App Store URL. `required` is authoritative and calculated server-side. Responses should be cache-controlled for a short period and include a policy version/effective time for release audit. Store links must use HTTPS and official `play.google.com` or `apps.apple.com` hosts; the client validates those hosts before opening them.

## Frontend behavior and remaining gate

- The app reads its installed version from package metadata and presents a required update only when it receives an approved policy with `required: true`.
- `/update` accepts a typed policy through internal route state. If policy is absent, it shows an unconfigured state with update actions disabled; it does not invent a minimum version or open a guessed store listing.
- `/demo/update` is a preview-only route and cannot launch a store or claim an actual update is required.
- The policy fetch, app-start enforcement, store identifiers/URLs, release notes and backend behavior are not live until the backend and release owners approve and implement this proposal.
