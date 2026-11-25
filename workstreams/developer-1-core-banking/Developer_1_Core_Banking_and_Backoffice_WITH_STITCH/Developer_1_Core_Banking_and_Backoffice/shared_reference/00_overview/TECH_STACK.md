# Front-end Tech Stack (decided: Flutter + React/TypeScript)

## Mobile - Flutter (Dart, stable channel)
| Concern | Choice |
|---|---|
| State management | Riverpod (with code generation) |
| Navigation | go_router (declarative, deep links) |
| Networking | dio with interceptors (auth, idempotency key, retry, logging off in release) |
| Models | freezed + json_serializable |
| Secure storage | flutter_secure_storage (Keychain / Keystore) |
| Biometrics | local_auth |
| Local DB/cache | drift or isar for non-sensitive cache only |
| Push | Firebase Cloud Messaging |
| Localisation | flutter_localizations + ARB files (central text layer) |
| Analytics | privacy-respecting event layer behind an interface |
| Testing | flutter_test, mocktail, integration_test, golden tests |
| Lint | very_good_analysis or flutter_lints strict |

## Web - React + TypeScript (Next.js App Router)
| Concern | Choice |
|---|---|
| Data fetching | TanStack Query |
| Forms/validation | React Hook Form + Zod |
| UI | Tailwind CSS + headless component primitives built from the design tokens |
| Tables/charts | TanStack Table, a lightweight chart library |
| Auth | HTTP-only secure cookies/short-lived tokens via the back end |
| i18n | next-intl (central text layer) |
| Testing | Vitest, Testing Library, Playwright |

## Alternatives noted (not used)
React Native + NestJS was the lean alternative and is not part of this build.
