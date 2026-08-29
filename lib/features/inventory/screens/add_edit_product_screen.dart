import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/widgets.dart';
import '../providers/inventory_provider.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final String? productId;

  const AddEditProductScreen({super.key, this.productId});

  @override
  ConsumerState<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _currentStockController = TextEditingController();
  final _minimumStockController = TextEditingController();
  final _maximumStockController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedSupplierId;
  XFile? _selectedImage;
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.productId != null;
    if (_isEditing) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    // In a real app, you'd fetch the product and populate fields
    // For now, we'll just set some defaults
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _currentStockController.dispose();
    _minimumStockController.dispose();
    _maximumStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            _buildImagePicker(context, theme),
            SizedBox(height: AppSpacing.lg),
            _buildBasicInfoSection(theme),
            SizedBox(height: AppSpacing.lg),
            _buildPricingSection(theme),
            SizedBox(height: AppSpacing.lg),
            _buildStockSection(theme),
            SizedBox(height: AppSpacing.lg),
            _buildCategorySupplierSection(theme, categoriesAsync),
            SizedBox(height: AppSpacing.lg),
            _buildDescriptionSection(theme),
            SizedBox(height: AppSpacing.xl),
            _buildActionButtons(theme),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                child: Image.file(
                  _selectedImage!.path,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: AppSpacing.iconSizeXl,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Add Product Image',
                    style: AppTypography.titleMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Tap to select from gallery or camera',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBasicInfoSection(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _nameController,
            label: 'Product Name *',
            hint: 'Enter product name',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Product name is required';
              return null;
            },
          ),
          SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _skuController,
            label: 'SKU *',
            hint: 'Enter SKU (e.g., WM001)',
            validator: (value) {
              if (value == null || value.isEmpty) return 'SKU is required';
              return null;
            },
          ),
          SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _barcodeController,
            label: 'Barcode',
            hint: 'Scan or enter barcode',
            suffixIcon: IconButton(
              icon: Icon(Icons.qr_code_scanner_rounded),
              onPressed: () => context.push('/scan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pricing', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppNumberField(
                  controller: _purchasePriceController,
                  label: 'Purchase Price *',
                  hint: '0.00',
                  prefixText: '${AppConstants.currencySymbol} ',
                  decimalPlaces: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppNumberField(
                  controller: _sellingPriceController,
                  label: 'Selling Price *',
                  hint: '0.00',
                  prefixText: '${AppConstants.currencySymbol} ',
                  decimalPlaces: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid';
                    final purchase = double.tryParse(_purchasePriceController.text) ?? 0;
                    final selling = double.tryParse(value) ?? 0;
                    if (selling < purchase) return 'Must be ≥ purchase price';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockSection(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Levels', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppNumberField(
                  controller: _currentStockController,
                  label: 'Current Stock *',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppNumberField(
                  controller: _minimumStockController,
                  label: 'Min Stock *',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          AppNumberField(
            controller: _maximumStockController,
            label: 'Max Stock *',
            hint: '0',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              final min = int.tryParse(_minimumStockController.text) ?? 0;
              final max = int.tryParse(value) ?? 0;
              if (max < min) return 'Must be ≥ min stock';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySupplierSection(ThemeData theme, AsyncValue<List<Category>> categoriesAsync) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category & Supplier', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          categoriesAsync.when(
            data: (categories) => AppDropdownField<String>(
              label: 'Category *',
              hint: 'Select category',
              value: _selectedCategoryId,
              items: categories.map((cat) => DropdownMenuItem(
                value: cat.id,
                child: Text(cat.name),
              )).toList(),
              onChanged: (value) => setState(() => _selectedCategoryId = value),
              validator: (value) => value == null ? 'Category is required' : null,
            ),
            loading: () => AppTextField(
              label: 'Category',
              hint: 'Loading...',
              enabled: false,
            ),
            error: (_, __) => AppTextField(
              label: 'Category',
              hint: 'Failed to load categories',
              enabled: false,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Supplier',
            hint: 'Select supplier (optional)',
            readOnly: true,
            suffixIcon: Icon(Icons.chevron_right_rounded),
            onTap: () {
              // Navigate to supplier selection
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    return AppCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTypography.titleLarge),
          SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Enter product description (optional)',
            maxLines: 4,
            keyboardType: TextInputType.multiline,
          ),
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
            label: _isEditing ? 'Update Product' : 'Create Product',
            onPressed: _isLoading ? null : _submitForm,
            isLoading: _isLoading,
            variant: AppButtonVariant.primary,
          ),
        ),
      ],
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final source = await _showImageSourceDialog();
    if (source != null) {
      final image = await picker.pickImage(source: source, imageQuality: 80);
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() {
    return showModalBottomSheet<ImageSource>(
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
              Text('Select Image Source', style: AppTypography.titleLarge),
              SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: Icon(Icons.camera_alt_rounded),
                title: Text('Camera', style: AppTypography.bodyLarge),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library_rounded),
                title: Text('Gallery', style: AppTypography.bodyLarge),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    if (_isEditing) {
      final request = ProductUpdateRequest(
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        categoryId: _selectedCategoryId,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        purchasePrice: double.tryParse(_purchasePriceController.text),
        sellingPrice: double.tryParse(_sellingPriceController.text),
        minimumStock: int.tryParse(_minimumStockController.text),
        maximumStock: int.tryParse(_maximumStockController.text),
        supplierId: _selectedSupplierId,
        // imageBase64: _selectedImage != null ? await _imageToBase64(_selectedImage!) : null,
      );

      ref.read(inventoryNotifierProvider.notifier).updateProduct(widget.productId!, request).then((_) {
        setState(() => _isLoading = false);
        context.pop();
        showAppSnackBar(
          context: context,
          message: 'Product updated successfully',
          type: AppSnackBarType.success,
        );
      }).catchError((error) {
        setState(() => _isLoading = false);
        showAppSnackBar(
          context: context,
          message: error.toString(),
          type: AppSnackBarType.error,
        );
      });
    } else {
      final request = ProductCreateRequest(
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        categoryId: _selectedCategoryId!,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        purchasePrice: double.parse(_purchasePriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        currentStock: int.parse(_currentStockController.text),
        minimumStock: int.parse(_minimumStockController.text),
        maximumStock: int.parse(_maximumStockController.text),
        supplierId: _selectedSupplierId,
        // imageBase64: _selectedImage != null ? await _imageToBase64(_selectedImage!) : null,
      );

      ref.read(inventoryNotifierProvider.notifier).createProduct(request).then((_) {
        setState(() => _isLoading = false);
        context.pop();
        showAppSnackBar(
          context: context,
          message: 'Product created successfully',
          type: AppSnackBarType.success,
        );
      }).catchError((error) {
        setState(() => _isLoading = false);
        showAppSnackBar(
          context: context,
          message: error.toString(),
          type: AppSnackBarType.error,
        );
      });
    }
  }

  void _confirmDelete() {
    showConfirmDialog(
      context: context,
      title: 'Delete Product',
      message: 'Are you sure you want to delete this product? This action cannot be undone.',
      confirmLabel: 'Delete',
      confirmVariant: AppButtonVariant.destructive,
      icon: Icons.delete_rounded,
      iconColor: Theme.of(context).colorScheme.error,
    ).then((confirmed) {
      if (confirmed == true && widget.productId != null) {
        ref.read(inventoryNotifierProvider.notifier).deleteProduct(widget.productId!);
        context.pop();
      }
    });
  }

  Future<String?> _imageToBase64(XFile image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }
}