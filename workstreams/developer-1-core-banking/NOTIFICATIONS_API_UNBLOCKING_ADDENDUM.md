# Notifications API Unblocking Addendum

**Status:** The Developer 1 OpenAPI contract is locally revised to v1.3.0 with typed notification pages, unread counts, category filtering, cursor pagination, item read, and read-all operations. Backend parity and product/security approval remain outstanding.

## Frontend behavior

- S-CB-021 reads the authenticated `/notifications` endpoint, groups rows into Today and Earlier, supports All / Transactions / Security & System filters, shows unread status/count, and fetches later pages with a cursor.
- Mark all read calls the documented `/notifications/read-all` operation.
- Selecting a row marks it read through the proposed `POST /notifications/{id}/read`, then navigates only to a locally allow-listed destination. Unknown destination values never become arbitrary routes.
- The Stitch sample's "Lock Account" action is omitted because no notification-triggered account-lock API is documented.

## Local contract addition

Version 1.3.0 types the existing list and read-all operations, adds `NotificationPage`, `Notification`, and `NotificationDestination`, supports an optional category filter and cursor, and proposes item read. The schema allows only transaction detail, account details, payments, cards, or no destination. The API must enforce ownership of notification IDs and any referenced resource IDs.

## Backend and product checklist

- [ ] Backend publishes the v1.3 notification page and stable cursor ordering.
- [ ] Backend implements category filter semantics, unread count, mark-all-read and item-read operations.
- [ ] Backend confirms delivery/read consistency and duplicate-read behavior.
- [ ] Backend validates deep-link resource ownership and returns only supported destinations.
- [ ] Security/product reviews notification content for sensitive data exposure on lock screens and in the in-app feed.
- [ ] Contract parity and Flutter integration tests run against the deployed environment.

This proposal changes only the local project contract. It does not establish that a remote backend implements or approves these operations.
