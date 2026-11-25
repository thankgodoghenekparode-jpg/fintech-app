import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final paymentsRepositoryProvider = Provider.autoDispose<PaymentsRepository>(
  (ref) => PaymentsRepository(ref.watch(apiClientProvider)),
);

final beneficiariesProvider =
    FutureProvider.autoDispose<List<BeneficiarySummary>>(
  (ref) => ref.watch(paymentsRepositoryProvider).getBeneficiaries(),
);

final billCatalogProvider = FutureProvider.autoDispose<List<BillCategory>>(
  (ref) => ref.watch(paymentsRepositoryProvider).getBillCatalog(),
);

final savedBillersProvider = FutureProvider.autoDispose<List<SavedBiller>>(
  (ref) => ref.watch(paymentsRepositoryProvider).getSavedBillers(),
);

class PaymentsRepository {
  const PaymentsRepository(this._api);

  final ApiClient _api;

  Future<List<BeneficiarySummary>> getBeneficiaries() async {
    final response = await _api.dio.get<List<dynamic>>('beneficiaries');
    final data = response.data;
    if (data == null) throw const MalformedBeneficiaryDataException();
    return data.map((value) {
      if (value is! Map<String, dynamic>) {
        throw const MalformedBeneficiaryDataException();
      }
      return BeneficiarySummary.fromJson(value);
    }).toList(growable: false);
  }

  Future<void> deleteBeneficiary(String id) async {
    await _api.dio.delete<void>('beneficiaries/${Uri.encodeComponent(id)}');
  }

  Future<List<BillCategory>> getBillCatalog() async {
    final response = await _api.dio.get<List<dynamic>>('bills/categories');
    final data = response.data;
    if (data == null) throw const MalformedBillDataException();
    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const MalformedBillDataException();
      }
      return BillCategory.fromJson(item);
    }).toList(growable: false);
  }

  Future<List<SavedBiller>> getSavedBillers() async {
    final response = await _api.dio.get<List<dynamic>>('bills/saved');
    final data = response.data;
    if (data == null) throw const MalformedBillDataException();
    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const MalformedBillDataException();
      }
      return SavedBiller.fromJson(item);
    }).toList(growable: false);
  }

  Future<BillValidation> validateBillReference({
    required String billerCode,
    required String productCode,
    String? customerRef,
  }) async {
    return _validateBill({
      'billerCode': billerCode,
      'productCode': productCode,
      if (customerRef != null && customerRef.isNotEmpty)
        'customerRef': customerRef,
    });
  }

  Future<BillValidation> validateSavedBiller(String savedBillerId) =>
      _validateBill({'savedBillerId': savedBillerId});

  Future<BillValidation> _validateBill(Map<String, dynamic> request) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'bills/validate',
      data: request,
    );
    final data = response.data;
    if (data == null) throw const MalformedBillDataException();
    return BillValidation.fromJson(data);
  }

  Future<BillPaymentResult> payBill({
    required String validationId,
    required int amountKobo,
    required String pinToken,
    required String idempotencyKey,
    bool saveBiller = false,
    String? deliveryPhone,
  }) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'bills/pay',
      data: {
        'validationId': validationId,
        'amountKobo': amountKobo,
        'saveBiller': saveBiller,
        if (deliveryPhone != null && deliveryPhone.isNotEmpty)
          'deliveryPhone': deliveryPhone,
      },
      options: Options(headers: {
        'X-Pin-Token': pinToken,
        'Idempotency-Key': idempotencyKey,
      }),
    );
    final data = response.data;
    if (data == null) throw const MalformedBillDataException();
    return BillPaymentResult.fromJson(data);
  }
}

class BillCategory {
  const BillCategory({
    required this.code,
    required this.name,
    required this.description,
    required this.displayOrder,
    required this.billers,
  });

  final String code;
  final String name;
  final String description;
  final int displayOrder;
  final List<BillerCatalogEntry> billers;

