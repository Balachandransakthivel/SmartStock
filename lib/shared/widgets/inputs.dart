import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null;
    final effectiveErrorText = widget.errorText;

    Widget textField = TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      autofocus: widget.autofocus,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        errorText: effectiveErrorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  size: AppSpacing.iconSizeSm,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: _toggleObscureText,
              )
            : widget.suffixIcon,
        counterText: '',
        filled: true,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textField,
        if (widget.maxLength != null && widget.controller != null) ...[
          SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${widget.controller?.text.length ?? 0}/${widget.maxLength}',
              style: AppTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;
  final bool autofocus;

  const AppSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = controller?.text.isNotEmpty ?? false;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withAlphaValue(0.6),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: theme.colorScheme.onSurfaceVariant,
          size: AppSpacing.iconSizeMd,
        ),
        suffixIcon: hasText
            ? IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: AppSpacing.iconSizeMd,
                ),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                  onChanged?.call('');
                },
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        contentPadding: AppSpacing.inputPadding,
      ),
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String? label;
  final String? hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T?>? validator;
  final bool enabled;
  final Widget? prefixIcon;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.items,
    this.label,
    this.hint,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        filled: true,
      ),
      style: AppTypography.bodyLarge,
      dropdownColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      isExpanded: true,
    );
  }
}

class AppChipInput extends StatefulWidget {
  final List<String> chips;
  final ValueChanged<List<String>> onChanged;
  final String? hint;
  final String? label;
  final int? maxChips;

  const AppChipInput({
    super.key,
    required this.chips,
    required this.onChanged,
    this.hint,
    this.label,
    this.maxChips,
  });

  @override
  State<AppChipInput> createState() => _AppChipInputState();
}

class _AppChipInputState extends State<AppChipInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addChip(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    if (widget.chips.contains(trimmed)) return;
    if (widget.maxChips != null && widget.chips.length >= widget.maxChips!) return;
    
    widget.onChanged([...widget.chips, trimmed]);
    _controller.clear();
  }

  void _removeChip(String chip) {
    widget.onChanged(widget.chips.where((c) => c != chip).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canAddMore = widget.maxChips == null || widget.chips.length < widget.maxChips!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTypography.labelMedium),
          SizedBox(height: AppSpacing.xs),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ...widget.chips.map((chip) => InputChip(
                  label: Text(chip, style: AppTypography.labelSmall),
                  onDeleted: () => _removeChip(chip),
                  deleteIconColor: theme.colorScheme.onSurfaceVariant,
                  backgroundColor: theme.colorScheme.surfaceContainer,
                  side: BorderSide(color: theme.dividerColor, width: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
                  ),
                )),
            if (canAddMore)
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: _addChip,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: widget.hint ?? 'Add',
                    hintStyle: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withAlphaValue(0.6),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class AppNumberField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<double>? onChangedValue;
  final FormFieldValidator<String>? validator;
  final double? min;
  final double? max;
  final int? decimalPlaces;
  final String? prefixText;
  final String? suffixText;
  final bool enabled;

  const AppNumberField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onChangedValue,
    this.validator,
    this.min,
    this.max,
    this.decimalPlaces,
    this.prefixText,
    this.suffixText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      keyboardType: TextInputType.numberWithOptions(decimal: decimalPlaces != null && decimalPlaces! > 0),
      inputFormatters: [
        if (decimalPlaces != null && decimalPlaces! > 0)
          _DecimalTextInputFormatter(decimalPlaces: decimalPlaces!)
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        onChanged?.call(value);
        if (onChangedValue != null && value.isNotEmpty) {
          onChangedValue!(double.tryParse(value) ?? 0);
        }
      },
      validator: validator,
      enabled: enabled,
      prefixText: prefixText,
      suffixText: suffixText,
    );
  }
}

class _DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  _DecimalTextInputFormatter({required this.decimalPlaces});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    
    final regex = RegExp(r'^\d*\.?\d{0,$decimalPlaces}$');
    if (!regex.hasMatch(text)) {
      return oldValue;
    }
    return newValue;
  }
}