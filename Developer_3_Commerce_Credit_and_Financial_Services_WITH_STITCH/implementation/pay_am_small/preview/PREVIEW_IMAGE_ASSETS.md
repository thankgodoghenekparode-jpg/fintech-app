# Pay Am Small preview image sources

The registered images below are preview-only copies of the image URLs in the approved Stitch `code.html` references. They are bundled locally; the Flutter UI does not fetch remote images at runtime. All catalog values remain synthetic and the preview retains its NON-PRODUCTION warning.

| Bundled asset | Exact Stitch source |
| --- | --- |
| `assets/preview_only/marketplace-freezer.jpg` | `shared_reference/06_stitch-ui-ux/screens/marketplace_home_s_pas_001/code.html`, first product image |
| `assets/preview_only/marketplace-solar.jpg` | `shared_reference/06_stitch-ui-ux/screens/marketplace_home_s_pas_001/code.html`, second product image |
| `assets/preview_only/product-detail-freezer.jpg` | `shared_reference/06_stitch-ui-ux/screens/product_detail_s_pas_002/code.html`, product showcase image |
| `assets/preview_only/storefront-vendor-avatar.jpg` | Crop of the first image in `shared_reference/06_stitch-ui-ux/screens/vendor_storefront_s_pas_012/code.html` for its small circular profile placement |
| `assets/preview_only/storefront-freezer.jpg` | `shared_reference/06_stitch-ui-ux/screens/vendor_storefront_s_pas_012/code.html`, freezer card image |
| `assets/preview_only/storefront-television.jpg` | Same S-PAS-012 reference, television card image |
| `assets/preview_only/storefront-cooker.jpg` | Same S-PAS-012 reference, cooker card image |
| `assets/preview_only/storefront-ac.jpg` | Same S-PAS-012 reference, air-conditioner card image; shortened filename keeps the generated Windows web asset path below the path-length limit. The original `storefront-air-conditioner.jpg` is retained and no longer registered. |

The vendor HTML image visibly contains “AURA Electronics,” while the matching `screen.png` labels the sample profile “MegaPlaza Electronics.” This reference inconsistency is not represented as a real vendor identity: the bundled avatar is cropped to an electronics showroom detail, and the preview profile remains clearly synthetic. The Stitch map image is omitted because its named locations and pickup pins lack a host data contract.

The older `*-reference-crop.png` files from the earlier preview pass are retained for history but are no longer listed in `pubspec.yaml` or used by these screens.

## Typography asset

`assets/fonts/Inter-Variable.ttf` is the Inter variable font named in the approved S-PAS-001, S-PAS-002, and S-PAS-012 Stitch HTML. It is bundled so the preview does not depend on Google Fonts network access. The matching SIL Open Font License is included as `assets/fonts/Inter-OFL.txt`; source: [Google Fonts Inter](https://github.com/google/fonts/tree/main/ofl/inter).
