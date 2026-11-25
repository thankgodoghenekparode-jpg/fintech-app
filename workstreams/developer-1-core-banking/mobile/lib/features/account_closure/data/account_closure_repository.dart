import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final accountClosureRepositoryProvider =
    Provider.autoDispose<AccountClosureRepository>(
  (ref) => AccountClosureRepository(ref.watch(apiClientProvider)),
);

final closureEligibilityProvider =
    FutureProvider.autoDispose<ClosureEligibility>(
  (ref) => ref.watch(accountClosureRepositoryProvider).getEligibility(),
);

class AccountClosureRepository {
  const AccountClosureRepository(this._client);

  final ApiClient _client;

  Future<ClosureEligibility> getEligibility() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      'accounts/me/closure-eligibility',
    );
    return ClosureEligibility.fromJson(response.data);
  }

  Future<ClosureRequest> submitRequest({
    required String reason,
    String? feedback,
    required String pinToken,
    required String idempotencyKey,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      'accounts/me/closure-requests',
      data: {
        'reason': reason,
        if (feedback != null && feedback.trim().isNotEmpty)
          'feedback': feedback.trim(),
      },
      options: Options(headers: {
        'X-Pin-Token': pinToken,
        'Idempotency-Key': idempotencyKey,
      }),
    );
    return ClosureRequest.fromJson(response.data);
  }
}

class ClosureEligibility {
  const ClosureEligibility({
    required this.eligible,
    required this.checkedAt,
    required this.blockers,
  });

  final bool eligible;
  final DateTime checkedAt;
  final List<ClosureBlocker> blockers;

  factory ClosureEligibility.fromJson(Map<String, dynamic>? json) {
    final eligible = json?['eligible'];
    final checkedAt = json?['checkedAt'];
    final blockers = json?['blockers'];
    final date = checkedAt is String ? DateTime.tryParse(checkedAt) : null;
    if (eligible is! bool ||
        date == null ||
        blockers is! List ||
        blockers.any((item) => item is! Map<String, dynamic>)) {
      throw const FormatException('Closure eligibility response is malformed.');
    }
    return ClosureEligibility(
      eligible: eligible,
      checkedAt: date,
      blockers: blockers
          .cast<Map<String, dynamic>>()
          .map(ClosureBlocker.fromJson)
          .toList(growable: false),
    );
  }
}

class ClosureBlocker {
  const ClosureBlocker({
    required this.code,
    required this.title,
    required this.detail,
    this.actionLabel,
    this.actionRoute,
  });

  final String code;
  final String title;
  final String detail;
  final String? actionLabel;
  final String? actionRoute;

  factory ClosureBlocker.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final title = json['title'];
    final detail = json['detail'];
    final actionLabel = json['actionLabel'];
    final actionRoute = json['actionRoute'];
    if (code is! String ||
        title is! String ||
        detail is! String ||
        (actionLabel != null && actionLabel is! String) ||
        (actionRoute != null && actionRoute is! String)) {
      throw const FormatException('Closure blocker is malformed.');
    }
    return ClosureBlocker(
      code: code,
      title: title,
      detail: detail,
      actionLabel: actionLabel as String?,
      actionRoute: actionRoute as String?,
    );
  }
}

class ClosureRequest {
  const ClosureRequest({
    required this.requestId,
    required this.status,
    required this.createdAt,
    required this.blockers,
  });

  final String requestId;
  final String status;
  final DateTime createdAt;
  final List<ClosureBlocker> blockers;

  factory ClosureRequest.fromJson(Map<String, dynamic>? json) {
    final id = json?['requestId'];
    final status = json?['status'];
    final createdAt = json?['createdAt'];
    final blockers = json?['blockers'];
    final date = createdAt is String ? DateTime.tryParse(createdAt) : null;
    if (id is! String ||
        id.isEmpty ||
        !const {'PENDING_REVIEW', 'BLOCKED'}.contains(status) ||
        date == null ||
        blockers is! List ||
        blockers.any((item) => item is! Map<String, dynamic>)) {
      throw const FormatException('Closure request response is malformed.');
    }
    return ClosureRequest(
      requestId: id,
      status: status as String,
      createdAt: date,
      blockers: blockers
          .cast<Map<String, dynamic>>()
          .map(ClosureBlocker.fromJson)
          .toList(growable: false),
    );
  }
}
