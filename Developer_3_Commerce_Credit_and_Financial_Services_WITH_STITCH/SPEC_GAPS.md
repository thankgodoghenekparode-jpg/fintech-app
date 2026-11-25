
## W-MER-002 Invoices and W-MER-003 Payment Links

- W-MER-002 UI is limited to host-mapped invoice rows, local search/status filters, selected detail, and a per-invoice send/reminder channel intent matching the documented LINK/SMS/EMAIL enum. The API has no documented GET response schema; pagination/cursor mapping and authoritative status values must be confirmed. POST create has open customer/items fields and no response schema, so create is not implemented in this web page. Invoice editing and bulk reminders are not supported by the current API and are omitted.
- W-MER-003 UI maps host-provided link rows and exposes the documented `kind=LINK`, optional `amountKobo`, description, expiry, and multiUse create intent. GET and POST response schemas are absent. Confirm link identifier/share URL, status mapping, counts, and expiry timezone/boundary with API owners before host integration. Deactivation and analytics are unsupported and omitted.
- Exact visual exports are listed in `INTEGRATION_NOTES.md`. The Stitch image/code contains unsupported sample KPIs, provider/regulatory statements, payment rail/security claims, link analytics, and management actions; those are not product behavior and are omitted.
- The isolated web preview uses synthetic in-memory data only and is not a production route.
