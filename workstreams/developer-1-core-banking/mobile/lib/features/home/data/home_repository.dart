import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_client.dart';

final homeRepositoryProvider = Provider.autoDispose<HomeRepository>(
  (ref) => HomeRepository(ref.watch(apiClientProvider)),
);

final homeAccountProvider =
    FutureProvider.autoDispose<HomeResource<AccountSummary>>(
  (ref) => ref.watch(homeRepositoryProvider).getAccount(),
);

final recentTransactionsProvider =
    FutureProvider.autoDispose<HomeResource<List<TransactionSummary>>>(
  (ref) => ref.watch(homeRepositoryProvider).getRecentTransactions(),
);

final homeCardsProvider =
    FutureProvider.autoDispose<HomeResource<List<CardSummary>>>(
  (ref) => ref.watch(homeRepositoryProvider).getCards(),
);

final transactionDetailsProvider = FutureProvider.autoDispose
    .family<HomeResource<TransactionSummary>, String>(
        (ref, id) => ref.watch(homeRepositoryProvider).getTransaction(id));

final cardTransactionsProvider = FutureProvider.autoDispose
    .family<CardTransactionPage, String>(
        (ref, id) => ref.watch(homeRepositoryProvider).getCardTransactions(id));

class HomeResource<T> {
  const HomeResource({
    required this.data,
    required this.updatedAt,
    this.isStale = false,
  });

  final T data;
  final DateTime updatedAt;
  final bool isStale;

  HomeResource<T> stale() => HomeResource(
        data: data,
        updatedAt: updatedAt,
        isStale: true,
      );
}

class HomeRepository {
  HomeRepository(this._api);

  final ApiClient _api;
  HomeResource<AccountSummary>? _accountCache;
  HomeResource<List<TransactionSummary>>? _transactionsCache;
  HomeResource<List<CardSummary>>? _cardsCache;
  final Map<String, HomeResource<TransactionSummary>> _transactionCache = {};

  Future<HomeResource<AccountSummary>> getAccount() async {
    try {
      final response = await _api.dio.get<Map<String, dynamic>>('accounts/me');
      final data = response.data;
      if (data == null) throw const MalformedHomeDataException();
      final value = HomeResource(
        data: AccountSummary.fromJson(data),
        updatedAt: DateTime.now(),
      );
      _accountCache = value;
      return value;
    } catch (_) {
      final cached = _accountCache;
      if (cached != null) return cached.stale();
      rethrow;
    }
  }

  Future<HomeResource<List<TransactionSummary>>> getRecentTransactions() async {
    try {
      final response = await _api.dio.get<Map<String, dynamic>>(
        'accounts/me/transactions',
        queryParameters: const {'limit': 5},
      );
      final items = response.data?['items'];
      if (items is! List) throw const MalformedHomeDataException();
      final values = items
          .whereType<Map<String, dynamic>>()
          .map(TransactionSummary.fromJson)
          .toList(growable: false);
      final resource = HomeResource(
        data: values,
        updatedAt: DateTime.now(),
      );
      _transactionsCache = resource;
      for (final value in values) {
        _transactionCache[value.id] = HomeResource(
          data: value,
          updatedAt: resource.updatedAt,
        );
      }
      return resource;
    } catch (_) {
      final cached = _transactionsCache;
      if (cached != null) return cached.stale();
      rethrow;
    }
  }

  Future<TransactionPage> getTransactionPage({
    String? cursor,
    String? type,
    String? status,
    String? from,
    String? to,
    String? query,
  }) async {
    final parameters = <String, Object>{'limit': 20};
    if (cursor != null && cursor.isNotEmpty) parameters['cursor'] = cursor;
    if (type != null && type.isNotEmpty) parameters['type'] = type;
    if (status != null && status.isNotEmpty) parameters['status'] = status;
    if (from != null) parameters['from'] = from;
    if (to != null) parameters['to'] = to;
    if (query != null && query.trim().isNotEmpty) {
      parameters['q'] = query.trim();
    }
    final response = await _api.dio.get<Map<String, dynamic>>(
      'accounts/me/transactions',
      queryParameters: parameters,
    );
    final data = response.data;
    final items = data?['items'];
    if (data == null || items is! List) {
      throw const MalformedHomeDataException();
    }
    return TransactionPage(
      items: items
          .whereType<Map<String, dynamic>>()
          .map(TransactionSummary.fromJson)
          .toList(growable: false),
      nextCursor: data['nextCursor'] as String?,
    );
  }

