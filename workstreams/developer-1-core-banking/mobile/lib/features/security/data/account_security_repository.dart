import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final accountSecurityRepositoryProvider =
    Provider.autoDispose<AccountSecurityRepository>(
  (ref) => AccountSecurityRepository(ref.watch(apiClientProvider)),
);

class AccountSecurityRepository {
  const AccountSecurityRepository(this._client);

  final ApiClient _client;

  /// Locks the signed-in customer's account using the one-use PIN token.
  /// The approved contract specifies no request body or success payload.
  Future<void> lockOwnAccount({required String pinToken}) async {
    await _client.dio.post<void>(
      'security/lock',
      options: Options(headers: {'X-Pin-Token': pinToken}),
    );
  }
}
