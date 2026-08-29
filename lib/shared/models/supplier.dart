import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/app_constants.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@freezed
class Supplier with _$Supplier {
  const factory Supplier({
    required String id,
    required String companyName,
    required String contactPerson,
    required String phone,
    required String email,
    required String address,
    String? gstNumber,
    String? panNumber,
    String? bankAccount,
    String? ifscCode,
    double? totalPurchases,
    double? pendingPayments,
    int? productsSupplied,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
}

@freezed
class SupplierCreateRequest with _$SupplierCreateRequest {
  const factory SupplierCreateRequest({
    required String companyName,
    required String contactPerson,
    required String phone,
    required String email,
    required String address,
    String? gstNumber,
    String? panNumber,
    String? bankAccount,
    String? ifscCode,
  }) = _SupplierCreateRequest;

  factory SupplierCreateRequest.fromJson(Map<String, dynamic> json) => _$SupplierCreateRequestFromJson(json);
}

@freezed
class SupplierUpdateRequest with _$SupplierUpdateRequest {
  const factory SupplierUpdateRequest({
    String? companyName,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    String? gstNumber,
    String? panNumber,
    String? bankAccount,
    String? ifscCode,
  }) = _SupplierUpdateRequest;

  factory SupplierUpdateRequest.fromJson(Map<String, dynamic> json) => _$SupplierUpdateRequestFromJson(json);
}

@freezed
class SupplierListParams with _$SupplierListParams {
  const factory SupplierListParams({
    int? page,
    int? limit,
    String? search,
    String? sortBy,
    bool? sortDesc,
  }) = _SupplierListParams;

  factory SupplierListParams.fromJson(Map<String, dynamic> json) => _$SupplierListParamsFromJson(json);
}

@freezed
class SupplierListResponse with _$SupplierListResponse {
  const factory SupplierListResponse({
    required List<Supplier> suppliers,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _SupplierListResponse;

  factory SupplierListResponse.fromJson(Map<String, dynamic> json) => _$SupplierListResponseFromJson(json);
}

@freezed
class SupplierDetail with _$SupplierDetail {
  const factory SupplierDetail({
    required Supplier supplier,
    required List<PurchaseSummary> recentPurchases,
    required List<SupplierProduct> productsSupplied,
    required double totalPurchases,
    required double pendingPayments,
    required int totalProducts,
  }) = _SupplierDetail;

  factory SupplierDetail.fromJson(Map<String, dynamic> json) => _$SupplierDetailFromJson(json);
}

@freezed
class PurchaseSummary with _$PurchaseSummary {
  const factory PurchaseSummary({
    required String id,
    required String purchaseNumber,
    required DateTime date,
    required double totalAmount,
    required PurchaseStatus status,
    int? itemCount,
  }) = _PurchaseSummary;

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) => _$PurchaseSummaryFromJson(json);
}

@freezed
class SupplierProduct with _$SupplierProduct {
  const factory SupplierProduct({
    required String productId,
    required String productName,
    required String sku,
    required int currentStock,
    required double purchasePrice,
    DateTime? lastPurchaseDate,
    int? totalPurchased,
  }) = _SupplierProduct;

  factory SupplierProduct.fromJson(Map<String, dynamic> json) => _$SupplierProductFromJson(json);
}