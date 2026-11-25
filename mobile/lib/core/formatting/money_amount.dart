/// Parses a naira amount into kobo, rejecting malformed grouping and precision.
const maxSafeKobo = 9007199254740991;

int? parseNairaToKobo(
  String input, {
  int maxKobo = maxSafeKobo,
}) {
  final rawAmount = input.trim();
  if (!RegExp(r'^(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d{1,2})?$')
      .hasMatch(rawAmount)) {
    return null;
  }

  final amount = rawAmount.replaceAll(',', '');
  final parts = amount.split('.');
  final whole = BigInt.tryParse(parts[0]);
  if (whole == null) return null;

  final fraction = (parts.length == 1 ? '' : parts[1]).padRight(2, '0');
  final kobo = whole * BigInt.from(100) + BigInt.parse(fraction);
  if (kobo <= BigInt.zero || kobo > BigInt.from(maxKobo)) return null;
  return kobo.toInt();
}
