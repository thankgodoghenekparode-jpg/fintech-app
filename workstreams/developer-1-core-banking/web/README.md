# YourApp Web

Next.js App Router frontend for the dashboard and web workspaces described in the source handoff.

## Local setup

1. Copy `.env.example` to `.env.local` and set `NEXT_PUBLIC_API_BASE_URL` to the API base URL for the environment.
2. Install dependencies with `npm install`.
3. Run `npm run dev`.

The account overview reads `GET /accounts/me` and `GET /accounts/me/transactions` as defined by the supplied Core API contract. It requires a backend session cookie; it does not include credentials in client storage.
