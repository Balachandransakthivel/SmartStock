import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/supplier_provider.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

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
      ref.read(supplierFiltersNotifierProvider.notifier).nextPage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final suppliersAsync = ref.watch(filteredSuppliersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: theme.colorScheme.onSurface),
            onPressed: () => _showAddSupplierDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context, theme),
          Expanded(
            child: suppliersAsync.when(
              data: (response) => _buildSupplierList(context, theme, response, authState),
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
        hint: 'Search suppliers...',
        onChanged: (value) {
          ref.read(supplierFiltersNotifierProvider.notifier).updateSearch(value);
        },
        onSubmitted: () => ref.read(supplierFiltersNotifierProvider.notifier).updateSearch(_searchController.text),
      ),
    );
  }

  Widget _buildSupplierList(
    BuildContext context,
    ThemeData theme,
    SupplierListResponse response,
    AuthState authState,
  ) {
    if (response.suppliers.isEmpty) {
      return AppEmptyState(
        icon: Icons.business_outlined,
        title: 'No suppliers found',
        message: 'Add your first supplier to get started',
        actionLabel: 'Add Supplier',
        onAction: () => _showAddSupplierDialog(context),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(filteredSuppliersProvider),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 100),
        itemCount: response.suppliers.length + (response.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == response.suppliers.length) {
            return Center(
              child: Padding(
                padding: AppSpacing.screenPaddingVertical,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final supplier = response.suppliers[index];
          final canManage = authState.maybeWhen(
            authenticated: (user, _) => user.role.canManageSuppliers,
            orElse: () => false,
          );
          return AppSupplierTile(
            companyName: supplier.companyName,
            contactPerson: supplier.contactPerson,
            phone: supplier.phone,
            email: supplier.email,
            totalPurchases: supplier.totalPurchases,
            pendingPayments: supplier.pendingPayments,
            productsSupplied: supplier.productsSupplied,
            onTap: () => context.push('/suppliers/${supplier.id}'),
          );
        },
      ),
    );
  }

  void _showAddSupplierDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final gstController = TextEditingController();
    final panController = TextEditingController();
    final bankController = TextEditingController();
    final ifscController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadiusXl)),
      ),
      builder: (context) => SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('Add Supplier', style: AppTypography.titleLarge),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppTextField(
                          controller: nameController,
                          label: 'Company Name *',
                          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: contactController,
                          label: 'Contact Person *',
                          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: phoneController,
                          label: 'Phone *',
                          keyboardType: TextInputType.phone,
                          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: emailController,
                          label: 'Email *',
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Required';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v!)) return 'Invalid email';
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: addressController,
                          label: 'Address *',
                          maxLines: 2,
                          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: gstController,
                          label: 'GST Number',
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: panController,
                          label: 'PAN Number',
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: bankController,
                          label: 'Bank Account',
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: ifscController,
                          label: 'IFSC Code',
                        ),
                      ],
                    ),
                  ),
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
                        label: 'Add Supplier',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ref.read(supplierNotifierProvider.notifier).createSupplier(SupplierCreateRequest(
                              companyName: nameController.text.trim(),
                              contactPerson: contactController.text.trim(),
                              phone: phoneController.text.trim(),
                              email: emailController.text.trim(),
                              address: addressController.text.trim(),
                              gstNumber: gstController.text.trim().isEmpty ? null : gstController.text.trim(),
                              panNumber: panController.text.trim().isEmpty ? null : panController.text.trim(),
                              bankAccount: bankController.text.trim().isEmpty ? null : bankController.text.trim(),
                              ifscCode: ifscController.text.trim().isEmpty ? null : ifscController.text.trim(),
                            )).then((_) {
                              Navigator.pop(context);
                              showAppSnackBar(
                                context: context,
                                message: 'Supplier added successfully',
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
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingList(ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 100),
      itemCount: 6,
      itemBuilder: (_, __) => _buildSkeletonSupplierTile(theme),
    );
  }

  Widget _buildSkeletonSupplierTile(ThemeData theme) {
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
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
      title: 'Failed to Load Suppliers',
      message: error,
      actionLabel: 'Retry',
      onAction: () => ref.invalidate(filteredSuppliersProvider),
    );
  }
}