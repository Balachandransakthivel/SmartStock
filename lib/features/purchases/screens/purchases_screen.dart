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

class PurchasesScreen extends ConsumerStatefulWidget {
  const PurchasesScreen({super.key});

  @override
  ConsumerState<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends ConsumerState<PurchasesScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  PurchaseStatus? _selectedStatus;
  String? _selectedSupplierId;

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
      ref.read(purchaseFiltersNotifierProvider.notifier).nextPage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final purchasesAsync = ref.watch(filteredPurchasesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchases'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: theme.colorScheme.onSurface),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.add_rounded, color: theme.colorScheme.onSurface),
            onPressed: () => context.push('/purchases/create'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context, theme),
          _buildStatusFilters(context, theme),
          Expanded(
            child: purchasesAsync.when(
              data: (response) => _buildPurchaseList(context, theme, response, authState),
              loading: () => _buildLoadingList(theme),
              error: (error, stack) => _buildErrorState(context, theme, error.toString(), ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: AppSearchField(
        controller: _searchController,
        hint: 'Search purchases...',
        onChanged: (value) {
          ref.read(purchaseFiltersNotifierProvider.notifier).updateSearch(value);
        },
      ),
    );
  }

  Widget _buildStatusFilters(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatusChip(theme, null, 'All'),
            _buildStatusChip(theme, PurchaseStatus.pending, 'Pending'),
            _buildStatusChip(theme, PurchaseStatus.ordered, 'Ordered'),
            _buildStatusChip(theme, PurchaseStatus.received, 'Received'),
            _buildStatusChip(theme, PurchaseStatus.cancelled, 'Cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, PurchaseStatus? status, String label) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.onPrimaryContainer : status.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6),
            ],
            Text(label, style: AppTypography.labelMedium),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = selected ? status : null;
            ref.read(purchaseFiltersNotifierProvider.notifier).updateStatus(_selectedStatus);
          });
        },
        backgroundColor: theme.colorScheme.surfaceContainer,
        selectedColor: status?.color.withAlphaValue(0.2) ?? theme.colorScheme.primaryContainer,
        labelStyle: AppTypography.labelMedium,
      ),
    );
  }

  Widget _buildPurchaseList(
    BuildContext context,
    ThemeData theme,
    PurchaseListResponse response,
    AuthState authState,
  ) {
    if (response.purchases.isEmpty) {
      return AppEmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'No purchases found',
        message: 'Create your first purchase order',
        actionLabel: 'Create Purchase',
        onAction: () => context.push('/purchases/create'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(filteredPurchasesProvider),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 100),
        itemCount: response.purchases.length + (response.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == response.purchases.length) {
            return Center(
              child: Padding(
                padding: AppSpacing.screenPaddingVertical,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final purchase = response.purchases[index];
          final canManage = authState.maybeWhen(
            authenticated: (user, _) => user.role.canCreatePurchases,
            orElse: () => false,
          );
          return _buildPurchaseTile(context, theme, purchase, canManage);
        },
      ),
    );
  }

  Widget _buildPurchaseTile(
    BuildContext context,
    ThemeData theme,
    Purchase purchase,
    bool canManage,
  ) {
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      onTap: () => context.push('/purchases/${purchase.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(purchase.purchaseNumber, style: AppTypography.titleMedium),
                    Text(purchase.supplierName, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              AppStatusBadge(purchaseStatus: purchase.status),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(width: AppSpacing.xs),
              Text('Ordered: ${_formatDate(purchase.orderDate)}', style: AppTypography.bodySmall),
              SizedBox(width: AppSpacing.md),
              if (purchase.expectedDeliveryDate != null) ...[
                Icon(Icons.local_shipping_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                SizedBox(width: AppSpacing.xs),
                Text('Expected: ${_formatDate(purchase.expectedDeliveryDate!)}', style: AppTypography.bodySmall),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text('${purchase.items.length} items', style: AppTypography.bodySmall),
              Spacer(),
              Text(
                '${AppConstants.currencySymbol}${_formatNumber(purchase.totalAmount)}',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (purchase.status == PurchaseStatus.ordered && canManage) ...[
            SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Mark as Received',
                onPressed: () => _receivePurchase(context, purchase.id),
                variant: AppButtonVariant.primary,
                size: AppButtonSize.sm,
                leadingIcon: Icons.check_circle_rounded,
              ),
            ),
          ],
        ],
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
              // Additional filters
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
      itemBuilder: (_, __) => _buildSkeletonPurchaseTile(theme),
    );
  }

  Widget _buildSkeletonPurchaseTile(ThemeData theme) {
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(height: 20, width: 150, color: theme.extension<AppCustomTheme>()!.skeletonColor),
              Spacer(),
              Container(height: 24, width: 80, color: theme.extension<AppCustomTheme>()!.skeletonColor),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Container(height: 14, width: 200, color: theme.extension<AppCustomTheme>()!.skeletonColor),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(height: 12, width: 80, color: theme.extension<AppCustomTheme>()!.skeletonColor),
              Spacer(),
              Container(height: 18, width: 100, color: theme.extension<AppCustomTheme>()!.skeletonColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error, WidgetRef ref) {
    return AppErrorState(
      title: 'Failed to Load Purchases',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.invalidate(filteredPurchasesProvider),
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
}