import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/app_constants.dart';

part 'purchase.freezed.dart';
part 'purchase.g.dart';

@freezed
class Purchase with _$Purchase {
  const factory Purchase({
    required String id,
    required String purchaseNumber,
    required String supplierId,
    required String supplierName,
    required List<PurchaseItem> items,
    required double subtotal,
    required double taxAmount,
    required double discountAmount,
    required double totalAmount,
    required PurchaseStatus status,
    required DateTime orderDate,
    DateTime? expectedDeliveryDate,
    DateTime? receivedDate,
    String? notes,
    String? invoiceNumber,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Purchase;

  factory Purchase.fromJson(Map<String, dynamic> json) => _$PurchaseFromJson(json);
}

@freezed
class PurchaseItem with _$PurchaseItem {
  const factory PurchaseItem({
    required String id,
    required String purchaseId,
    required String productId,
    required String productName,
    required String sku,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    int? receivedQuantity,
    String? notes,
  }) = _PurchaseItem;

  factory PurchaseItem.fromJson(Map<String, dynamic> json) => _$PurchaseItemFromJson(json);
}

@freezed
class PurchaseCreateRequest with _$PurchaseCreateRequest {
  const factory PurchaseCreateRequest({
    required String supplierId,
    required List<PurchaseItemRequest> items,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) = _PurchaseCreateRequest;

  factory PurchaseCreateRequest.fromJson(Map<String, dynamic> json) => _$PurchaseCreateRequestFromJson(json);
}

@freezed
class PurchaseItemRequest with _$PurchaseItemRequest {
  const factory PurchaseItemRequest({
    required String productId,
    required int quantity,
    required double unitPrice,
    String? notes,
  }) = _PurchaseItemRequest;

  factory PurchaseItemRequest.fromJson(Map<String, dynamic> json) => _$PurchaseItemRequestFromJson(json);
}

@freezed
class PurchaseUpdateRequest with _$PurchaseUpdateRequest {
  const factory PurchaseUpdateRequest({
    PurchaseStatus? status,
    DateTime? expectedDeliveryDate,
    DateTime? receivedDate,
    String? notes,
    String? invoiceNumber,
  }) = _PurchaseUpdateRequest;

  factory PurchaseUpdateRequest.fromJson(Map<String, dynamic> json) => _$PurchaseUpdateRequestFromJson(json);
}

@freezed
class PurchaseListParams with _$PurchaseListParams {
  const factory PurchaseListParams({
    int? page,
    int? limit,
    String? search,
    String? supplierId,
    PurchaseStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    String? sortBy,
    bool? sortDesc,
  }) = _PurchaseListParams;

  factory PurchaseListParams.fromJson(Map<String, dynamic> json) => _$PurchaseListParamsFromJson(json);
}

@freezed
class PurchaseListResponse with _$PurchaseListResponse {
  const factory PurchaseListResponse({
    required List<Purchase> purchases,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _PurchaseListResponse;

  factory PurchaseListResponse.fromJson(Map<String, dynamic> json) => _$PurchaseListResponseFromJson(json);
}

@freezed
class PurchaseStats with _$PurchaseStats {
  const factory PurchaseStats({
    required int totalOrders,
    required double totalAmount,
    required int pendingOrders,
    required int receivedOrders,
    required double thisMonthAmount,
    required double lastMonthAmount,
    required List<MonthlyPurchaseData> monthlyData,
    required List<SupplierPurchaseData> supplierData,
  }) = _PurchaseStats;

  factory PurchaseStats.fromJson(Map<String, dynamic> json) => _$PurchaseStatsFromJson(json);
}

@freezed
class MonthlyPurchaseData with _$MonthlyPurchaseData {
  const factory MonthlyPurchaseData({
    required String month,
    required double amount,
    required int count,
  }) = _MonthlyPurchaseData;

  factory MonthlyPurchaseData.fromJson(Map<String, dynamic> json) => _$MonthlyPurchaseDataFromJson(json);
}

@freezed
class SupplierPurchaseData with _$SupplierPurchaseData {
  const factory SupplierPurchaseData({
    required String supplierId,
    required String supplierName,
    required double totalAmount,
    required int orderCount,
  }) = _SupplierPurchaseData;

  factory SupplierPurchaseData.fromJson(Map<String, dynamic> json) => _$SupplierPurchaseDataFromJson(json);
}