  factory BillCategory.fromJson(Map<String, dynamic> json) {
    final billersJson = json['billers'];
    if (json['code'] is! String ||
        json['name'] is! String ||
        json['description'] is! String ||
        json['displayOrder'] is! int ||
        billersJson is! List) {
      throw const MalformedBillDataException();
    }
    return BillCategory(
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      displayOrder: json['displayOrder'] as int,
      billers: billersJson.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const MalformedBillDataException();
        }
        return BillerCatalogEntry.fromJson(item);
      }).toList(growable: false),
    );
  }
}

class BillerCatalogEntry {
  const BillerCatalogEntry({
    required this.code,
    required this.name,
    required this.categoryCode,
    required this.customerReferenceLabel,
    required this.products,
    this.description,
    this.customerReferencePattern,
  });

  final String code;
  final String name;
  final String categoryCode;
  final String customerReferenceLabel;
  final List<BillProduct> products;
  final String? description;
  final String? customerReferencePattern;

  factory BillerCatalogEntry.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'];
    if (json['code'] is! String ||
        json['name'] is! String ||
        json['categoryCode'] is! String ||
        json['customerReferenceLabel'] is! String ||
        productsJson is! List) {
      throw const MalformedBillDataException();
    }
    return BillerCatalogEntry(
      code: json['code'] as String,
      name: json['name'] as String,
      categoryCode: json['categoryCode'] as String,
      customerReferenceLabel: json['customerReferenceLabel'] as String,
      description: json['description'] as String?,
      customerReferencePattern: json['customerReferencePattern'] as String?,
      products: productsJson.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const MalformedBillDataException();
        }
        return BillProduct.fromJson(item);
      }).toList(growable: false),
    );
  }
}

class BillProduct {
  const BillProduct({
    required this.code,
    required this.name,
    required this.requiresCustomerReference,
    this.fixedAmountKobo,
    this.minimumAmountKobo,
    this.maximumAmountKobo,
  });

  final String code;
  final String name;
  final bool requiresCustomerReference;
  final int? fixedAmountKobo;
  final int? minimumAmountKobo;
  final int? maximumAmountKobo;

  factory BillProduct.fromJson(Map<String, dynamic> json) {
    if (json['code'] is! String ||
        json['name'] is! String ||
        json['requiresCustomerReference'] is! bool) {
      throw const MalformedBillDataException();
    }
    return BillProduct(
      code: json['code'] as String,
      name: json['name'] as String,
      requiresCustomerReference: json['requiresCustomerReference'] as bool,
      fixedAmountKobo: json['fixedAmountKobo'] as int?,
      minimumAmountKobo: json['minimumAmountKobo'] as int?,
      maximumAmountKobo: json['maximumAmountKobo'] as int?,
    );
  }
}

class SavedBiller {
  const SavedBiller({
    required this.id,
    required this.billerCode,
    required this.billerName,
    required this.categoryCode,
    required this.customerReferenceMasked,
    this.productCode,
    this.productName,
    this.customerReferenceSuffix,
  });

  final String id;
  final String billerCode;
  final String billerName;
  final String categoryCode;
  final String customerReferenceMasked;
  final String? productCode;
  final String? productName;
  final String? customerReferenceSuffix;

  factory SavedBiller.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! String ||
        json['billerCode'] is! String ||
        json['billerName'] is! String ||
        json['categoryCode'] is! String ||
        json['customerReferenceMasked'] is! String) {
      throw const MalformedBillDataException();
    }
    return SavedBiller(
      id: json['id'] as String,
      billerCode: json['billerCode'] as String,
      billerName: json['billerName'] as String,
      categoryCode: json['categoryCode'] as String,
      customerReferenceMasked: json['customerReferenceMasked'] as String,
      productCode: json['productCode'] as String?,
      productName: json['productName'] as String?,
      customerReferenceSuffix: json['customerReferenceSuffix'] as String?,
    );
  }
}

class BillValidation {
  const BillValidation({
    required this.validationId,
    required this.customerName,
    required this.billerName,
    required this.productName,
    required this.validatedAt,
    required this.expiresAt,
    this.fixedAmountKobo,
    this.minimumAmountKobo,
    this.maximumAmountKobo,
    this.feeKobo,
  });

