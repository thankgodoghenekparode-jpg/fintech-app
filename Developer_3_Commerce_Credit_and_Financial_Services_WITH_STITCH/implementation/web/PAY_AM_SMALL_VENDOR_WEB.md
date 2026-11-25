# Pay Am Small vendor web preview

This additive feature package implements W-PAS-001 Vendor Dashboard and W-PAS-002 Products & Prices. It is separate from the Merchant Tools preview and does not register production host routes.

## Launch the isolated preview

From `implementation/web/`, build and serve the isolated production preview:

```powershell
npm.cmd run build:pas-vendor
npm.cmd run preview:pas-vendor
```

Open `http://127.0.0.1:4180/`. The preview is marked NON-PRODUCTION, offers both feature routes through the vendor sidebar, and supports the light/dark token themes. Use the theme icon in the top bar to switch themes. `npm.cmd run dev:pas-vendor` is also available for development; in the current environment its Vite dev dependency optimizer encountered an esbuild access-denied error, so use the production preview commands above here.

For a production-mode static bundle run `npm.cmd run build:pas-vendor`. Its output is isolated at `preview/pay_am_small_vendor/dist/`; it does not replace the Merchant preview bundle.

## Routes and current preview data

- `/vendor/synthetic-vendor-tenant/dashboard` — dashboard shell, unavailable-data KPI placeholders, empty chart/alert regions. No dashboard endpoint exists, so preview figures and transaction rows are not fabricated.
- `/vendor/synthetic-vendor-tenant/products` — a clearly labelled synthetic catalogue row with unspecified price, stock, modes, and delivery values. Product submission stays disabled because the API's `modes` enum has not been specified for the host. No live API, auth, payout, credit, or inventory action is connected.

The implemented components accept injected adapters and tenant IDs. They do not own API clients or wire response DTOs.

## Contract and design gaps

- W-PAS-001 has no documented dashboard endpoint or response schema. KPI values, chart series and periods, low-stock/late-delivery alerts, and restricted state must be supplied through a host mapping. Other dashboard drill-down routes are not in this batch; only the implemented Products & Prices route is navigable.
- W-PAS-002 has no documented product-list GET endpoint or list/201 response schema. `POST /pas/vendor/products` documents `title`, `priceKobo`, `stock`, `modes`, and `deliveryDays`, plus optional `lockDaysMax`, and requires `X-Tenant-Id`. The `modes` array has no enum. Host adapters must supply approved mode values and map catalogue presentation data.
- The API summary calls the POST create/update, but does not specify product identity/update semantics, so this screen exposes create only. No delete, deactivate, price edit, plan-mode enforcement, image upload, or stock reservation action is implemented. A price-change-blocked state is shown only when explicitly mapped by the host; there is no active-plan lookup contract here.
- The approved Stitch light files exist at `shared_reference/06_stitch-ui-ux/screens/vendor_dashboard_w_pas_001/{screen.png,code.html}` and `products_and_prices_w_pas_002/{screen.png,code.html}`. No matching dark-mode export was found in the approved workspace or extracted reference folders. The same structure is styled with shared dark tokens. Stitch HTML contains colors and financial/regulatory/product claims that conflict with the shared design-token source and product/API documentation; those values and unsupported claims are omitted.
- Product imagery is not defined in the documented vendor product request fields. The interface uses the shared outline icon treatment rather than inventing an image source or image-upload operation.
