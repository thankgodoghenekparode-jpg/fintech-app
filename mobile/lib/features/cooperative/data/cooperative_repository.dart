import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final cooperativeRepositoryProvider = Provider<CooperativeRepository>((ref) {
  return CooperativeRepository(
    apiClient: ref.watch(apiClientProvider),
  );
});

class CooperativeRepository {
  const CooperativeRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<void> create({
    required String name,
    required String type,
    required String description,
    required String meetingSchedule,
    required List<String> adminPhones,
  }) async {
    try {
      await _apiClient.post<void>(
        '/cooperatives',
        data: <String, Object>{
          'name': name,
          'type': type,
          'description': description,
          'meetingSchedule': meetingSchedule,
          'adminPhones': adminPhones,
        },
      );
    } on ApiRequestFailure catch (failure) {
      throw CooperativeRequestFailure(failure.code);
    }
  }
}

class CooperativeRequestFailure implements Exception {
  const CooperativeRequestFailure(this.code);

  final String code;
}
