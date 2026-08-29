import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final dashboardAsync = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, theme, authState),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: dashboardAsync.when(
                data: (stats) => _buildDashboardContent(context, theme, stats),
                loading: () => _buildLoadingState(theme),
                error: (error, stack) => _buildErrorState(context, theme, error.toString(), ref),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme, AuthState authState) {
    final user = authState.maybeWhen(
      authenticated: (user, _) => user,
      orElse: () => null,
    );

    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: AppSpacing.md, bottom: AppSpacing.md),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dashboard',
              style: AppTypography.headlineMedium,
            ),
            if (user != null)
              Text(
                'Welcome, ${user.name}',
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.surface,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface),
          onPressed: () => context.push('/notifications'),
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: theme.colorScheme.onSurface),
          onPressed: () => context.push('/settings'),
        ),
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildDashboardContent(BuildContext context, ThemeData theme, DashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsGrid(context, theme, stats),
        SizedBox(height: AppSpacing.xl),
        _buildChartsSection(context, theme, stats),
        SizedBox(height: AppSpacing.xl),
        _buildTopProductsSection(context, theme, stats),
        SizedBox(height: AppSpacing.xl),
        _buildRecentActivitySection(context, theme, stats),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, ThemeData theme, DashboardStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.6,
      children: [
        AppStatCard(
          label: 'Total Products',
          value: stats.totalProducts.toString(),
          subtitle: '${stats.lowStockCount} low • ${stats.outOfStockCount} out',
          icon: Icons.inventory_2_rounded,
          iconColor: theme.colorScheme.primary,
          onTap: () => context.push('/inventory'),
        ),
        AppStatCard(
          label: 'Stock Value',
          value: '${AppConstants.currencySymbol}${_formatNumber(stats.totalStockValue)}',
          subtitle: 'Cost: ${AppConstants.currencySymbol}${_formatNumber(stats.totalCostValue)}',
          icon: Icons.attach_money_rounded,
          iconColor: Colors.green,
          onTap: () => context.push('/analytics/inventory'),
        ),
        AppStatCard(
          label: 'Today\'s Sales',
          value: stats.todaySales.toString(),
          subtitle: '${AppConstants.currencySymbol}${_formatNumber(stats.todayRevenue)} revenue',
          icon: Icons.point_of_sale_rounded,
          iconColor: Colors.blue,
          onTap: () => context.push('/sales'),
        ),
        AppStatCard(
          label: 'This Month',
          value: stats.thisMonthSales.toString(),
          subtitle: '${AppConstants.currencySymbol}${_formatNumber(stats.thisMonthRevenue)} revenue',
          icon: Icons.trending_up_rounded,
          iconColor: Colors.purple,
          onTap: () => context.push('/analytics/sales'),
        ),
      ],
    );
  }

  Widget _buildChartsSection(BuildContext context, ThemeData theme, DashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Sales & Purchases (Last 7 Days)', style: AppTypography.titleLarge),
            Spacer(),
            AppButton(
              label: 'View All',
              onPressed: () => context.push('/analytics'),
              variant: AppButtonVariant.tertiary,
              size: AppButtonSize.sm,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: AppCard(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sales', style: AppTypography.titleMedium),
                    SizedBox(height: AppSpacing.md),
                    AppLineChart(
                      spots: _createSalesSpots(stats.salesLast7Days),
                      xLabels: stats.salesLast7Days.map((d) => _formatDay(d.date)).toList(),
                      lineColor: Colors.green,
                      height: AppSpacing.chartHeightSm,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppCard(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Purchases', style: AppTypography.titleMedium),
                    SizedBox(height: AppSpacing.md),
                    AppLineChart(
                      spots: _createPurchaseSpots(stats.purchasesLast7Days),
                      xLabels: stats.purchasesLast7Days.map((d) => _formatDay(d.date)).toList(),
                      lineColor: theme.colorScheme.primary,
                      height: AppSpacing.chartHeightSm,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopProductsSection(BuildContext context, ThemeData theme, DashboardStats stats) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Top Selling Products', style: AppTypography.titleLarge),
              Spacer(),
              AppButton(
                label: 'View All',
                onPressed: () => context.push('/analytics/products'),
                variant: AppButtonVariant.tertiary,
                size: AppButtonSize.sm,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          if (stats.topProducts.isEmpty)
            AppEmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'No sales data yet',
              message: 'Start selling to see your top products',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.topProducts.length.clamp(0, 5),
              separatorBuilder: (_, __) => AppSeparator(indent: 0, endIndent: 0),
              itemBuilder: (context, index) {
                final product = stats.topProducts[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      '${index + 1}',
                      style: AppTypography.labelMedium.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title: Text(product.productName, style: AppTypography.bodyLarge),
                  subtitle: Text('SKU: ${product.sku}', style: AppTypography.bodySmall),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${product.quantitySold} sold',
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${AppConstants.currencySymbol}${_formatNumber(product.revenue)}',
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

  Widget _buildRecentActivitySection(BuildContext context, ThemeData theme, DashboardStats stats) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Recent Activity', style: AppTypography.titleLarge),
              Spacer(),
              AppButton(
                label: 'View All',
                onPressed: () => context.push('/activity-log'),
                variant: AppButtonVariant.tertiary,
                size: AppButtonSize.sm,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          if (stats.recentActivity.isEmpty)
            AppEmptyState(
              icon: Icons.history_rounded,
              title: 'No recent activity',
              message: 'Activity will appear here as you manage inventory',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.recentActivity.length.clamp(0, 10),
              separatorBuilder: (_, __) => AppSeparator(indent: 0, endIndent: 0),
              itemBuilder: (context, index) {
                final activity = stats.recentActivity[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    child: Icon(
                      _getActivityIcon(activity.action),
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  title: Text(activity.productName, style: AppTypography.bodyLarge),
                  subtitle: Text(
                    '${activity.action} • ${activity.userName}',
                    style: AppTypography.bodySmall,
                  ),
                  trailing: Text(
                    _formatTime(activity.timestamp),
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showQuickActions(context),
      icon: Icon(Icons.add_rounded),
      label: Text('Quick Action'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadiusXl)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quick Actions', style: AppTypography.titleLarge),
              SizedBox(height: AppSpacing.lg),
              _buildActionTile(
                context,
                Icons.add_rounded,
                'Add Product',
                'Create a new product',
                () => context.push('/inventory/add'),
              ),
              _buildActionTile(
                context,
                Icons.add_circle_outline_rounded,
                'Stock In',
                'Receive new inventory',
                () => context.push('/stock/in'),
              ),
              _buildActionTile(
                context,
                Icons.remove_circle_outline_rounded,
                'Stock Out',
                'Record stock outflow',
                () => context.push('/stock/out'),
              ),
              _buildActionTile(
                context,
                Icons.shopping_cart_rounded,
                'Create Purchase',
                'Order from supplier',
                () => context.push('/purchases/create'),
              ),
              _buildActionTile(
                context,
                Icons.point_of_sale_rounded,
                'New Sale',
                'Record a sale',
                () => context.push('/sales/new'),
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      leading: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: AppSpacing.iconSizeMd),
      ),
      title: Text(title, style: AppTypography.bodyLarge),
      subtitle: Text(subtitle, style: AppTypography.bodySmall),
      trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Column(
      children: [
        _buildSkeletonStatsGrid(theme),
        SizedBox(height: AppSpacing.xl),
        _buildSkeletonCharts(theme),
        SizedBox(height: AppSpacing.xl),
        _buildSkeletonList(theme),
      ],
    );
  }

  Widget _buildSkeletonStatsGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.6,
      children: List.generate(4, (index) => _buildSkeletonCard(theme)),
    );
  }

  Widget _buildSkeletonCard(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: theme.extension<AppCustomTheme>()!.skeletonColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            height: 32,
            width: 150,
            decoration: BoxDecoration(
              color: theme.extension<AppCustomTheme>()!.skeletonColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            height: 16,
            width: 200,
            decoration: BoxDecoration(
              color: theme.extension<AppCustomTheme>()!.skeletonColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCharts(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildSkeletonChartCard(theme)),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _buildSkeletonChartCard(theme)),
      ],
    );
  }

  Widget _buildSkeletonChartCard(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: theme.extension<AppCustomTheme>()!.skeletonColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            height: AppSpacing.chartHeightSm,
            decoration: BoxDecoration(
              color: theme.extension<AppCustomTheme>()!.skeletonColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 150,
            decoration: BoxDecoration(
              color: theme.extension<AppCustomTheme>()!.skeletonColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
            itemBuilder: (_, __) => Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.extension<AppCustomTheme>()!.skeletonColor,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 150,
                        decoration: BoxDecoration(
                          color: theme.extension<AppCustomTheme>()!.skeletonColor,
                          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: theme.extension<AppCustomTheme>()!.skeletonColor,
                          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error, WidgetRef ref) {
    return AppErrorState(
      title: 'Failed to Load Dashboard',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.read(dashboardNotifierProvider.notifier).refresh(),
    );
  }

  List<FlSpot> _createSalesSpots(List<DailySalesData> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.revenue);
    }).toList();
  }

  List<FlSpot> _createPurchaseSpots(List<DailyPurchaseData> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  String _formatDay(String date) {
    try {
      final dt = DateTime.parse(date);
      return _getMonthShort(dt.month).substring(0, 3);
    } catch (_) {
      return date;
    }
  }

  String _getMonthShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${_getMonthShort(dateTime.month)} ${dateTime.day}';
  }

  IconData _getActivityIcon(String action) {
    switch (action.toLowerCase()) {
      case 'stock in':
        return Icons.add_circle_outline_rounded;
      case 'stock out':
        return Icons.remove_circle_outline_rounded;
      case 'purchase created':
        return Icons.shopping_cart_rounded;
      case 'purchase received':
        return Icons.local_shipping_rounded;
      case 'sale completed':
        return Icons.point_of_sale_rounded;
      default:
        return Icons.info_rounded;
    }
  }
}