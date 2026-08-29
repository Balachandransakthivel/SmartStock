import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/purchase_provider.dart';

class PurchaseDetailScreen extends ConsumerWidget {
  final String purchaseId;

  const PurchaseDetailScreen({super.key, required this.purchaseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final purchaseAsync = ref.watch(purchaseDetailProvider(purchaseId));

    return Scaffold(
      body: purchaseAsync.when(
        data: (purchase) => _buildPurchaseDetail(context, theme, purchase, authState),
        loading: () => _buildLoadingState(theme),
        error: (error, stack) => _buildErrorState(context, theme, error.toString(), ref),
      ),
    );
  }

  Widget _buildPurchaseDetail(
    BuildContext context,
    ThemeData theme,
    Purchase purchase,
    AuthState authState,
  ) {
    final canManage = authState.maybeWhen(
      authenticated: (user, _) => user.role.canCreatePurchases,
      orElse: () => false,
    );

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, theme, purchase, canManage),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPurchaseHeader(context, theme, purchase),
                SizedBox(height: AppSpacing.xl),
                _buildItemsSection(context, theme, purchase),
                SizedBox(height: AppSpacing.xl),
                _buildSummarySection(context, theme, purchase),
                if (purchase.status == PurchaseStatus.ordered && canManage) ...[
                  SizedBox(height: AppSpacing.xl),
                  _buildReceiveButton(context, theme, purchase),
                ],
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
    Purchase purchase,
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
                theme.colorScheme.primaryContainer,
                theme.colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: purchase.status.color.withAlphaValue(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                    ),
                    child: Icon(
                      _getStatusIcon(purchase.status),
                      color: purchase.status.color,
                      size: AppSpacing.iconSizeLg,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(purchase.purchaseNumber, style: AppTypography.headlineSmall),
                        Text('From ${purchase.supplierName}', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                  AppStatusBadge(purchaseStatus: purchase.status),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (canManage && purchase.status == PurchaseStatus.pending) ...[
          IconButton(
            icon: Icon(Icons.edit_rounded, color: theme.colorScheme.onSurface),
            onPressed: () => context.push('/purchases/${purchase.id}/edit'),
          ),
        ],
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildPurchaseHeader(BuildContext context, ThemeData theme, Purchase purchase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Purchase Details', style: AppTypography.titleLarge),
                  SizedBox(height: AppSpacing.xs),
                  _buildInfoRow(theme, Icons.calendar_today_rounded, 'Order Date', _formatDate(purchase.orderDate)),
                  if (purchase.expectedDeliveryDate != null)
                    _buildInfoRow(theme, Icons.local_shipping_rounded, 'Expected Delivery', _formatDate(purchase.expectedDeliveryDate!)),
                  if (purchase.receivedDate != null)
                    _buildInfoRow(theme, Icons.check_circle_rounded, 'Received Date', _formatDate(purchase.receivedDate!)),
                  if (purchase.invoiceNumber != null)
                    _buildInfoRow(theme, Icons.receipt_rounded, 'Invoice', purchase.invoiceNumber!),
                ],
              ),
            ),
          ],
        ),
        if (purchase.notes != null && purchase.notes!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          AppCard(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notes', style: AppTypography.labelMedium),
                SizedBox(height: AppSpacing.xs),
                Text(purchase.notes!, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: AppSpacing.xs),
          Text('$label: ', style: AppTypography.bodySmall),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildItemsSection(BuildContext context, ThemeData theme, Purchase purchase) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items (${purchase.items.length})', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: purchase.items.length,
            separatorBuilder: (_, __) => AppSeparator(indent: 0, endIndent: 0),
            itemBuilder: (context, index) {
              final item = purchase.items[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.productName, style: AppTypography.bodyLarge),
                          Text('SKU: ${item.sku}', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Qty: ${item.quantity}', style: AppTypography.bodyMedium),
                        if (item.receivedQuantity != null)
                          Text('Received: ${item.receivedQuantity}', style: AppTypography.bodySmall),
                      ],
                    ),
                    SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${AppConstants.currencySymbol}${item.unitPrice.toStringAsFixed(2)}',
                          style: AppTypography.bodyMedium,
                        ),
                        Text(
                          '${AppConstants.currencySymbol}${item.totalPrice.toStringAsFixed(2)}',
                          style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, ThemeData theme, Purchase purchase) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.md),
          _buildSummaryRow(theme, 'Subtotal', '${AppConstants.currencySymbol}${_formatNumber(purchase.subtotal)}'),
          if (purchase.discountAmount > 0)
            _buildSummaryRow(theme, 'Discount', '-${AppConstants.currencySymbol}${_formatNumber(purchase.discountAmount)}', isDiscount: true),
          _buildSummaryRow(theme, 'Tax', '${AppConstants.currencySymbol}${_formatNumber(purchase.taxAmount)}'),
          AppSeparator(),
          _buildSummaryRow(theme, 'Total', '${AppConstants.currencySymbol}${_formatNumber(purchase.totalAmount)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600)
                : AppTypography.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)
                : (isDiscount
                    ? AppTypography.bodyMedium.copyWith(color: Colors.green)
                    : AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiveButton(BuildContext context, ThemeData theme, Purchase purchase) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        label: 'Mark as Received',
        onPressed: () => _receivePurchase(context, purchase.id),
        variant: AppButtonVariant.primary,
        size: AppButtonSize.lg,
        leadingIcon: Icons.local_shipping_rounded,
      ),
    );
  }

  void _receivePurchase(BuildContext context, String purchaseId) {
    showConfirmDialog(
      context: context,
      title: 'Receive Purchase',
      message: 'Mark this purchase order as received? This will automatically update stock levels.',
      confirmLabel: 'Receive',
      confirmVariant: AppButtonVariant.primary,
      icon: Icons.local_shipping_rounded,
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(purchaseNotifierProvider.notifier).receivePurchase(purchaseId).then((_) {
          showAppSnackBar(
            context: context,
            message: 'Purchase received and stock updated',
            type: AppSnackBarType.success,
          );
        }).catchError((error) {
          showAppSnackBar(
            context: context,
            message: error.toString(),
            type: AppSnackBarType.error,
          );
        });
      }
    });
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(child: AppLoadingState(message: 'Loading purchase...'));
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error, WidgetRef ref) {
    return AppErrorState(
      title: 'Failed to Load Purchase',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.invalidate(purchaseDetailProvider(purchaseId)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  IconData _getStatusIcon(PurchaseStatus status) {
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