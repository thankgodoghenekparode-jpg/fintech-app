export type Account = {
  id: string;
  accountNumber: string;
  accountName: string;
  status: "ACTIVE" | "LOCKED" | "RESTRICTED" | "DORMANT" | "CLOSED";
  tier: number;
  currency: string;
  ledgerBalanceKobo: number;
  availableBalanceKobo: number;
  limits?: { perTxnKobo?: number; dailyOutKobo?: number; dailyUsedKobo?: number; balanceCapKobo?: number };
};

export type Transaction = {
  id: string;
  reference: string;
  type: string;
  direction: "D" | "C";
  amountKobo: number;
  feeKobo: number;
  status: "PENDING" | "SUCCESSFUL" | "FAILED" | "REVERSED";
  counterpartyName?: string;
  counterpartyBank?: string;
  narration?: string;
  createdAt: string;
};

const apiBase = process.env.NEXT_PUBLIC_API_BASE_URL;

async function get<T>(path: string, signal?: AbortSignal): Promise<T> {
  if (!apiBase) throw new Error("API configuration is missing.");
  const response = await fetch(`${apiBase.replace(/\/$/, "")}${path}`, {
    method: "GET",
    credentials: "include",
    headers: { Accept: "application/json" },
    cache: "no-store",
    signal,
  });
  if (!response.ok) throw new Error(`Request failed (${response.status}).`);
  return response.json() as Promise<T>;
}

export const bankingApi = {
  getAccount: (signal?: AbortSignal) => get<Account>("/accounts/me", signal),
  getTransactions: (signal?: AbortSignal) => get<{ items: Transaction[]; nextCursor?: string | null }>("/accounts/me/transactions?limit=5", signal),
};

export function formatNaira(kobo: number): string {
  return new Intl.NumberFormat("en-NG", { style: "currency", currency: "NGN", minimumFractionDigits: 2 }).format(kobo / 100);
}
