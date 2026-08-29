import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import '../constants/app_constants.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String sku,
    String? barcode,
    required String categoryId,
    String? categoryName,
    String? description,
    required double purchasePrice,
    required double sellingPrice,
    required int currentStock,
    required int minimumStock,
    required int maximumStock,
    String? supplierId,
    String? supplierName,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastStockMovementAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
class ProductCreateRequest with _$ProductCreateRequest {
  const factory ProductCreateRequest({
    required String name,
    required String sku,
    String? barcode,
    required String categoryId,
    String? description,
    required double purchasePrice,
    required double sellingPrice,
    required int currentStock,
    required int minimumStock,
    required int maximumStock,
    String? supplierId,
    String? imageBase64,
  }) = _ProductCreateRequest;

  factory ProductCreateRequest.fromJson(Map<String, dynamic> json) => _$ProductCreateRequestFromJson(json);
}

@freezed
class ProductUpdateRequest with _$ProductUpdateRequest {
  const factory ProductUpdateRequest({
    String? name,
    String? sku,
    String? barcode,
    String? categoryId,
    String? description,
    double? purchasePrice,
    double? sellingPrice,
    int? minimumStock,
    int? maximumStock,
    String? supplierId,
    String? imageBase64,
  }) = _ProductUpdateRequest;

  factory ProductUpdateRequest.fromJson(Map<String, dynamic> json) => _$ProductUpdateRequestFromJson(json);
}

@freezed
class ProductListParams with _$ProductListParams {
  const factory ProductListParams({
    int? page,
    int? limit,
    String? search,
    String? categoryId,
    StockStatus? status,
    String? supplierId,
    String? sortBy,
    bool? sortDesc,
  }) = _ProductListParams;

  factory ProductListParams.fromJson(Map<String, dynamic> json) => _$ProductListParamsFromJson(json);
}

@freezed
class ProductListResponse with _$ProductListResponse {
  const factory ProductListResponse({
    required List<Product> products,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _ProductListResponse;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) => _$ProductListResponseFromJson(json);
}

extension ProductExtension on Product {
  StockStatus get stockStatus {
    if (currentStock <= 0) return StockStatus.outOfStock;
    if (currentStock <= minimumStock) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  double get stockValue => currentStock * sellingPrice;
  double get costValue => currentStock * purchasePrice;
  double get profitMargin => sellingPrice > 0 ? ((sellingPrice - purchasePrice) / sellingPrice) * 100 : 0;
  
  bool get isLowStock => currentStock <= minimumStock && currentStock > 0;
  bool get isOutOfStock => currentStock <= 0;
  bool get isHealthy => currentStock > minimumStock;
  
  int get stockDeficit => minimumStock - currentStock;
  double get reorderQuantity => (maximumStock - currentStock).clamp(0, maximumStock).toDouble();
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
    int? productCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class CategoryCreateRequest with _$CategoryCreateRequest {
  const factory CategoryCreateRequest({
    required String name,
    String? description,
    String? imageBase64,
  }) = _CategoryCreateRequest;

  factory CategoryCreateRequest.fromJson(Map<String, dynamic> json) => _$CategoryCreateRequestFromJson(json);
}