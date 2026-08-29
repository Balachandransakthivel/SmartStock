import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  SizedBox(height: AppSpacing.xxl),
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
          AppConstants.appName,
          style: AppTypography.displaySmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Welcome back. Please sign in to continue.',
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
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
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
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              onSubmitted: (_) => _handleLogin(),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) => setState(() => _rememberMe = value ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                  ),
                ),
                Text('Remember me', style: AppTypography.bodyMedium),
                Spacer(),
                TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  child: Text('Forgot password?', style: AppTypography.labelMedium),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Sign In',
              onPressed: isLoading ? null : _handleLogin,
              isLoading: isLoading,
              size: AppButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: theme.dividerColor)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('or', style: AppTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              )),
            ),
            Expanded(child: Divider(color: theme.dividerColor)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Create Account',
          onPressed: () => context.push('/register'),
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.lg,
          leadingIcon: Icons.person_add_rounded,
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          'By continuing, you agree to our Terms of Service and Privacy Policy',
          style: AppTypography.bodySmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authNotifierProvider.notifier).login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
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