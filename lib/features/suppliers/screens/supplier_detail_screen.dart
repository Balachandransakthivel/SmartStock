import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/supplier_provider.dart';

class SupplierDetailScreen extends ConsumerWidget {
  final String supplierId;

  const SupplierDetailScreen({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final supplierAsync = ref.watch(supplierDetailProvider(supplierId));

    return Scaffold(
      body: supplierAsync.when(
        data: (detail) => _buildSupplierDetail(context, theme, detail, authState),
        loading: () => _buildLoadingState(theme),
        error: (error, stack) => _buildErrorState(context, theme, error.toString(), ref),
      ),
    );
  }

  Widget _buildSupplierDetail(
    BuildContext context,
    ThemeData theme,
    SupplierDetail detail,
    AuthState authState,
  ) {
    final canManage = authState.maybeWhen(
      authenticated: (user, _) => user.role.canManageSuppliers,
      orElse: () => false,
    );

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, theme, detail.supplier, canManage),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSupplierHeader(context, theme, detail.supplier),
                SizedBox(height: AppSpacing.xl),
                _buildSummaryCards(context, theme, detail),
                SizedBox(height: AppSpacing.xl),
                _buildRecentPurchases(context, theme, detail),
                SizedBox(height: AppSpacing.xl),
                _buildProductsSupplied(context, theme, detail),
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
    Supplier supplier,
    bool canManage,
  ) {
    return SliverAppBar(
      expandedHeight: 160,
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
                theme.colorScheme.secondaryContainer,
                theme.colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  supplier.companyName.isNotEmpty ? supplier.companyName[0].toUpperCase() : 'S',
                  style: AppTypography.headlineMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(supplier.companyName, style: AppTypography.headlineSmall),
              Text(supplier.contactPerson, style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ),
      actions: [
        if (canManage) ...[
          IconButton(
            icon: Icon(Icons.edit_rounded, color: theme.colorScheme.onSurface),
            onPressed: () => _showEditSupplierDialog(context, detail.supplier),
          ),
        ],
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildSupplierHeader(BuildContext context, ThemeData theme, Supplier supplier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Information', style: AppTypography.titleLarge),
                  SizedBox(height: AppSpacing.xs),
                  _buildInfoRow(theme, Icons.person_rounded, supplier.contactPerson),
                  _buildInfoRow(theme, Icons.phone_rounded, supplier.phone),
                  _buildInfoRow(theme, Icons.email_rounded, supplier.email),
                  _buildInfoRow(theme, Icons.location_on_rounded, supplier.address),
                ],
              ),
            ),
            if (supplier.gstNumber != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('GST: ${supplier.gstNumber}', style: AppTypography.bodySmall),
                  if (supplier.panNumber != null)
                    Text('PAN: ${supplier.panNumber}', style: AppTypography.bodySmall),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: AppTypography.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, ThemeData theme, SupplierDetail detail) {
    return Row(
      children: [
        Expanded(
          child: AppStatCard(
            label: 'Total Purchases',
            value: '${AppConstants.currencySymbol}${_formatNumber(detail.totalPurchases)}',
            icon: Icons.shopping_cart_rounded,
            iconColor: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppStatCard(
            label: 'Pending Payments',
            value: '${AppConstants.currencySymbol}${_formatNumber(detail.pendingPayments)}',
            icon: Icons.pending_actions_rounded,
            iconColor: Colors.orange,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppStatCard(
            label: 'Products Supplied',
            value: detail.totalProducts.toString(),
            icon: Icons.inventory_2_rounded,
            iconColor: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentPurchases(BuildContext context, ThemeData theme, SupplierDetail detail) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Recent Purchases', style: AppTypography.titleLarge),
              Spacer(),
              AppButton(
                label: 'View All',
                onPressed: () => context.push('/suppliers/${detail.supplier.id}/purchases'),
                variant: AppButtonVariant.tertiary,
                size: AppButtonSize.sm,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          if (detail.recentPurchases.isEmpty)
            AppEmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'No purchases yet',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: detail.recentPurchases.length.clamp(0, 10),
              separatorBuilder: (_, __) => AppSeparator(indent: 0, endIndent: 0),
              itemBuilder: (context, index) {
                final purchase = detail.recentPurchases[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: purchase.status.color.withAlphaValue(0.1),
                    child: Icon(
                      _getPurchaseStatusIcon(purchase.status),
                      color: purchase.status.color,
                      size: 18,
                    ),
                  ),
                  title: Text(purchase.purchaseNumber, style: AppTypography.bodyLarge),
                  subtitle: Text('${purchase.itemCount ?? 0} items', style: AppTypography.bodySmall),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${AppConstants.currencySymbol}${_formatNumber(purchase.totalAmount)}',
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppStatusBadge(purchaseStatus: purchase.status),
                    ],
                  ),
                  onTap: () => context.push('/purchases/${purchase.id}'),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProductsSupplied(BuildContext context, ThemeData theme, SupplierDetail detail) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Products Supplied', style: AppTypography.titleLarge),
              Spacer(),
              AppButton(
                label: 'View All',
                onPressed: () => context.push('/suppliers/${detail.supplier.id}/products'),
                variant: AppButtonVariant.tertiary,
                size: AppButtonSize.sm,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          if (detail.productsSupplied.isEmpty)
            AppEmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No products supplied',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: detail.productsSupplied.length.clamp(0, 10),
              separatorBuilder: (_, __) => AppSeparator(indent: 0, endIndent: 0),
              itemBuilder: (context, index) {
                final product = detail.productsSupplied[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(product.productName, style: AppTypography.bodyLarge),
                  subtitle: Text('SKU: ${product.sku}', style: AppTypography.bodySmall),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Stock: ${product.currentStock}',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${AppConstants.currencySymbol}${product.purchasePrice.toStringAsFixed(2)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => context.push('/inventory/${product.productId}'),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showEditSupplierDialog(BuildContext context, Supplier supplier) {
    // Implementation omitted for brevity
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(child: AppLoadingState(message: 'Loading supplier...'));
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error, WidgetRef ref) {
    return AppErrorState(
      title: 'Failed to Load Supplier',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.invalidate(supplierDetailProvider(supplierId)),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  IconData _getPurchaseStatusIcon(PurchaseStatus status) {
    switch (status) {
      case PurchaseStatus.pending:
        return Icons.schedule_rounded;
      case PurchaseStatus.ordered:
        return Icons.shopping_cart_rounded;
      case PurchaseStatus.received:
        return Icons.check_circle_rounded;
      case PurchaseStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }
}