import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

part 'inventory_provider.g.dart';

@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<ProductListResponse> build(ProductListParams params) {
    _apiClient.initialize();
    return _fetchProducts(params);
  }

  Future<ProductListResponse> _fetchProducts(ProductListParams params) async {
    try {
      final queryParams = <String, dynamic>{
        if (params.page != null) 'page': params.page,
        if (params.limit != null) 'limit': params.limit,
        if (params.search != null && params.search!.isNotEmpty) 'search': params.search,
        if (params.categoryId != null && params.categoryId!.isNotEmpty) 'category': params.categoryId,
        if (params.status != null) 'status': params.status!.name,
        if (params.supplierId != null && params.supplierId!.isNotEmpty) 'supplier': params.supplierId,
        if (params.sortBy != null) 'sortBy': params.sortBy,
        if (params.sortDesc != null) 'sortDesc': params.sortDesc,
      };

      final response = await _apiClient.dio.get('/products', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return ProductListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> createProduct(ProductCreateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/products', data: request.toJson());
      if (response.statusCode == 201) {
        final product = Product.fromJson(response.data['product']);
        _refreshCurrentPage();
        return product;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create product');
      }
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<Product> updateProduct(String id, ProductUpdateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.put('/products/$id', data: request.toJson());
      if (response.statusCode == 200) {
        final product = Product.fromJson(response.data['product']);
        _refreshCurrentPage();
        return product;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.delete('/products/$id');
      if (response.statusCode == 200) {
        _refreshCurrentPage();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<Product> getProduct(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<void> stockIn(StockInRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/stock/in', data: request.toJson());
      if (response.statusCode == 200) {
        _refreshCurrentPage();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to add stock');
      }
    } catch (e) {
      throw Exception('Failed to add stock: $e');
    }
  }

  Future<void> stockOut(StockOutRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/stock/out', data: request.toJson());
      if (response.statusCode == 200) {
        _refreshCurrentPage();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to remove stock');
      }
    } catch (e) {
      throw Exception('Failed to remove stock: $e');
    }
  }

  void _refreshCurrentPage() {
    // Riverpod will automatically refetch with the same params
    ref.invalidateSelf();
  }
}

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<List<Category>> build() {
    _apiClient.initialize();
    return _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    try {
      final response = await _apiClient.dio.get('/categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['categories'] ?? response.data;
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<Category> createCategory(CategoryCreateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/categories', data: request.toJson());
      if (response.statusCode == 201) {
        final category = Category.fromJson(response.data['category']);
        ref.invalidateSelf();
        return category;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create category');
      }
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }
}

@riverpod
FutureOr<Product> productDetail(Ref ref, String productId) {
  final notifier = ref.watch(inventoryNotifierProvider.notifier);
  return notifier.getProduct(productId);
}

@riverpod
FutureOr<List<Category>> categories(Ref ref) {
  return ref.watch(categoryNotifierProvider.future);
}

@riverpod
FutureOr<StockMovementListResponse> stockHistory(
  Ref ref,
  StockMovementListParams params,
) {
  final apiClient = ApiClient();
  apiClient.initialize();
  
  return _fetchStockHistory(apiClient, params);
}

Future<StockMovementListResponse> _fetchStockHistory(
  ApiClient apiClient,
  StockMovementListParams params,
) async {
  try {
    final queryParams = <String, dynamic>{
      if (params.page != null) 'page': params.page,
      if (params.limit != null) 'limit': params.limit,
      if (params.productId != null && params.productId!.isNotEmpty) 'product': params.productId,
      if (params.type != null) 'type': params.type!.name,
      if (params.fromDate != null) 'from': params.fromDate!.toIso8601String(),
      if (params.toDate != null) 'to': params.toDate!.toIso8601String(),
      if (params.sortBy != null) 'sortBy': params.sortBy,
      if (params.sortDesc != null) 'sortDesc': params.sortDesc,
    };

    final response = await apiClient.dio.get('/stock/history', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      return StockMovementListResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load stock history');
    }
  } catch (e) {
    throw Exception('Failed to load stock history: $e');
  }
}

@riverpod
class ProductFiltersNotifier extends _$ProductFiltersNotifier {
  @override
  ProductListParams build() {
    return const ProductListParams(page: 1, limit: 20);
  }

  void updateSearch(String search) {
    state = state.copyWith(search: search, page: 1);
  }

  void updateCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId, page: 1);
  }

  void updateStatus(StockStatus? status) {
    state = state.copyWith(status: status, page: 1);
  }

  void updateSupplier(String? supplierId) {
    state = state.copyWith(supplierId: supplierId, page: 1);
  }

  void updateSort(String? sortBy, bool? sortDesc) {
    state = state.copyWith(sortBy: sortBy, sortDesc: sortDesc);
  }

  void nextPage() {
    state = state.copyWith(page: (state.page ?? 1) + 1);
  }

  void reset() {
    state = const ProductListParams(page: 1, limit: 20);
  }
}

@riverpod
FutureOr<ProductListResponse> filteredProducts(Ref ref) {
  final params = ref.watch(productFiltersNotifierProvider);
  return ref.watch(inventoryNotifierProvider(params).future);
}