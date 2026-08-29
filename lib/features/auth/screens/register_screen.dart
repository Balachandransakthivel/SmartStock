import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _businessNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is _Loading;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is _Authenticated) {
        _navigateBasedOnRole(next.user.role);
      } else if (next is _Error) {
        showAppSnackBar(
          context: context,
          message: next.message,
          type: AppSnackBarType.error,
        );
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppSizing.maxCardWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(theme),
                  SizedBox(height: AppSpacing.xl),
                  _buildForm(theme, isLoading),
                  SizedBox(height: AppSpacing.lg),
                  _buildFooter(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
          ),
          child: Icon(
            Icons.inventory_2_rounded,
            size: AppSpacing.iconSizeXl,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          'Create Account',
          style: AppTypography.displaySmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Join SmartStock and manage your inventory smarter',
          style: AppTypography.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(ThemeData theme, bool isLoading) {
    return AppCard(
      padding: AppSpacing.cardPaddingLg,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              textInputAction: TextInputAction.next,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _businessNameController,
              label: 'Business Name',
              hint: 'Enter your business name',
              textInputAction: TextInputAction.next,
              prefixIcon: Icon(
                Icons.business_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your business name';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Create a password',
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Confirm your password',
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              onSubmitted: (_) => _handleRegister(),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodyMedium,
                        children: [
                          TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Create Account',
              onPressed: isLoading || !_agreeToTerms ? null : _handleRegister,
              isLoading: isLoading,
              size: AppButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account? ', style: AppTypography.bodyMedium),
        TextButton(
          onPressed: () => context.pop(),
          child: Text('Sign In', style: AppTypography.labelMedium),
        ),
      ],
    );
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreeToTerms) {
        showAppSnackBar(
          context: context,
          message: 'Please agree to the Terms of Service and Privacy Policy',
          type: AppSnackBarType.warning,
        );
        return;
      }
      
      ref.read(authNotifierProvider.notifier).register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        businessName: _businessNameController.text.trim(),
      );
    }
  }

  void _navigateBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        context.go('/admin/dashboard');
        break;
      case UserRole.manager:
        context.go('/manager/dashboard');
        break;
      case UserRole.staff:
        context.go('/staff/dashboard');
        break;
    }
  }
}