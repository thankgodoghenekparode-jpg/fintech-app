import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final ajoRepositoryProvider = Provider<AjoRepository>(
  (ref) => AjoRepository(ref.watch(apiClientProvider)),
);

class AjoRepository {
  const AjoRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> createCircle({
    required String name,
    required int amountKobo,
    required String frequency,
    required int slots,
    required String startDate,
    required String orderMethod,
    required String protectionMode,
  }) async {
    await _apiClient.post<void>(
      '/ajo/circles',
      data: <String, Object>{
        'name': name,
        'amountKobo': amountKobo,
        'frequency': frequency,
        'slots': slots,
        'startDate': startDate,
        'orderMethod': orderMethod,
        'protectionMode': protectionMode,
      },
    );
  }
}
