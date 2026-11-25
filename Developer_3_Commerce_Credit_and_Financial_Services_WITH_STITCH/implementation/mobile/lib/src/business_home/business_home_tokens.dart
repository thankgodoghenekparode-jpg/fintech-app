/// Spacing and radius values are supplied from the host's generated tokens.
/// This package intentionally does not define a second design token set.
class MerchantHomeTokens {
  const MerchantHomeTokens({
    required this.pageGutter,
    required this.sectionGap,
    required this.cardPadding,
    required this.elementGap,
    required this.smallGap,
    required this.cardRadius,
    required this.controlRadius,
  });

  final double pageGutter;
  final double sectionGap;
  final double cardPadding;
  final double elementGap;
  final double smallGap;
  final double cardRadius;
  final double controlRadius;
}
