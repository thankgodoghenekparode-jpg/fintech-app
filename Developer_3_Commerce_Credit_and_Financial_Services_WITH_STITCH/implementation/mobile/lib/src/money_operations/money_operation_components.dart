import 'package:flutter/material.dart';

import '../business_home/business_home_tokens.dart';

/// Parses a user-entered naira amount into integer kobo without float math.
int? parseNairaToKobo(String raw) {
  final value = raw.trim().replaceAll(',', '');
  if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(value)) return null;
  final parts = value.split('.');
  final naira = BigInt.tryParse(parts.first);
  final kobo = BigInt.tryParse(
    parts.length == 1 ? '0' : parts[1].padRight(2, '0'),
  );
  if (naira == null || kobo == null) return null;
  final result = naira * BigInt.from(100) + kobo;
  if (result <= BigInt.zero || result > BigInt.parse('9223372036854775807')) {
    return null;
  }
  return result.toInt();
}

String nairaInputFromKobo(int amountKobo) {
  final whole = amountKobo ~/ 100;
  final fraction = (amountKobo % 100).toString().padLeft(2, '0');
  return '$whole.$fraction';
}

class MerchantOperationStatusBadge extends StatelessWidget {
  const MerchantOperationStatusBadge({
    required this.label,
    required this.icon,
    required this.color,
    required this.tokens,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color color;
  final MerchantHomeTokens tokens;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.smallGap,
            vertical: tokens.smallGap / 2,
          ),
          decoration: BoxDecoration(
            color: color.withAlpha(24),
            borderRadius: BorderRadius.circular(tokens.controlRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: tokens.smallGap / 2),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: color),
              ),
            ],
          ),
        ),
      );
}
