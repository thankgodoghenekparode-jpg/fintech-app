# Accessibility and Performance

## Accessibility (target WCAG 2.1 AA)
1. Contrast: text 4.5:1 minimum (3:1 for large text); verify every token pair in light and dark.
2. Text scales to 200% without clipping; layouts use flexible containers.
3. Screen readers: labels, roles, states for every control; meaningful order; amounts read as "five thousand naira".
4. Never rely on colour alone: statuses use icon plus text.
5. Tap targets at least 48x48 dp; spacing between targets at least 8dp.
6. Focus order logical; PIN pad accessible with screen reader and switch control.
7. Respect reduce-motion; captions for any video; no flashing content.
8. Forms: labels always visible, errors announced, inputs have correct keyboard types.
9. Support system dark mode and font settings.

## Performance budgets (mid-range Android, 3G)
| Metric | Target |
|---|---|
| Cold start to interactive | under 3 s |
| Screen transition | under 300 ms perceived |
| Home data load (cached) | under 500 ms |
| App size (Android, release) | under 40 MB |
| Frame rate | 60 fps scrolling lists |
| API payloads | paginate; images compressed; no blocking calls on main thread |

## Techniques
Skeleton loaders, list virtualisation, image caching with size limits, split web bundles by route, defer non-critical SDKs, track startup and jank with performance monitoring.

## Checks in CI
Contrast linter on tokens, accessibility lint rules, performance smoke test on a reference device profile, bundle size budget.
