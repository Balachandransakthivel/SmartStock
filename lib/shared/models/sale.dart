import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/app_constants.dart';

part 'sale.freezed.dart';
part 'sale.g.dart';

@freezed
class Sale with _$Sale {
  const factory Sale({
    required String id,
    required String saleNumber,
    String? customerId,
    String? customerName,
    String? customerPhone,
    required List<SaleItem> items,
    required double subtotal,
    required double taxAmount,
    required double discountAmount,
    required double totalAmount,
    required PaymentMethod paymentMethod,
    required DateTime saleDate,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class SaleItem with _$SaleItem {
  const factory SaleItem({
    required String id,
    required String saleId,
    required String productId,
    required String productName,
    required String sku,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
  }) = _SaleItem;

  factory SaleItem.fromJson(Map<String, dynamic> json) => _$SaleItemFromJson(json);
}

@freezed
class SaleCreateRequest with _$SaleCreateRequest {
  const factory SaleCreateRequest({
    String? customerId,
    String? customerName,
    String? customerPhone,
    required List<SaleItemRequest> items,
    required PaymentMethod paymentMethod,
    String? notes,
  }) = _SaleCreateRequest;

  factory SaleCreateRequest.fromJson(Map<String, dynamic> json) => _$SaleCreateRequestFromJson(json);
}

@freezed
class SaleItemRequest with _$SaleItemRequest {
  const factory SaleItemRequest({
    required String productId,
    required int quantity,
    required double unitPrice,
  }) = _SaleItemRequest;

  factory SaleItemRequest.fromJson(Map<String, dynamic> json) => _$SaleItemRequestFromJson(json);
}

@freezed
class SaleListParams with _$SaleListParams {
  const factory SaleListParams({
    int? page,
    int? limit,
    String? search,
    String? customerId,
    PaymentMethod? paymentMethod,
    DateTime? fromDate,
    DateTime? toDate,
    String? sortBy,
    bool? sortDesc,
  }) = _SaleListParams;

  factory SaleListParams.fromJson(Map<String, dynamic> json) => _$SaleListParamsFromJson(json);
}

@freezed
class SaleListResponse with _$SaleListResponse {
  const factory SaleListResponse({
    required List<Sale> sales,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _SaleListResponse;

  factory SaleListResponse.fromJson(Map<String, dynamic> json) => _$SaleListResponseFromJson(json);
}

@freezed
class SaleStats with _$SaleStats {
  const factory SaleStats({
    required int totalSales,
    required double totalRevenue,
    required int todaySales,
    required double todayRevenue,
    required int thisMonthSales,
    required double thisMonthRevenue,
    required double lastMonthRevenue,
    required List<DailySalesData> dailyData,
    required List<TopProductData> topProducts,
    required List<PaymentMethodData> paymentMethods,
  }) = _SaleStats;

  factory SaleStats.fromJson(Map<String, dynamic> json) => _$SaleStatsFromJson(json);
}

@freezed
class DailySalesData with _$DailySalesData {
  const factory DailySalesData({
    required String date,
    required double revenue,
    required int count,
  }) = _DailySalesData;

  factory DailySalesData.fromJson(Map<String, dynamic> json) => _$DailySalesDataFromJson(json);
}

@freezed
class TopProductData with _$TopProductData {
  const factory TopProductData({
    required String productId,
    required String productName,
    required String sku,
    required int quantitySold,
    required double revenue,
  }) = _TopProductData;

  factory TopProductData.fromJson(Map<String, dynamic> json) => _$TopProductDataFromJson(json);
}

@freezed
class PaymentMethodData with _$PaymentMethodData {
  const factory PaymentMethodData({
    required PaymentMethod method,
    required double amount,
    required int count,
  }) = _PaymentMethodData;

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) => _$PaymentMethodDataFromJson(json);
}