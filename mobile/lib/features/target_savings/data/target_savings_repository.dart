import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final targetSavingsRepositoryProvider = Provider<TargetSavingsRepository>(
  (ref) => TargetSavingsRepository(apiClient: ref.read(apiClientProvider)),
);

class TargetSavingsRepository {
  const TargetSavingsRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<String> verifyPin(String pin) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/pin/verify',
      data: {'pin': pin},
    );
    final token = response.data?['pinToken'];
    if (token is! String || token.isEmpty) {
      throw const ApiRequestFailure('invalid_pin_response');
    }
    return token;
  }

  Future<void> createGoal({
    required String name,
    required int targetKobo,
    required String mode,
    required String theme,
    required String pinToken,
    required String idempotencyKey,
    String? targetDate,
    int? firstDepositKobo,
  }) async {
    final body = <String, Object>{
      'name': name,
      'targetKobo': targetKobo,
      'mode': mode,
      'theme': theme,
      if (targetDate != null) 'targetDate': targetDate,
      if (firstDepositKobo != null) 'firstDepositKobo': firstDepositKobo,
    };
    await _apiClient.post<void>(
      '/targets',
      data: body,
      idempotencyKey: idempotencyKey,
      pinToken: pinToken,
    );
  }

  Future<void> setAutoSave({
    required String goalId,
    required String frequency,
    required int amountKobo,
    required String startDate,
    required String pinToken,
    required String idempotencyKey,
  }) async {
    await _apiClient.put<void>(
      '/targets/$goalId/auto-save',
      data: {
        'frequency': frequency,
        'amountKobo': amountKobo,
        'startDate': startDate,
      },
      idempotencyKey: idempotencyKey,
      pinToken: pinToken,
    );
  }

  Future<void> topUp({
    required String goalId,
    required int amountKobo,
    required String pinToken,
    required String idempotencyKey,
  }) async {
    await _apiClient.post<void>(
      '/targets/$goalId/topups',
      data: {'amountKobo': amountKobo},
      idempotencyKey: idempotencyKey,
      pinToken: pinToken,
    );
  }

  String newIdempotencyKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
