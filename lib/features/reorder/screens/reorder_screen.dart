import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
import 'package:go_router/go_router.dart'
import '../../../core/theme/app_theme.dart'
import '../../../core/theme/app_spacing.dart'
import '../../../core/theme/app_typography.dart'
import '../../../core/constants/app_constants.dart'
import '../../../shared/models/models.dart'
import '../../../shared/widgets/widgets.dart'
import '../providers/reorder_provider.dart'

class ReorderScreen extends ConsumerWidget {
  const ReorderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context)
    final reorderAsync = ref.watch(reorderRecommendationsProvider)

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Reorder'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded, color: theme.colorScheme.onSurface),
            onPressed: () => context.push('/reorder/settings'),
          ),
        ],
      ),
      body: reorderAsync.when(
        data: (response) => _buildReorderContent(context, theme, response),
        loading: () => _buildLoadingState(theme),
        error: (error, stack) => _buildErrorState(context, theme, error.toString(), ref),
      ),
    )
  }

  Widget _buildReorderContent(BuildContext context, ThemeData theme, ReorderListResponse response) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(context, theme, response),
                SizedBox(height: AppSpacing.xl),
                _buildReorderList(context, theme, response.recommendations),
              ],
            ),
          ),
        ),
      ],
    )
  }

  Widget _buildSummaryCards(BuildContext context, ThemeData theme, ReorderListResponse response) {
    return Row(
      children: [
        Expanded(
          child: AppStatCard(
            label: 'Need Attention',
            value: response.totalProductsNeedingAttention.toString(),
            icon: Icons.notification_important_rounded,
            iconColor: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppStatCard(
            label: 'Critical',
            value: response.criticalCount.toString(),
            icon: Icons.warning_rounded,
            iconColor: Colors.red,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppStatCard(
            label: 'Soon',
            value: response.soonCount.toString(),
            icon: Icons.schedule_rounded,
            iconColor: Colors.orange,
          ),
        ),
      ],
    )
  }

  Widget _buildReorderList(BuildContext context, ThemeData theme, List<ReorderRecommendation> recommendations) {
    if (recommendations.isEmpty) {
      return AppEmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: 'All stock levels are healthy',
        message: 'No products need reordering at this time',
      )
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reorder Recommendations', style: AppTypography.titleLarge),
        SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recommendations.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final item = recommendations[index]
            return _buildReorderCard(context, theme, item)
          },
        ),
      ],
    )
  }

  Widget _buildReorderCard(BuildContext context, ThemeData theme, ReorderRecommendation item) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: AppTypography.titleMedium),
                    Text('SKU: ${item.sku}', style: AppTypography.bodySmall),
                  ],
                ),
              ),
              AppStatusBadge(reorderUrgency: item.urgency),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildReorderStat(theme, 'Current Stock', item.currentStock.toString(), item.isLowStock ? Colors.red : Colors.green),
              SizedBox(width: AppSpacing.lg),
              _buildReorderStat(theme, 'Reorder Point', item.reorderPoint.toString(), Colors.orange),
              SizedBox(width: AppSpacing.lg),
              _buildReorderStat(theme, 'Suggested Qty', item.suggestedOrderQuantity.toString(), theme.colorScheme.primary),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          AppSeparator(),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildReorderStat(theme, 'Avg Daily Sales', item.averageDailySales.toStringAsFixed(1), Colors.blue),
              SizedBox(width: AppSpacing.lg),
              _buildReorderStat(theme, 'Days Remaining', '${item.estimatedDaysRemaining} days', item.estimatedDaysRemaining <= 3 ? Colors.red : Colors.green),
              SizedBox(width: AppSpacing.lg),
              if (item.estimatedCost != null)
                _buildReorderStat(theme, 'Est. Cost', '${AppConstants.currencySymbol}${_formatNumber(item.estimatedCost!)}', Colors.purple),
            ],
          ),
          if (item.supplierName != null) ...[
            SizedBox(height: AppSpacing.md),
            AppSeparator(),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.business_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                SizedBox(width: AppSpacing.xs),
                Text('Supplier: ${item.supplierName}', style: AppTypography.bodySmall),
                if (item.supplierLeadTimeDays != null) ...[
                  SizedBox(width: AppSpacing.md),
                  Icon(Icons.local_shipping_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  SizedBox(width: AppSpacing.xs),
                  Text('Lead time: ${item.supplierLeadTimeDays} days', style: AppTypography.bodySmall),
                ],
              ],
            ),
          ],
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Create Purchase Order',
              onPressed: () => _createPurchaseOrder(context, ref, item.productId),
              variant: AppButtonVariant.primary,
              leadingIcon: Icons.add_shopping_cart_rounded,
            ),
          ),
        ],
      ),
    )
  }

  Widget _buildReorderStat(ThemeData theme, String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700, color: color)),
          Text(label, style: AppTypography.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    )
  }

  void _createPurchaseOrder(BuildContext context, WidgetRef ref, String productId) {
    ref.read(reorderNotifierProvider.notifier).createPurchaseFromReorder(productId).then((_) {
      showAppSnackBar(
        context: context,
        message: 'Purchase order created successfully',
        type: AppSnackBarType.success,
      )
    }).catchError((error) {
      showAppSnackBar(
        context: context,
        message: error.toString(),
        type: AppSnackBarType.error,
      )
    })
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(child: AppLoadingState(message: 'Loading reorder recommendations...'))
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error, WidgetRef ref) {
    return AppErrorState(
      title: 'Failed to Load Recommendations',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.invalidate(reorderRecommendationsProvider),
    )
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M'
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K'
    return value.toStringAsFixed(2)
  }
}