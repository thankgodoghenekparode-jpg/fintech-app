export function formatKobo(amountKobo: number): string {
  if (!Number.isSafeInteger(amountKobo)) {
    throw new RangeError("Money values must be safe integer kobo.");
  }

  const amount = BigInt(amountKobo);
  const absolute = amount < 0n ? -amount : amount;
  const whole = absolute / 100n;
  const fraction = (absolute % 100n).toString().padStart(2, "0");
  const sign = amount < 0n ? "−" : "";
  return `${sign}₦${new Intl.NumberFormat("en-NG").format(whole)}.${fraction}`;
}

export function parseNairaToKobo(value: string): number | null {
  const normalized = value.trim().replaceAll(",", "");
  const match = /^(\d+)(?:\.(\d{1,2}))?$/.exec(normalized);
  if (!match) return null;

  const whole = BigInt(match[1]);
  const fraction = BigInt((match[2] ?? "").padEnd(2, "0"));
  const kobo = whole * 100n + fraction;
  if (kobo <= 0n || kobo > BigInt(Number.MAX_SAFE_INTEGER)) return null;
  return Number(kobo);
}

export function formatDate(value: string): string {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "—";
  return new Intl.DateTimeFormat("en-GB", {
    day: "2-digit",
    month: "short",
    year: "numeric",
  }).format(date);
}
