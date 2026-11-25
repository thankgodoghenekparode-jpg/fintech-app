import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final statementsRepositoryProvider = Provider<StatementsRepository>(
  (ref) => StatementsRepository(ref.watch(apiClientProvider)),
);

final statementArchiveProvider =
    FutureProvider.autoDispose<StatementArchive>((ref) {
  return ref.watch(statementsRepositoryProvider).getArchive();
});

class StatementsRepository {
  StatementsRepository(this._api);

  final ApiClient _api;

  Future<StatementArchive> getArchive() async {
    final response = await _api.dio.get<Map<String, dynamic>>(
      'accounts/me/statements',
    );
    final data = response.data;
    if (data == null) throw const MalformedStatementDataException();
    return StatementArchive.fromJson(data);
  }

  Future<StatementRequest> requestStatement({
    required DateTime fromDate,
    required DateTime toDate,
    required StatementDeliveryMethod deliveryMethod,
    required String idempotencyKey,
  }) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'accounts/me/statements',
      data: {
        'fromDate': _dateOnly(fromDate),
        'toDate': _dateOnly(toDate),
        'format': 'PDF',
        'deliveryMethod': deliveryMethod.apiValue,
      },
      options: Options(headers: {'Idempotency-Key': idempotencyKey}),
    );
    final data = response.data;
    if (data == null) throw const MalformedStatementDataException();
    return StatementRequest.fromJson(data);
  }

  Future<Uint8List> downloadStatement(String requestId) async {
    final response = await _api.dio.get<List<int>>(
      'accounts/me/statements/${Uri.encodeComponent(requestId)}/download',
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw const MalformedStatementDataException();
    }
    return Uint8List.fromList(bytes);
  }
}

String _dateOnly(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

class StatementArchive {
  const StatementArchive({
    required this.items,
    required this.maximumRangeDays,
    required this.emailDeliveryAvailable,
    required this.registeredEmailMasked,
  });

  final List<StatementRequest> items;
  final int maximumRangeDays;
  final bool emailDeliveryAvailable;
  final String? registeredEmailMasked;

  factory StatementArchive.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    final maximumRangeDays = json['maximumRangeDays'];
    final emailDeliveryAvailable = json['emailDeliveryAvailable'];
    if (items is! List ||
        items.any((item) => item is! Map<String, dynamic>) ||
        maximumRangeDays is! int ||
        maximumRangeDays < 1 ||
        emailDeliveryAvailable is! bool) {
      throw const MalformedStatementDataException();
    }
    final email = json['registeredEmailMasked'];
    if ((email != null && email is! String) ||
        (emailDeliveryAvailable && (email is! String || email.isEmpty))) {
      throw const MalformedStatementDataException();
    }
    return StatementArchive(
      items: items
          .cast<Map<String, dynamic>>()
          .map(StatementRequest.fromJson)
          .toList(growable: false),
      maximumRangeDays: maximumRangeDays,
      emailDeliveryAvailable: emailDeliveryAvailable,
      registeredEmailMasked: email as String?,
    );
  }
}

enum StatementDeliveryMethod {
  download('DOWNLOAD'),
  email('EMAIL');

  const StatementDeliveryMethod(this.apiValue);
  final String apiValue;
}

enum StatementStatus { queued, generating, ready, failed }

enum StatementDeliveryStatus { notApplicable, pending, sent, failed }

class StatementRequest {
  const StatementRequest({
    required this.requestId,
    required this.fromDate,
    required this.toDate,
    required this.deliveryMethod,
    required this.status,
    required this.deliveryStatus,
    required this.createdAt,
    this.completedAt,
    this.failureCode,
  });

  final String requestId;
  final DateTime fromDate;
  final DateTime toDate;
  final StatementDeliveryMethod deliveryMethod;
  final StatementStatus status;
  final StatementDeliveryStatus deliveryStatus;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureCode;

  factory StatementRequest.fromJson(Map<String, dynamic> json) {
    final deliveryMethod = switch (json['deliveryMethod']) {
      'DOWNLOAD' => StatementDeliveryMethod.download,
      'EMAIL' => StatementDeliveryMethod.email,
      _ => null,
    };
    final status = switch (json['status']) {
      'QUEUED' => StatementStatus.queued,
      'GENERATING' => StatementStatus.generating,
      'READY' => StatementStatus.ready,
      'FAILED' => StatementStatus.failed,
      _ => null,
    };
    final deliveryStatus = switch (json['deliveryStatus']) {
      'NOT_APPLICABLE' => StatementDeliveryStatus.notApplicable,
      'PENDING' => StatementDeliveryStatus.pending,
      'SENT' => StatementDeliveryStatus.sent,
      'FAILED' => StatementDeliveryStatus.failed,
      _ => null,
    };
    final requestId = json['requestId'];
    final fromValue = json['fromDate'];
    final toValue = json['toDate'];
    final createdValue = json['createdAt'];
    final fromDate = fromValue is String ? DateTime.tryParse(fromValue) : null;
    final toDate = toValue is String ? DateTime.tryParse(toValue) : null;
    final createdAt =
        createdValue is String ? DateTime.tryParse(createdValue) : null;
    final completedAtValue = json['completedAt'];
    final completedAt = completedAtValue == null
        ? null
        : completedAtValue is String
            ? DateTime.tryParse(completedAtValue)
            : null;
    final failureCode = json['failureCode'];
    if (requestId is! String ||
        fromDate == null ||
        toDate == null ||
        toDate.isBefore(fromDate) ||
        createdAt == null ||
        (completedAtValue != null && completedAt == null) ||
        (failureCode != null && failureCode is! String) ||
        json['format'] != 'PDF' ||
        deliveryMethod == null ||
        status == null ||
        deliveryStatus == null) {
      throw const MalformedStatementDataException();
    }
    return StatementRequest(
      requestId: requestId,
      fromDate: fromDate,
      toDate: toDate,
      deliveryMethod: deliveryMethod,
      status: status,
      deliveryStatus: deliveryStatus,
      createdAt: createdAt,
      completedAt: completedAt,
      failureCode: failureCode as String?,
    );
  }
}

class MalformedStatementDataException implements Exception {
  const MalformedStatementDataException();
}