  Future<HomeResource<List<CardSummary>>> getCards() async {
    try {
      final response = await _api.dio.get<List<dynamic>>('cards');
      final cards = response.data;
      if (cards == null) throw const MalformedHomeDataException();
      final values = cards
          .whereType<Map<String, dynamic>>()
          .map(CardSummary.fromJson)
          .toList(growable: false);
      final resource = HomeResource(
        data: values,
        updatedAt: DateTime.now(),
      );
      _cardsCache = resource;
      return resource;
    } catch (_) {
      final cached = _cardsCache;
      if (cached != null) return cached.stale();
      rethrow;
    }
  }

  Future<void> setCardFrozen(String id, {required bool frozen}) async {
    await _api.dio.post<void>(
      'cards/${Uri.encodeComponent(id)}/freeze',
      data: {'frozen': frozen},
    );
  }

  Future<CardSummary> updateCardLimits({
    required String id,
    required String pinToken,
    int? perTxnLimitKobo,
    int? dailyLimitKobo,
  }) async {
    final response = await _api.dio.put<Map<String, dynamic>>(
      'cards/${Uri.encodeComponent(id)}/limits',
      data: {
        if (perTxnLimitKobo != null) 'perTxnLimitKobo': perTxnLimitKobo,
        if (dailyLimitKobo != null) 'dailyLimitKobo': dailyLimitKobo,
      },
      options: Options(headers: {'X-Pin-Token': pinToken}),
    );
    final data = response.data;
    if (data == null) throw const MalformedHomeDataException();
    return CardSummary.fromJson(data);
  }

  Future<CardTransactionPage> getCardTransactions(
    String id, {
    int limit = 5,
    String? cursor,
  }) async {
    final response = await _api.dio.get<Map<String, dynamic>>(
      'cards/${Uri.encodeComponent(id)}/transactions',
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
    final data = response.data;
    final items = data?['items'];
    if (data == null || items is! List) {
      throw const MalformedHomeDataException();
    }
    return CardTransactionPage(
      items: items
          .whereType<Map<String, dynamic>>()
          .map(TransactionSummary.fromJson)
          .toList(growable: false),
      nextCursor: data['nextCursor'] as String?,
    );
  }

  Future<CardSettings> getCardSettings(String id) async {
    final response = await _api.dio.get<Map<String, dynamic>>(
      'cards/${Uri.encodeComponent(id)}/settings',
    );
    final data = response.data;
    if (data == null) throw const MalformedHomeDataException();
    return CardSettings.fromJson(data);
  }

  Future<CardSettings> updateCardSettings({
    required String id,
    required CardSettings settings,
  }) async {
    final response = await _api.dio.put<Map<String, dynamic>>(
      'cards/${Uri.encodeComponent(id)}/settings',
      data: settings.toJson(),
    );
    final data = response.data;
    if (data == null) throw const MalformedHomeDataException();
    return CardSettings.fromJson(data);
  }

  Future<CardSummary> updateCard({
    required String id,
    String? label,
    String? theme,
  }) async {
    final response = await _api.dio.patch<Map<String, dynamic>>(
      'cards/${Uri.encodeComponent(id)}',
      data: {
        if (label != null) 'label': label,
        if (theme != null) 'theme': theme,
      },
    );
    final data = response.data;
    if (data == null) throw const MalformedHomeDataException();
    return CardSummary.fromJson(data);
  }

  Future<void> deleteCard(
      {required String id, required String pinToken}) async {
    await _api.dio.delete<void>(
      'cards/${Uri.encodeComponent(id)}',
      options: Options(headers: {'X-Pin-Token': pinToken}),
    );
  }

  Future<String> verifyTransactionPin(String pin) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'auth/pin/verify',
      data: {'pin': pin},
    );
    final token = response.data?['pinToken'];
    if (token is! String || token.isEmpty) {
      throw const MalformedHomeDataException();
    }
    return token;
  }

  Future<CardSummary> createCard({
    required String label,
    required String theme,
    required String pinToken,
    required String idempotencyKey,
    int? dailyLimitKobo,
  }) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'cards',
      data: {
        'label': label,
        'theme': theme,
        if (dailyLimitKobo != null) 'dailyLimitKobo': dailyLimitKobo,
      },
      options: Options(
        headers: {
          'X-Pin-Token': pinToken,
          'Idempotency-Key': idempotencyKey,
        },
      ),
    );
    final data = response.data;
    if (data == null) throw const MalformedHomeDataException();
    return CardSummary.fromJson(data);
  }

  Future<CardDetails> revealCardDetails({
    required String id,
    required String pinToken,
  }) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'cards/${Uri.encodeComponent(id)}/details',
      options: Options(headers: {'X-Pin-Token': pinToken}),
    );
    final data = response.data;
    if (data == null) throw const MalformedHomeDataException();
    return CardDetails.fromJson(data);
  }

  Future<HomeResource<TransactionSummary>> getTransaction(String id) async {
    try {
      final response = await _api.dio.get<Map<String, dynamic>>(
        'transactions/${Uri.encodeComponent(id)}',
      );
      final data = response.data;
      if (data == null) throw const MalformedHomeDataException();
      final resource = HomeResource(
        data: TransactionSummary.fromJson(data),
        updatedAt: DateTime.now(),
      );
      _transactionCache[id] = resource;
      return resource;
    } catch (_) {
      final cached = _transactionCache[id];
      if (cached != null) return cached.stale();
      rethrow;
    }
  }
}

