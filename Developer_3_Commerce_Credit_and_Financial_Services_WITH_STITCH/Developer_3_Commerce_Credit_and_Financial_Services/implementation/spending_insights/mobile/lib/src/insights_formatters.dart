/// Display-only conversion of integer kobo to a naira amount string.
String formatInsightsMoney(int? kobo) {
  if (kobo == null) return '—';
  final absolute = kobo.abs();
  final whole = (absolute ~/ 100).toString();
  final grouped = whole.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final fraction = (absolute % 100).toString().padLeft(2, '0');
  final sign = kobo < 0 ? '−' : '';
  return '$sign₦$grouped.$fraction';
}
