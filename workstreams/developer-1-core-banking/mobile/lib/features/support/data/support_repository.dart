import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final supportRepositoryProvider = Provider.autoDispose<SupportRepository>(
  (ref) => SupportRepository(ref.watch(apiClientProvider)),
);

const supportTicketCategories = <String, String>{
  'TRANSFER': 'Transfers',
  'CARD': 'Cards',
  'ACCOUNT': 'Account',
  'BILL_PAYMENT': 'Bill payment',
  'SECURITY': 'Security',
  'OTHER': 'Other',
};

class SupportRepository {
  const SupportRepository(this._api);

  final ApiClient _api;

  Future<SupportTicketPage> getTickets({
    String? cursor,
    List<String>? statuses,
  }) async {
    final response = await _api.dio.get<Map<String, dynamic>>(
      'tickets',
      queryParameters: {
        'limit': 20,
        if (cursor != null) 'cursor': cursor,
        if (statuses != null && statuses.isNotEmpty) 'status': statuses,
      },
    );
    final data = response.data;
    if (data == null || data['items'] is! List) {
      throw const MalformedSupportDataException();
    }
    return SupportTicketPage(
      items: (data['items'] as List).map((item) {
        if (item is! Map<String, dynamic>) {
          throw const MalformedSupportDataException();
        }
        return SupportTicket.fromJson(item);
      }).toList(growable: false),
      nextCursor: data['nextCursor'] as String?,
    );
  }

  Future<SupportTicket> createTicket({
    required String category,
    required String description,
    String? issueType,
    String? transactionId,
  }) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'tickets',
      data: {
        'category': category,
        'description': description,
        if (issueType != null) 'issueType': issueType,
        if (transactionId != null && transactionId.isNotEmpty)
          'transactionId': transactionId,
      },
    );
    final data = response.data;
    if (data == null) throw const MalformedSupportDataException();
    return SupportTicket.fromJson(data);
  }

  Future<SupportTicketDetail> getTicket(String id) async {
    final response = await _api.dio.get<Map<String, dynamic>>(
      'tickets/${Uri.encodeComponent(id)}',
    );
    final data = response.data;
    if (data == null || data['messages'] is! List) {
      throw const MalformedSupportDataException();
    }
    return SupportTicketDetail.fromJson(data);
  }

  Future<SupportMessage> reply({
    required String ticketId,
    required String body,
  }) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'tickets/${Uri.encodeComponent(ticketId)}/messages',
      data: {'body': body},
    );
    final data = response.data;
    if (data == null) throw const MalformedSupportDataException();
    return SupportMessage.fromJson(data);
  }
}

class SupportTicketPage {
  const SupportTicketPage({required this.items, required this.nextCursor});

  final List<SupportTicket> items;
  final String? nextCursor;
}

class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.category,
    required this.subject,
    required this.status,
    this.issueType,
    required this.createdAt,
    required this.updatedAt,
    this.transactionId,
  });

  final String id;
  final String category;
  final String subject;
  final String status;
  final String? issueType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? transactionId;

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
    final updatedAt = DateTime.tryParse(json['updatedAt'] as String? ?? '');
    if (json['id'] is! String ||
        json['category'] is! String ||
        json['subject'] is! String ||
        json['status'] is! String ||
        createdAt == null ||
        updatedAt == null) {
      throw const MalformedSupportDataException();
    }
    return SupportTicket(
      id: json['id'] as String,
      category: json['category'] as String,
      subject: json['subject'] as String,
      status: json['status'] as String,
      issueType: json['issueType'] as String?,
      transactionId: json['transactionId'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class SupportTicketDetail extends SupportTicket {
  const SupportTicketDetail({
    required super.id,
    required super.category,
    required super.subject,
    required super.status,
    super.issueType,
    required super.createdAt,
    required super.updatedAt,
    required this.messages,
    super.transactionId,
  });

  final List<SupportMessage> messages;

  factory SupportTicketDetail.fromJson(Map<String, dynamic> json) {
    final ticket = SupportTicket.fromJson(json);
    final rawMessages = json['messages'];
    if (rawMessages is! List) throw const MalformedSupportDataException();
    return SupportTicketDetail(
      id: ticket.id,
      category: ticket.category,
      subject: ticket.subject,
      status: ticket.status,
      issueType: ticket.issueType,
      transactionId: ticket.transactionId,
      createdAt: ticket.createdAt,
      updatedAt: ticket.updatedAt,
      messages: rawMessages.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const MalformedSupportDataException();
        }
        return SupportMessage.fromJson(item);
      }).toList(growable: false),
    );
  }
}

class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.authorType,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String authorType;
  final String body;
  final DateTime createdAt;

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
    if (json['id'] is! String ||
        json['authorType'] is! String ||
        json['body'] is! String ||
        createdAt == null) {
      throw const MalformedSupportDataException();
    }
    return SupportMessage(
      id: json['id'] as String,
      authorType: json['authorType'] as String,
      body: json['body'] as String,
      createdAt: createdAt,
    );
  }
}

class MalformedSupportDataException implements Exception {
  const MalformedSupportDataException();
}
