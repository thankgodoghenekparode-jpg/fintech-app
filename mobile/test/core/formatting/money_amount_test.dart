import 'package:flutter_test/flutter_test.dart';

import 'package:developer_2_mobile/core/formatting/money_amount.dart';

void main() {
  group('parseNairaToKobo', () {
    test('parses whole and decimal naira amounts', () {
      expect(parseNairaToKobo('1200'), 120000);
      expect(parseNairaToKobo('1200.5'), 120050);
      expect(parseNairaToKobo('1200.05'), 120005);
    });

    test('accepts correctly grouped thousands', () {
      expect(parseNairaToKobo('1,200.50'), 120050);
      expect(parseNairaToKobo('12,345,678'), 1234567800);
    });

    test('rejects malformed or unsupported input', () {
      for (final value in [
        '',
        '0',
        '1,2',
        '12,34.00',
        '1,,000',
        '1.234',
        '-1',
        '1e3',
      ]) {
        expect(parseNairaToKobo(value), isNull, reason: value);
      }
    });

    test('enforces the supplied maximum', () {
      expect(parseNairaToKobo('100', maxKobo: 9999), isNull);
      expect(parseNairaToKobo('99.99', maxKobo: 9999), 9999);
    });

    test('stays within JavaScript safe integer range by default', () {
      expect(parseNairaToKobo('90071992547409.91'), 9007199254740991);
      expect(parseNairaToKobo('90071992547409.92'), isNull);
    });
  });
}
