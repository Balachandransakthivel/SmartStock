import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is _Loading;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is _Unauthenticated && _emailSent) {
        setState(() => _emailSent = true);
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
              child: _emailSent ? _buildSuccessView(theme) : _buildFormView(theme, isLoading),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView(ThemeData theme, bool isLoading) {
    return Column(
      children: [
        _buildHeader(theme),
        SizedBox(height: AppSpacing.xl),
        _buildForm(theme, isLoading),
        SizedBox(height: AppSpacing.lg),
        _buildFooter(theme),
      ],
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).extension<AppCustomTheme>()!.successContainer,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: AppSpacing.iconSizeXl,
            color: Theme.of(context).extension<AppCustomTheme>()!.successColor,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          'Email Sent!',
          style: AppTypography.displaySmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'We\'ve sent a password reset link to ${_emailController.text}. Please check your inbox and follow the instructions to reset your password.',
          style: AppTypography.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.xl),
        AppButton(
          label: 'Back to Sign In',
          onPressed: () => context.go('/login'),
          variant: AppButtonVariant.primary,
          size: AppButtonSize.lg,
        ),
        SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: () => _resendEmail(),
          child: Text(
            'Didn\'t receive the email? Resend',
            style: AppTypography.labelMedium,
          ),
        ),
      ],
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
            Icons.lock_reset_rounded,
            size: AppSpacing.iconSizeXl,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          'Forgot Password',
          style: AppTypography.displaySmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Enter your email and we\'ll send you a link to reset your password.',
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
              hint: 'Enter your registered email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
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
                return null,
              },
              onSubmitted: (_) => _handleForgotPassword(),
            ),
            SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Send Reset Link',
              onPressed: isLoading ? null : _handleForgotPassword,
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
        Text('Remember your password? ', style: AppTypography.bodyMedium),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text('Sign In', style: AppTypography.labelMedium),
        ),
      ],
    );
  }

  void _handleForgotPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      _emailSent = true;
      ref.read(authNotifierProvider.notifier).forgotPassword(_emailController.text.trim());
    }
  }

  void _resendEmail() {
    setState(() => _emailSent = false);
    _handleForgotPassword();
  }
}