import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/app_constants.dart';

part 'stock_movement.freezed.dart';
part 'stock_movement.g.dart';

@freezed
class StockMovement with _$StockMovement {
  const factory StockMovement({
    required String id,
    required String productId,
    required String productName,
    required String sku,
    required StockMovementType type,
    required int quantity,
    required int previousStock,
    required int newStock,
    StockOutReason? reason,
    String? referenceId,
    String? referenceType,
    String? supplierId,
    String? supplierName,
    String? customerId,
    String? customerName,
    double? unitPrice,
    double? totalAmount,
    String? notes,
    String? performedBy,
    String? performedByName,
    required DateTime createdAt,
  }) = _StockMovement;

  factory StockMovement.fromJson(Map<String, dynamic> json) => _$StockMovementFromJson(json);
}

@freezed
class StockInRequest with _$StockInRequest {
  const factory StockInRequest({
    required String productId,
    required int quantity,
    required String supplierId,
    required double purchasePrice,
    String? invoiceNumber,
    DateTime? date,
    String? notes,
  }) = _StockInRequest;

  factory StockInRequest.fromJson(Map<String, dynamic> json) => _$StockInRequestFromJson(json);
}

@freezed
class StockOutRequest with _$StockOutRequest {
  const factory StockOutRequest({
    required String productId,
    required int quantity,
    required StockOutReason reason,
    String? customerId,
    String? customerName,
    DateTime? date,
    String? notes,
  }) = _StockOutRequest;

  factory StockOutRequest.fromJson(Map<String, dynamic> json) => _$StockOutRequestFromJson(json);
}

@freezed
class StockMovementListParams with _$StockMovementListParams {
  const factory StockMovementListParams({
    int? page,
    int? limit,
    String? productId,
    StockMovementType? type,
    DateTime? fromDate,
    DateTime? toDate,
    String? sortBy,
    bool? sortDesc,
  }) = _StockMovementListParams;

  factory StockMovementListParams.fromJson(Map<String, dynamic> json) => _$StockMovementListParamsFromJson(json);
}

@freezed
class StockMovementListResponse with _$StockMovementListResponse {
  const factory StockMovementListResponse({
    required List<StockMovement> movements,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _StockMovementListResponse;

  factory StockMovementListResponse.fromJson(Map<String, dynamic> json) => _$StockMovementListResponseFromJson(json);
}

@freezed
class StockAdjustmentRequest with _$StockAdjustmentRequest {
  const factory StockAdjustmentRequest({
    required String productId,
    required int newQuantity,
    required String reason,
  }) = _StockAdjustmentRequest;

  factory StockAdjustmentRequest.fromJson(Map<String, dynamic> json) => _$StockAdjustmentRequestFromJson(json);
}