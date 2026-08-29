import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class ManagerDashboardScreen extends ConsumerWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final dashboardAsync = ref.watch(managerDashboardNotifierProvider);

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickActions(context),
        icon: Icon(Icons.add_rounded),
        label: Text('Quick Action'),
      ),
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
            Text('Manager Dashboard', style: AppTypography.headlineMedium),
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
                theme.colorScheme.secondaryContainer,
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

  Widget _buildDashboardContent(BuildContext context, ThemeData theme, ManagerDashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsGrid(context, theme, stats),
        SizedBox(height: AppSpacing.xl),
        _buildReorderSummary(context, theme, stats),
        SizedBox(height: AppSpacing.xl),
        _buildSalesChart(context, theme, stats),
        SizedBox(height: AppSpacing.xl),
        _buildRecentActivity(context, theme, stats),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, ThemeData theme, ManagerDashboardStats stats) {
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
        ),
        AppStatCard(
          label: 'Stock Value',
          value: '${AppConstants.currencySymbol}${_formatNumber(stats.totalStockValue)}',
          icon: Icons.attach_money_rounded,
          iconColor: Colors.green,
        ),
        AppStatCard(
          label: 'Today\'s Sales',
          value: stats.todaySales.toString(),
          subtitle: '${AppConstants.currencySymbol}${_formatNumber(stats.todayRevenue)}',
          icon: Icons.point_of_sale_rounded,
          iconColor: Colors.blue,
        ),
        AppStatCard(
          label: 'Pending Orders',
          value: stats.pendingPurchases.toString(),
          icon: Icons.pending_actions_rounded,
          iconColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildReorderSummary(BuildContext context, ThemeData theme, ManagerDashboardStats stats) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Smart Reorder Summary', style: AppTypography.titleLarge),
              Spacer(),
              AppButton(
                label: 'View All',
                onPressed: () => context.push('/reorder'),
                variant: AppButtonVariant.tertiary,
                size: AppButtonSize.sm,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildReorderStat(
                  theme,
                  'Critical',
                  stats.reorderSummary.critical.toString(),
                  Colors.red,
                  Icons.warning_rounded,
                ),
              ),
              Expanded(
                child: _buildReorderStat(
                  theme,
                  'Soon',
                  stats.reorderSummary.soon.toString(),
                  Colors.orange,
                  Icons.schedule_rounded,
                ),
              ),
              Expanded(
                child: _buildReorderStat(
                  theme,
                  'Normal',
                  stats.reorderSummary.normal.toString(),
                  Colors.green,
                  Icons.check_circle_rounded,
                ),
              ),
              Expanded(
                child: _buildReorderStat(
                  theme,
                  'Total',
                  stats.reorderSummary.totalNeedingAttention.toString(),
                  theme.colorScheme.primary,
                  Icons.notification_important_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReorderStat(
    ThemeData theme,
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
        Text(value, style: AppTypography.headlineSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        )),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }

  Widget _buildSalesChart(BuildContext context, ThemeData theme, ManagerDashboardStats stats) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales (Last 7 Days)', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.md),
          AppLineChart(
            spots: _createSalesSpots(stats.salesLast7Days),
            xLabels: stats.salesLast7Days.map((d) => _formatDay(d.date)).toList(),
            lineColor: Colors.green,
            height: AppSpacing.chartHeightMd,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, ThemeData theme, ManagerDashboardStats stats) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.md),
          if (stats.recentActivity.isEmpty)
            AppEmptyState(
              icon: Icons.history_rounded,
              title: 'No recent activity',
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
                  subtitle: Text('${activity.action} • ${activity.userName}', style: AppTypography.bodySmall),
                  trailing: Text(_formatTime(activity.timestamp), style: AppTypography.bodySmall),
                );
              },
            ),
        ],
      ),
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
              _buildActionTile(context, Icons.add_rounded, 'Add Product', 'Create a new product', () => context.push('/inventory/add')),
              _buildActionTile(context, Icons.add_circle_outline_rounded, 'Stock In', 'Receive new inventory', () => context.push('/stock/in')),
              _buildActionTile(context, Icons.shopping_cart_rounded, 'Create Purchase', 'Order from supplier', () => context.push('/purchases/create')),
              _buildActionTile(context, Icons.point_of_sale_rounded, 'New Sale', 'Record a sale', () => context.push('/sales/new')),
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

  Widget _buildLoadingState(ThemeData theme) => Column(
    children: [
      _buildSkeletonStatsGrid(theme),
      SizedBox(height: AppSpacing.xl),
      _buildSkeletonCard(theme, height: 200),
      SizedBox(height: AppSpacing.xl),
      _buildSkeletonCard(theme, height: AppSpacing.chartHeightMd),
    ],
  );

  Widget _buildSkeletonStatsGrid(ThemeData theme) => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: AppSpacing.md,
    crossAxisSpacing: AppSpacing.md,
    childAspectRatio: 1.6,
    children: List.generate(4, (index) => _buildSkeletonCard(theme)),
  );

  Widget _buildSkeletonCard(ThemeData theme, {double? height}) => AppCard(
    padding: AppSpacing.cardPadding,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.extension<AppCustomTheme>()!.skeletonColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
    ),
  );

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error, WidgetRef ref) => AppErrorState(
    title: 'Failed to Load Dashboard',
    message: error,
    actionLabel: 'Retry',
    onAction: () => ref.read(managerDashboardNotifierProvider.notifier).refresh(),
  );

  List<FlSpot> _createSalesSpots(List<DailySalesData> data) => data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.revenue)).toList();

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  String _formatDay(String date) {
    try {
      final dt = DateTime.parse(date);
      return _getMonthShort(dt.month);
    } catch (_) {
      return date;
    }
  }

  String _getMonthShort(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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
      case 'stock in': return Icons.add_circle_outline_rounded;
      case 'stock out': return Icons.remove_circle_outline_rounded;
      case 'purchase created': return Icons.shopping_cart_rounded;
      case 'purchase received': return Icons.local_shipping_rounded;
      case 'sale completed': return Icons.point_of_sale_rounded;
      default: return Icons.info_rounded;
    }
  }
}