class TransactionPage {
  const TransactionPage({required this.items, required this.nextCursor});

  final List<TransactionSummary> items;
  final String? nextCursor;
}

class CardTransactionPage {
  const CardTransactionPage({required this.items, required this.nextCursor});

  final List<TransactionSummary> items;
  final String? nextCursor;
}

class CardSettings {
  const CardSettings({
    required this.pushAlerts,
    required this.smsAlerts,
    required this.onlinePurchases,
    this.internationalPurchases,
  });

  final bool pushAlerts;
  final bool smsAlerts;
  final bool onlinePurchases;
  final bool? internationalPurchases;

  CardSettings copyWith({
    bool? pushAlerts,
    bool? smsAlerts,
    bool? onlinePurchases,
    bool? internationalPurchases,
  }) =>
      CardSettings(
        pushAlerts: pushAlerts ?? this.pushAlerts,
        smsAlerts: smsAlerts ?? this.smsAlerts,
        onlinePurchases: onlinePurchases ?? this.onlinePurchases,
        internationalPurchases:
            internationalPurchases ?? this.internationalPurchases,
      );

  Map<String, dynamic> toJson() => {
        'pushAlerts': pushAlerts,
        'smsAlerts': smsAlerts,
        'onlinePurchases': onlinePurchases,
        if (internationalPurchases != null)
          'internationalPurchases': internationalPurchases,
      };

  factory CardSettings.fromJson(Map<String, dynamic> json) {
    final pushAlerts = json['pushAlerts'];
    final smsAlerts = json['smsAlerts'];
    final onlinePurchases = json['onlinePurchases'];
    final internationalPurchases = json['internationalPurchases'];
    if (pushAlerts is! bool ||
        smsAlerts is! bool ||
        onlinePurchases is! bool ||
        (internationalPurchases != null && internationalPurchases is! bool)) {
      throw const MalformedHomeDataException();
    }
    return CardSettings(
      pushAlerts: pushAlerts,
      smsAlerts: smsAlerts,
      onlinePurchases: onlinePurchases,
      internationalPurchases: internationalPurchases as bool?,
    );
  }
}

class AccountSummary {
  const AccountSummary({
    required this.accountNumber,
    required this.accountName,
    required this.status,
    required this.currency,
    required this.tier,
    this.perTxnLimitKobo,
    this.dailyOutLimitKobo,
    this.dailyUsedKobo,
    required this.ledgerBalanceKobo,
    required this.availableBalanceKobo,
    required this.balanceCapKobo,
  });

