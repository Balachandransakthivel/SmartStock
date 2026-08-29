import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart'
import '../providers/sale_provider.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  PaymentMethod? _selectedPaymentMethod;

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
      ref.read(saleFiltersNotifierProvider.notifier).nextPage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final salesAsync = ref.watch(filteredSalesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: theme.colorScheme.onSurface),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.add_rounded, color: theme.colorScheme.onSurface),
            onPressed: () => context.push('/sales/new'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context, theme),
          _buildPaymentMethodFilters(context, theme),
          Expanded(
            child: salesAsync.when(
              data: (response) => _buildSaleList(context, theme, response, authState),
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
        hint: 'Search sales...',
        onChanged: (value) {
          ref.read(saleFiltersNotifierProvider.notifier).updateSearch(value);
        },
      ),
    );
  }

  Widget _buildPaymentMethodFilters(BuildContext context, ThemeData theme) {
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
            _buildPaymentChip(theme, null, 'All'),
            _buildPaymentChip(theme, PaymentMethod.cash, 'Cash'),
            _buildPaymentChip(theme, PaymentMethod.upi, 'UPI'),
            _buildPaymentChip(theme, PaymentMethod.card, 'Card'),
            _buildPaymentChip(theme, PaymentMethod.other, 'Other'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentChip(ThemeData theme, PaymentMethod? method, String label) {
    final isSelected = _selectedPaymentMethod == method;
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label, style: AppTypography.labelMedium),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedPaymentMethod = selected ? method : null;
            ref.read(saleFiltersNotifierProvider.notifier).updatePaymentMethod(_selectedPaymentMethod);
          });
        },
        backgroundColor: theme.colorScheme.surfaceContainer,
        selectedColor: theme.colorScheme.primaryContainer,
        labelStyle: AppTypography.labelMedium,
      ),
    );
  }

  Widget _buildSaleList(
    BuildContext context,
    ThemeData theme,
    SaleListResponse response,
    AuthState authState,
  ) {
    if (response.sales.isEmpty) {
      return AppEmptyState(
        icon: Icons.point_of_sale_outlined,
        title: 'No sales found',
        message: 'Record your first sale',
        actionLabel: 'New Sale',
        onAction: () => context.push('/sales/new'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(filteredSalesProvider),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 100),
        itemCount: response.sales.length + (response.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == response.sales.length) {
            return Center(
              child: Padding(
                padding: AppSpacing.screenPaddingVertical,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final sale = response.sales[index];
          return _buildSaleTile(context, theme, sale);
        },
      ),
    );
  }

  Widget _buildSaleTile(BuildContext context, ThemeData theme, Sale sale) {
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      onTap: () => context.push('/sales/${sale.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sale.saleNumber, style: AppTypography.titleMedium),
                    if (sale.customerName != null)
                      Text(sale.customerName!, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              AppStatusBadge(paymentMethod: sale.paymentMethod),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(width: AppSpacing.xs),
              Text(_formatDate(sale.saleDate), style: AppTypography.bodySmall),
              SizedBox(width: AppSpacing.md),
              Text('${sale.items.length} items', style: AppTypography.bodySmall),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Spacer(),
              Text(
                '${AppConstants.currencySymbol}${_formatNumber(sale.totalAmount)}',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600, color: Colors.green),
              ),
            ],
          ),
        ],
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
      itemBuilder: (_, __) => _buildSkeletonSaleTile(theme),
    );
  }

  Widget _buildSkeletonSaleTile(ThemeData theme) {
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
      title: 'Failed to Load Sales',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.invalidate(filteredSalesProvider),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(2);
  }
}