  final String validationId;
  final String customerName;
  final String billerName;
  final String productName;
  final DateTime validatedAt;
  final DateTime expiresAt;
  final int? fixedAmountKobo;
  final int? minimumAmountKobo;
  final int? maximumAmountKobo;
  final int? feeKobo;

  factory BillValidation.fromJson(Map<String, dynamic> json) {
    final validatedAt = DateTime.tryParse(json['validatedAt'] as String? ?? '');
    final expiresAt = DateTime.tryParse(json['expiresAt'] as String? ?? '');
    if (json['validationId'] is! String ||
        json['customerName'] is! String ||
        json['billerName'] is! String ||
        json['productName'] is! String ||
        validatedAt == null ||
        expiresAt == null) {
      throw const MalformedBillDataException();
    }
    return BillValidation(
      validationId: json['validationId'] as String,
      customerName: json['customerName'] as String,
      billerName: json['billerName'] as String,
      productName: json['productName'] as String,
      validatedAt: validatedAt,
      expiresAt: expiresAt,
      fixedAmountKobo: json['fixedAmountKobo'] as int?,
      minimumAmountKobo: json['minimumAmountKobo'] as int?,
      maximumAmountKobo: json['maximumAmountKobo'] as int?,
      feeKobo: json['feeKobo'] as int?,
    );
  }
}

class BillPaymentResult {
  const BillPaymentResult({
    required this.transactionId,
    required this.transactionStatus,
    required this.vendStatus,
    required this.tokenDeliveryStatus,
    required this.refundStatus,
    this.reference,
    this.token,
    this.tokenType,
  });

  final String transactionId;
  final String transactionStatus;
  final String vendStatus;
  final String tokenDeliveryStatus;
  final String refundStatus;
  final String? reference;
  final String? token;
  final String? tokenType;

  factory BillPaymentResult.fromJson(Map<String, dynamic> json) {
    final transaction = json['transaction'];
    if (transaction is! Map<String, dynamic> ||
        transaction['id'] is! String ||
        transaction['status'] is! String ||
        json['vendStatus'] is! String ||
        json['tokenDeliveryStatus'] is! String ||
        json['refundStatus'] is! String) {
      throw const MalformedBillDataException();
    }
    return BillPaymentResult(
      transactionId: transaction['id'] as String,
      transactionStatus: transaction['status'] as String,
      reference: transaction['reference'] as String?,
      vendStatus: json['vendStatus'] as String,
      tokenDeliveryStatus: json['tokenDeliveryStatus'] as String,
      refundStatus: json['refundStatus'] as String,
      token: json['token'] as String?,
      tokenType: json['tokenType'] as String?,
    );
  }
}

class MalformedBillDataException implements Exception {
  const MalformedBillDataException();
}

class BeneficiarySummary {
  const BeneficiarySummary({
    this.id,
    this.bankCode,
    this.accountNumber,
    this.accountName,
    this.nickname,
    this.favourite = false,
  });

  final String? id;
  final String? bankCode;
  final String? accountNumber;
  final String? accountName;
  final String? nickname;
  final bool favourite;

  String get displayName => nickname?.trim().isNotEmpty == true
      ? nickname!.trim()
      : accountName ?? '';

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts
        .take(2)
        .map((part) => String.fromCharCode(part.runes.first))
        .join()
        .toUpperCase();
  }

  String get maskedAccountSuffix {
    final number = accountNumber ?? '';
    return number.length < 3
        ? '***'
        : '*** ${number.substring(number.length - 3)}';
  }

  factory BeneficiarySummary.fromJson(Map<String, dynamic> json) {
    final favourite = json['favourite'];
    if (favourite != null && favourite is! bool) {
      throw const MalformedBeneficiaryDataException();
    }
    return BeneficiarySummary(
      id: json['id'] as String?,
      bankCode: json['bankCode'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountName: json['accountName'] as String?,
      nickname: json['nickname'] as String?,
      favourite: favourite as bool? ?? false,
    );
  }
}

class MalformedBeneficiaryDataException implements Exception {
  const MalformedBeneficiaryDataException();
}