  final String? accountNumber;
  final String? accountName;
  final String? status;
  final String? currency;
  final int? tier;
  final int? perTxnLimitKobo;
  final int? dailyOutLimitKobo;
  final int? dailyUsedKobo;
  final int? ledgerBalanceKobo;
  final int? availableBalanceKobo;
  final int? balanceCapKobo;

  factory AccountSummary.fromJson(Map<String, dynamic> json) => AccountSummary(
        accountNumber: json['accountNumber'] as String?,
        accountName: json['accountName'] as String?,
        status: json['status'] as String?,
        currency: json['currency'] as String?,
        tier: _intValue(json['tier']),
        perTxnLimitKobo:
            _intValue((json['limits'] as Map<String, dynamic>?)?['perTxnKobo']),
        dailyOutLimitKobo: _intValue(
            (json['limits'] as Map<String, dynamic>?)?['dailyOutKobo']),
        dailyUsedKobo: _intValue(
            (json['limits'] as Map<String, dynamic>?)?['dailyUsedKobo']),
        ledgerBalanceKobo: _intValue(json['ledgerBalanceKobo']),
        availableBalanceKobo: _intValue(json['availableBalanceKobo']),
        balanceCapKobo: _intValue(
          (json['limits'] as Map<String, dynamic>?)?['balanceCapKobo'],
        ),
      );
}

class TransactionSummary {
  const TransactionSummary({
    required this.id,
    required this.type,
    required this.direction,
    required this.amountKobo,
    required this.feeKobo,
    required this.reference,
    required this.balanceAfterKobo,
    required this.status,
    required this.failureCode,
    required this.counterpartyName,
    required this.counterpartyBank,
    required this.narration,
    required this.createdAt,
  });

  final String id;
  final String? type;
  final String? direction;
  final int? amountKobo;
  final int? feeKobo;
  final String? reference;
  final int? balanceAfterKobo;
  final String? status;
  final String? failureCode;
  final String? counterpartyName;
  final String? counterpartyBank;
  final String? narration;
  final DateTime? createdAt;

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      TransactionSummary(
        id: json['id'] as String? ?? '',
        type: json['type'] as String?,
        direction: json['direction'] as String?,
        amountKobo: _intValue(json['amountKobo']),
        feeKobo: _intValue(json['feeKobo']),
        reference: json['reference'] as String?,
        balanceAfterKobo: _intValue(json['balanceAfterKobo']),
        status: json['status'] as String?,
        failureCode: json['failureCode'] as String?,
        counterpartyName: json['counterpartyName'] as String?,
        counterpartyBank: json['counterpartyBank'] as String?,
        narration: json['narration'] as String?,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      );

  String get subtitle => [
        _nonEmpty(counterpartyBank),
        _nonEmpty(narration),
        if (createdAt != null)
          DateFormat('d MMM · h:mm a').format(createdAt!.toLocal()),
      ].whereType<String>().join(' · ');
}

class CardSummary {
  const CardSummary({
    required this.id,
    required this.label,
    required this.theme,
    required this.last4,
    required this.status,
    this.perTxnLimitKobo,
    this.dailyLimitKobo,
  });

  final String id;
  final String? label;
  final String? theme;
  final String? last4;
  final String? status;
  final int? perTxnLimitKobo;
  final int? dailyLimitKobo;

  factory CardSummary.fromJson(Map<String, dynamic> json) => CardSummary(
        id: json['id'] as String? ?? '',
        label: json['label'] as String?,
        theme: json['theme'] as String?,
        last4: json['last4'] as String?,
        status: json['status'] as String?,
        perTxnLimitKobo: _intValue(json['perTxnLimitKobo']),
        dailyLimitKobo: _intValue(json['dailyLimitKobo']),
      );
}

class CardDetails {
  const CardDetails(
      {required this.number, required this.expiry, required this.cvv});

  final String? number;
  final String? expiry;
  final String? cvv;

  factory CardDetails.fromJson(Map<String, dynamic> json) => CardDetails(
        number: json['number'] as String?,
        expiry: json['expiry'] as String?,
        cvv: json['cvv'] as String?,
      );
}

class MalformedHomeDataException implements Exception {
  const MalformedHomeDataException();
}

int? _intValue(Object? value) => value is num ? value.toInt() : null;

String? _nonEmpty(String? value) =>
    value == null || value.trim().isEmpty ? null : value.trim();
