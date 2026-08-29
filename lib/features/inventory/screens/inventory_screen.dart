import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/inventory_provider.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  StockStatus? _selectedStatus;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(productFiltersNotifierProvider.notifier).nextPage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final productsAsync = ref.watch(filteredProductsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final filters = ref.watch(productFiltersNotifierProvider);

    return Scaffold(
      appBar: _buildAppBar(context, theme),
      body: Column(
        children: [
          _buildSearchAndFilters(context, theme, categoriesAsync),
          Expanded(
            child: productsAsync.when(
              data: (response) => _buildProductList(context, theme, response, authState),
              loading: () => _buildLoadingList(theme),
              error: (error, stack) => _buildErrorState(context, theme, error.toString(), ref),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context, authState),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Text('Inventory'),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list_rounded, color: theme.colorScheme.onSurface),
          onPressed: _showFilterBottomSheet,
        ),
        IconButton(
          icon: Icon(Icons.qr_code_scanner_rounded, color: theme.colorScheme.onSurface),
          onPressed: () => context.push('/scan'),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, ThemeData theme, AsyncValue<List<Category>> categoriesAsync) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Column(
        children: [
          AppSearchField(
            controller: _searchController,
            hint: 'Search products, SKU, barcode...',
            onChanged: (value) {
              ref.read(productFiltersNotifierProvider.notifier).updateSearch(value);
            },
            onSubmitted: () => ref.read(productFiltersNotifierProvider.notifier).updateSearch(_searchController.text),
          ),
          SizedBox(height: AppSpacing.sm),
          categoriesAsync.when(
            data: (categories) => _buildFilterChips(context, theme, categories),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, ThemeData theme, List<Category> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatusFilterChip(theme, null, 'All'),
          _buildStatusFilterChip(theme, StockStatus.inStock, 'In Stock'),
          _buildStatusFilterChip(theme, StockStatus.lowStock, 'Low Stock'),
          _buildStatusFilterChip(theme, StockStatus.outOfStock, 'Out of Stock'),
          SizedBox(width: AppSpacing.sm),
          ...categories.map((cat) => Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              label: Text(cat.name, style: AppTypography.labelMedium),
              selected: _selectedCategoryId == cat.id,
              onSelected: (selected) {
                setState(() {
                  _selectedCategoryId = selected ? cat.id : null;
                  ref.read(productFiltersNotifierProvider.notifier).updateCategory(_selectedCategoryId);
                });
              },
              backgroundColor: theme.colorScheme.surfaceContainer,
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: AppTypography.labelMedium,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChip(ThemeData theme, StockStatus? status, String label) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != null) ...[
              Icon(status.icon, size: 14, color: isSelected ? theme.colorScheme.onPrimaryContainer : status.color),
              SizedBox(width: 4),
            ],
            Text(label, style: AppTypography.labelMedium),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = selected ? status : null;
            ref.read(productFiltersNotifierProvider.notifier).updateStatus(_selectedStatus);
          });
        },
        backgroundColor: theme.colorScheme.surfaceContainer,
        selectedColor: status?.color.withAlphaValue(0.2) ?? theme.colorScheme.primaryContainer,
        labelStyle: AppTypography.labelMedium,
        side: BorderSide(
          color: isSelected ? (status?.color ?? theme.colorScheme.primary) : theme.dividerColor,
        ),
      ),
    );
  }

  Widget _buildProductList(
    BuildContext context,
    ThemeData theme,
    ProductListResponse response,
    AuthState authState,
  ) {
    if (response.products.isEmpty) {
      return AppEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No products found',
        message: 'Add your first product to get started',
        actionLabel: 'Add Product',
        onAction: () => context.push('/inventory/add'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(filteredProductsProvider),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 100),
        itemCount: response.products.length + (response.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == response.products.length) {
            return Center(
              child: Padding(
                padding: AppSpacing.screenPaddingVertical,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final product = response.products[index];
          final canManage = authState.maybeWhen(
            authenticated: (user, _) => user.role.canManageProducts,
            orElse: () => false,
          );
          return AppProductTile(
            name: product.name,
            sku: product.sku,
            category: product.categoryName,
            currentStock: product.currentStock,
            minimumStock: product.minimumStock,
            sellingPrice: product.sellingPrice,
            imageUrl: product.imageUrl,
            status: product.stockStatus,
            onTap: () => context.push('/inventory/${product.id}'),
            onStockIn: canManage ? () => _showStockInDialog(context, product) : null,
            onStockOut: canManage ? () => _showStockOutDialog(context, product) : null,
            onEdit: canManage ? () => context.push('/inventory/${product.id}/edit') : null,
            showActions: canManage,
          );
        },
      ),
    );
  }

  void _showStockInDialog(BuildContext context, Product product) {
    final qtyController = TextEditingController();
    final priceController = TextEditingController(text: product.purchasePrice.toStringAsFixed(2));
    final invoiceController = TextEditingController();
    String? selectedSupplierId;

    showAppBottomSheet(
      context: context,
      title: 'Stock In - ${product.name}',
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppNumberField(
              controller: qtyController,
              label: 'Quantity *',
              hint: 'Enter quantity',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.md),
            AppNumberField(
              controller: priceController,
              label: 'Purchase Price *',
              hint: 'Enter purchase price',
              prefixText: '${AppConstants.currencySymbol} ',
              decimalPlaces: 2,
            ),
            SizedBox(height: AppSpacing.md),
            // Supplier dropdown would go here
            AppTextField(
              controller: invoiceController,
              label: 'Invoice Number',
              hint: 'Optional',
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    variant: AppButtonVariant.tertiary,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Add Stock',
                    onPressed: () {
                      if (qtyController.text.isNotEmpty) {
                        ref.read(inventoryNotifierProvider.notifier).stockIn(StockInRequest(
                          productId: product.id,
                          quantity: int.parse(qtyController.text),
                          supplierId: selectedSupplierId ?? '',
                          purchasePrice: double.parse(priceController.text),
                          invoiceNumber: invoiceController.text.isEmpty ? null : invoiceController.text,
                        ));
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showStockOutDialog(BuildContext context, Product product) {
    final qtyController = TextEditingController();
    StockOutReason? selectedReason = StockOutReason.sale;
    final customerController = TextEditingController();

    showAppBottomSheet(
      context: context,
      title: 'Stock Out - ${product.name}',
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppNumberField(
              controller: qtyController,
              label: 'Quantity *',
              hint: 'Enter quantity',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<StockOutReason>(
              value: selectedReason,
              decoration: InputDecoration(
                labelText: 'Reason *',
                filled: true,
              ),
              items: StockOutReason.values.map((reason) => DropdownMenuItem(
                value: reason,
                child: Text(reason.name),
              )).toList(),
              onChanged: (value) => selectedReason = value,
            ),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: customerController,
              label: 'Customer (optional)',
              hint: 'Customer name',
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    variant: AppButtonVariant.tertiary,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Remove Stock',
                    onPressed: () {
                      if (qtyController.text.isNotEmpty) {
                        final qty = int.parse(qtyController.text);
                        if (qty > product.currentStock) {
                          showAppSnackBar(
                            context: context,
                            message: 'Insufficient stock. Available: ${product.currentStock}',
                            type: AppSnackBarType.error,
                          );
                          return;
                        }
                        ref.read(inventoryNotifierProvider.notifier).stockOut(StockOutRequest(
                          productId: product.id,
                          quantity: qty,
                          reason: selectedReason!,
                          customerName: customerController.text.isEmpty ? null : customerController.text,
                        ));
                        Navigator.pop(context);
                      }
                    },
                    variant: AppButtonVariant.destructive,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadiusXl)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filters', style: AppTypography.titleLarge),
              SizedBox(height: AppSpacing.lg),
              // Additional filters can go here
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingList(ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 100),
      itemCount: 6,
      itemBuilder: (_, __) => _buildSkeletonProductTile(theme),
    );
  }

  Widget _buildSkeletonProductTile(ThemeData theme) {
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.extension<AppCustomTheme>()!.skeletonColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 150, color: theme.extension<AppCustomTheme>()!.skeletonColor),
                SizedBox(height: AppSpacing.sm),
                Container(height: 12, width: 100, color: theme.extension<AppCustomTheme>()!.skeletonColor),
                SizedBox(height: AppSpacing.sm),
                Container(height: 12, width: 200, color: theme.extension<AppCustomTheme>()!.skeletonColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error, WidgetRef ref) {
    return AppErrorState(
      title: 'Failed to Load Products',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.invalidate(filteredProductsProvider),
    );
  }

  Widget _buildFAB(BuildContext context, AuthState authState) {
    final canManage = authState.maybeWhen(
      authenticated: (user, _) => user.role.canManageProducts,
      orElse: () => false,
    );
    
    if (!canManage) return const SizedBox.shrink();
    
    return FloatingActionButton(
      onPressed: () => context.push('/inventory/add'),
      child: Icon(Icons.add_rounded),
    );
  }
}