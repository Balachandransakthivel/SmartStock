import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/inventory_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      body: productAsync.when(
        data: (product) => _buildProductDetail(context, theme, product, authState),
        loading: () => _buildLoadingState(theme),
        error: (error, stack) => _buildErrorState(context, theme, error.toString(), ref),
      ),
    );
  }

  Widget _buildProductDetail(
    BuildContext context,
    ThemeData theme,
    Product product,
    AuthState authState,
  ) {
    final canManage = authState.maybeWhen(
      authenticated: (user, _) => user.role.canManageProducts,
      orElse: () => false,
    );

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, theme, product, canManage),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductHeader(context, theme, product),
                SizedBox(height: AppSpacing.xl),
                _buildStockInfo(context, theme, product),
                SizedBox(height: AppSpacing.xl),
                _buildPriceInfo(context, theme, product),
                SizedBox(height: AppSpacing.xl),
                _buildActionButtons(context, theme, product, canManage),
                SizedBox(height: AppSpacing.xl),
                _buildStockHistorySection(context, theme, product),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    ThemeData theme,
    Product product,
    bool canManage,
  ) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xl, AppSpacing.md, AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.imageUrl != null)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: Icon(
                    Icons.inventory_2_rounded,
                    size: AppSpacing.iconSizeXl,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              SizedBox(height: AppSpacing.md),
              Text(product.name, style: AppTypography.headlineSmall),
              Text('SKU: ${product.sku}', style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ),
      actions: [
        if (canManage) ...[
          IconButton(
            icon: Icon(Icons.edit_rounded, color: theme.colorScheme.onSurface),
            onPressed: () => context.push('/inventory/${product.id}/edit'),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: theme.colorScheme.onSurface),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_rounded, color: theme.colorScheme.error, size: 18),
                    SizedBox(width: AppSpacing.sm),
                    Text('Delete', style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') _confirmDelete(context, ref, product.id);
            },
          ),
        ],
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildProductHeader(BuildContext context, ThemeData theme, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Details', style: AppTypography.titleLarge),
                  SizedBox(height: AppSpacing.xs),
                  Text('SKU: ${product.sku}', style: AppTypography.bodyMedium),
                  if (product.barcode != null)
                    Text('Barcode: ${product.barcode}', style: AppTypography.bodyMedium),
                  if (product.categoryName != null)
                    Text('Category: ${product.categoryName}', style: AppTypography.bodyMedium),
                ],
              ),
            ),
            AppStatusBadge(stockStatus: product.stockStatus),
          ],
        ),
        if (product.description != null && product.description!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          Text(product.description!, style: AppTypography.bodyMedium),
        ],
      ],
    );
  }

  Widget _buildStockInfo(BuildContext context, ThemeData theme, Product product) {
    final customTheme = context.customTheme;
    final isLowStock = product.isLowStock;
    final isOutOfStock = product.isOutOfStock;

    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Information', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildStockStat(
                  theme,
                  customTheme,
                  'Current Stock',
                  product.currentStock.toString(),
                  isOutOfStock ? customTheme.criticalColor : (isLowStock ? customTheme.warningColor : customTheme.successColor),
                  isOutOfStock ? Icons.cancel : (isLowStock ? Icons.warning_amber_rounded : Icons.check_circle),
                ),
              ),
              Expanded(
                child: _buildStockStat(
                  theme,
                  customTheme,
                  'Minimum Stock',
                  product.minimumStock.toString(),
                  theme.colorScheme.onSurfaceVariant,
                  Icons.remove_circle_outline_rounded,
                ),
              ),
              Expanded(
                child: _buildStockStat(
                  theme,
                  customTheme,
                  'Maximum Stock',
                  product.maximumStock.toString(),
                  theme.colorScheme.onSurfaceVariant,
                  Icons.add_circle_outline_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          AppSeparator(),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildStockStat(
                  theme,
                  customTheme,
                  'Stock Value',
                  '${AppConstants.currencySymbol}${_formatNumber(product.stockValue)}',
                  Colors.green,
                  Icons.attach_money_rounded,
                ),
              ),
              Expanded(
                child: _buildStockStat(
                  theme,
                  customTheme,
                  'Cost Value',
                  '${AppConstants.currencySymbol}${_formatNumber(product.costValue)}',
                  theme.colorScheme.onSurfaceVariant,
                  Icons.receipt_rounded,
                ),
              ),
              Expanded(
                child: _buildStockStat(
                  theme,
                  customTheme,
                  'Profit Margin',
                  '${product.profitMargin.toStringAsFixed(1)}%',
                  product.profitMargin > 20 ? Colors.green : Colors.orange,
                  Icons.trending_up_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockStat(
    ThemeData theme,
    AppCustomTheme customTheme,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: color.withAlphaValue(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          ),
          child: Icon(icon, color: color, size: AppSpacing.iconSizeLg),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(value, style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700, color: color)),
        Text(label, style: AppTypography.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildPriceInfo(BuildContext context, ThemeData theme, Product product) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pricing', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildPriceCard(
                  theme,
                  'Purchase Price',
                  '${AppConstants.currencySymbol}${product.purchasePrice.toStringAsFixed(2)}',
                  Icons.shopping_cart_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildPriceCard(
                  theme,
                  'Selling Price',
                  '${AppConstants.currencySymbol}${product.sellingPrice.toStringAsFixed(2)}',
                  Icons.sell_rounded,
                ),
              ),
            ],
          ),
          if (product.supplierName != null) ...[
            SizedBox(height: AppSpacing.md),
            AppSeparator(),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.business_rounded, color: theme.colorScheme.onSurfaceVariant, size: AppSpacing.iconSizeSm),
                SizedBox(width: AppSpacing.sm),
                Text('Supplier: ${product.supplierName}', style: AppTypography.bodyMedium),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceCard(ThemeData theme, String label, String value, IconData icon) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSpacing.iconSizeSm, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(width: AppSpacing.xs),
              Text(label, style: AppTypography.labelMedium),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ThemeData theme,
    Product product,
    bool canManage,
  ) {
    if (!canManage) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Stock In',
            onPressed: () => _showStockInDialog(context, product),
            leadingIcon: Icons.add_circle_outline_rounded,
            variant: AppButtonVariant.primary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppButton(
            label: 'Stock Out',
            onPressed: () => _showStockOutDialog(context, product),
            leadingIcon: Icons.remove_circle_outline_rounded,
            variant: AppButtonVariant.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStockHistorySection(BuildContext context, ThemeData theme, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Stock History', style: AppTypography.titleLarge),
            Spacer(),
            AppButton(
              label: 'View All',
              onPressed: () => context.push('/inventory/${product.id}/history'),
              variant: AppButtonVariant.tertiary,
              size: AppButtonSize.sm,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        _buildStockHistoryChart(context, theme, product),
        SizedBox(height: AppSpacing.md),
        _buildRecentMovementsList(context, theme, product),
      ],
    );
  }

  Widget _buildStockHistoryChart(BuildContext context, ThemeData theme, Product product) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Movement (Last 30 Days)', style: AppTypography.titleMedium),
          SizedBox(height: AppSpacing.md),
          // Placeholder chart - would connect to actual stock history API
          Container(
            height: AppSpacing.chartHeightSm,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            child: Center(
              child: Text(
                'Stock movement chart would appear here',
                style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMovementsList(BuildContext context, ThemeData theme, Product product) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Movements', style: AppTypography.titleMedium),
          SizedBox(height: AppSpacing.md),
          AppEmptyState(
            icon: Icons.history_rounded,
            title: 'No recent movements',
            message: 'Stock movements will appear here',
          ),
        ],
      ),
    );
  }

  void _showStockInDialog(BuildContext context, Product product) {
    // Reuse the same logic from inventory screen
    // Implementation omitted for brevity
  }

  void _showStockOutDialog(BuildContext context, Product product) {
    // Reuse the same logic from inventory screen
    // Implementation omitted for brevity
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String productId) {
    showConfirmDialog(
      context: context,
      title: 'Delete Product',
      message: 'Are you sure you want to delete this product? This action cannot be undone.',
      confirmLabel: 'Delete',
      confirmVariant: AppButtonVariant.destructive,
      icon: Icons.delete_rounded,
      iconColor: Theme.of(context).colorScheme.error,
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(inventoryNotifierProvider.notifier).deleteProduct(productId);
        context.pop();
      }
    });
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(child: AppLoadingState(message: 'Loading product...'));
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error, WidgetRef ref) {
    return AppErrorState(
      title: 'Failed to Load Product',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.invalidate(productDetailProvider(productId)),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}