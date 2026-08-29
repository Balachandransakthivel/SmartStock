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

class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final dashboardAsync = ref.watch(staffDashboardNotifierProvider);

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/scan'),
        child: Icon(Icons.qr_code_scanner_rounded),
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
            Text('Staff Dashboard', style: AppTypography.headlineMedium),
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
                theme.colorScheme.tertiaryContainer,
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

  Widget _buildDashboardContent(BuildContext context, ThemeData theme, StaffDashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsGrid(context, theme, stats),
        SizedBox(height: AppSpacing.xl),
        _buildQuickActions(context, theme, stats.quickActions),
        SizedBox(height: AppSpacing.xl),
        _buildRecentActivity(context, theme, stats),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, ThemeData theme, StaffDashboardStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.6,
      children: [
        AppStatCard(
          label: 'Assigned Products',
          value: stats.assignedProducts.toString(),
          icon: Icons.inventory_2_rounded,
          iconColor: theme.colorScheme.primary,
        ),
        AppStatCard(
          label: 'Low Stock Items',
          value: stats.lowStockProducts.toString(),
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
        ),
        AppStatCard(
          label: 'Tasks',
          value: stats.tasksCount.toString(),
          icon: Icons.task_alt_rounded,
          iconColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme, List<QuickAction> actions) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1,
            children: actions.map((action) => _buildActionCard(context, theme, action)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, ThemeData theme, QuickAction action) {
    return InkWell(
      onTap: action.isEnabled ? () => context.push(action.route) : null,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: action.isEnabled 
              ? theme.colorScheme.surfaceContainer 
              : theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          border: Border.all(
            color: action.isEnabled 
                ? theme.dividerColor 
                : theme.dividerColor.withAlphaValue(0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              action.icon,
              size: AppSpacing.iconSizeLg,
              color: action.isEnabled 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.onSurfaceVariant.withAlphaValue(0.5),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              action.label,
              style: AppTypography.bodyMedium.copyWith(
                color: action.isEnabled 
                    ? theme.colorScheme.onSurface 
                    : theme.colorScheme.onSurfaceVariant.withAlphaValue(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, ThemeData theme, StaffDashboardStats stats) {
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

  Widget _buildLoadingState(ThemeData theme) => Column(
    children: [
      _buildSkeletonStatsGrid(theme),
      SizedBox(height: AppSpacing.xl),
      _buildSkeletonCard(theme),
    ],
  );

  Widget _buildSkeletonStatsGrid(ThemeData theme) => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: AppSpacing.md,
    crossAxisSpacing: AppSpacing.md,
    childAspectRatio: 1.6,
    children: List.generate(3, (index) => _buildSkeletonCard(theme)),
  );

  Widget _buildSkeletonCard(ThemeData theme) => AppCard(
    padding: AppSpacing.cardPadding,
    child: Container(
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
    onAction: () => ref.read(staffDashboardNotifierProvider.notifier).refresh(),
  );

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${_getMonthShort(dateTime.month)} ${dateTime.day}';
  }

  String _getMonthShort(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
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