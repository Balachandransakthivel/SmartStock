import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/widgets.dart';
import '../../suppliers/providers/supplier_provider.dart';
import '../../inventory/providers/inventory_provider.dart';
import '../providers/purchase_provider.dart';

class CreatePurchaseScreen extends ConsumerStatefulWidget {
  const CreatePurchaseScreen({super.key});

  @override
  ConsumerState<CreatePurchaseScreen> createState() => _CreatePurchaseScreenState();
}

class _CreatePurchaseScreenState extends ConsumerState<CreatePurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSupplierId;
  DateTime? _expectedDeliveryDate;
  final _notesController = TextEditingController();
  final List<_PurchaseItemForm> _items = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final suppliersAsync = ref.watch(filteredSuppliersProvider);
    final productsAsync = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Purchase Order'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded, color: theme.colorScheme.onSurface),
            onPressed: _isLoading ? null : _submitForm,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            _buildSupplierSection(theme, suppliersAsync),
            SizedBox(height: AppSpacing.lg),
            _buildDeliverySection(theme),
            SizedBox(height: AppSpacing.lg),
            _buildItemsSection(theme, productsAsync),
            SizedBox(height: AppSpacing.lg),
            _buildNotesSection(theme),
            SizedBox(height: AppSpacing.xl),
            _buildSummarySection(theme),
            SizedBox(height: AppSpacing.xl),
            _buildActionButtons(theme),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierSection(ThemeData theme, AsyncValue<SupplierListResponse> suppliersAsync) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Supplier', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          suppliersAsync.when(
            data: (response) => AppDropdownField<String>(
              label: 'Supplier *',
              hint: 'Select supplier',
              value: _selectedSupplierId,
              items: response.suppliers.map((s) => DropdownMenuItem(
                value: s.id,
                child: Text(s.companyName),
              )).toList(),
              onChanged: (value) => setState(() => _selectedSupplierId = value),
              validator: (value) => value == null ? 'Supplier is required' : null,
            ),
            loading: () => AppTextField(
              label: 'Supplier',
              hint: 'Loading...',
              enabled: false,
            ),
            error: (_, __) => AppTextField(
              label: 'Supplier',
              hint: 'Failed to load suppliers',
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.calendar_today_rounded, color: theme.colorScheme.onSurfaceVariant),
            title: Text('Expected Delivery Date', style: AppTypography.bodyLarge),
            subtitle: Text(
              _expectedDeliveryDate != null
                  ? '${_expectedDeliveryDate!.day}/${_expectedDeliveryDate!.month}/${_expectedDeliveryDate!.year}'
                  : 'Select date (optional)',
              style: AppTypography.bodyMedium,
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
            onTap: _pickDeliveryDate,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(ThemeData theme, AsyncValue<ProductListResponse> productsAsync) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Items', style: AppTypography.titleLarge),
              Spacer(),
              AppButton(
                label: 'Add Item',
                onPressed: () => _addItemDialog(context, productsAsync),
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.sm,
                leadingIcon: Icons.add_rounded,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          if (_items.isEmpty)
            AppEmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'No items added',
              message: 'Add products to your purchase order',
              actionLabel: 'Add Item',
              onAction: () => _addItemDialog(context, productsAsync),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, __) => AppSeparator(indent: 0, endIndent: 0),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _buildItemRow(context, theme, item, index);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, ThemeData theme, _PurchaseItemForm item, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product?.name ?? 'Select product', style: AppTypography.bodyLarge),
                if (item.product != null)
                  Text('SKU: ${item.product!.sku}', style: AppTypography.bodySmall),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextFormField(
              initialValue: item.quantity.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Qty',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd)),
              ),
              onChanged: (value) => setState(() => item.quantity = int.tryParse(value) ?? 0),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextFormField(
              initialValue: item.unitPrice.toStringAsFixed(2),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Price',
                prefixText: '${AppConstants.currencySymbol} ',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd)),
              ),
              onChanged: (value) => setState(() => item.unitPrice = double.tryParse(value) ?? 0),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_rounded, color: theme.colorScheme.error),
            onPressed: () => setState(() => _items.removeAt(index)),
          ),
        ],
      ),
    );
  }

  void _addItemDialog(BuildContext context, AsyncValue<ProductListResponse> productsAsync) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadiusXl)),
      ),
      builder: (context) => SafeArea(
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
                  Text('Add Item', style: AppTypography.titleLarge),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              productsAsync.when(
                data: (response) => Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: response.products.length,
                    itemBuilder: (context, index) {
                      final product = response.products[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(product.name[0].toUpperCase(), style: TextStyle(color: theme.colorScheme.primary)),
                        ),
                        title: Text(product.name, style: AppTypography.bodyLarge),
                        subtitle: Text('SKU: ${product.sku} • Stock: ${product.currentStock}', style: AppTypography.bodySmall),
                        trailing: Text(
                          '${AppConstants.currencySymbol}${product.purchasePrice.toStringAsFixed(2)}',
                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          setState(() {
                            _items.add(_PurchaseItemForm(
                              product: product,
                              quantity: 1,
                              unitPrice: product.purchasePrice,
                            ));
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (_, __) => Text('Failed to load products'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSection(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notes', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _notesController,
            label: 'Notes (optional)',
            hint: 'Additional notes for this purchase order',
            maxLines: 3,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(ThemeData theme) {
    final subtotal = _items.fold(0.0, (sum, item) => sum + (item.quantity * item.unitPrice));
    final tax = subtotal * 0.18; // 18% GST
    final total = subtotal + tax;

    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.md),
          _buildSummaryRow(theme, 'Subtotal (${_items.length} items)', '${AppConstants.currencySymbol}${_formatNumber(subtotal)}'),
          _buildSummaryRow(theme, 'Tax (18%)', '${AppConstants.currencySymbol}${_formatNumber(tax)}'),
          AppSeparator(),
          _buildSummaryRow(theme, 'Total', '${AppConstants.currencySymbol}${_formatNumber(total)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600) : AppTypography.bodyMedium),
          Text(value, style: isTotal ? AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary) : AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Cancel',
            onPressed: () => context.pop(),
            variant: AppButtonVariant.tertiary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppButton(
            label: 'Create Purchase Order',
            onPressed: _isLoading ? null : _submitForm,
            isLoading: _isLoading,
            variant: AppButtonVariant.primary,
          ),
        ),
      ],
    );
  }

  void _pickDeliveryDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expectedDeliveryDate ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) setState(() => _expectedDeliveryDate = date);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) {
      showAppSnackBar(context: context, message: 'Please add at least one item', type: AppSnackBarType.warning);
      return;
    }
    if (_selectedSupplierId == null) {
      showAppSnackBar(context: context, message: 'Please select a supplier', type: AppSnackBarType.warning);
      return;
    }

    setState(() => _isLoading = true);

    final request = PurchaseCreateRequest(
      supplierId: _selectedSupplierId!,
      items: _items.map((item) => PurchaseItemRequest(
        productId: item.product!.id,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
      )).toList(),
      expectedDeliveryDate: _expectedDeliveryDate,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    ref.read(purchaseNotifierProvider.notifier).createPurchase(request).then((_) {
      setState(() => _isLoading = false);
      context.pop();
      showAppSnackBar(context: context, message: 'Purchase order created successfully', type: AppSnackBarType.success);
    }).catchError((error) {
      setState(() => _isLoading = false);
      showAppSnackBar(context: context, message: error.toString(), type: AppSnackBarType.error);
    });
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(2);
  }
}

class _PurchaseItemForm {
  final Product product;
  int quantity;
  double unitPrice;

  _PurchaseItemForm({required this.product, required this.quantity, required this.unitPrice});
}