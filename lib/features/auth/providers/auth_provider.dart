import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  AuthState build() {
    _apiClient.initialize();
    _checkInitialAuth();
    return const AuthState.initial();
  }

  Future<void> _checkInitialAuth() async {
    final token = await _apiClient.getAuthToken();
    if (token != null && token.isNotEmpty) {
      // Token exists, try to validate it by fetching user profile
      // For now, we'll just mark as unauthenticated and let the app handle it
      // In a real app, you'd call an API to validate the token
      state = const AuthState.unauthenticated();
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = const AuthState.loading();
    
    try {
      final request = LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        final tokens = AuthTokens.fromJson(response.data['tokens']);
        final user = User.fromJson(response.data['user']);
        
        await _apiClient.setAuthToken(tokens.accessToken);
        
        state = AuthState.authenticated(user, tokens);
      } else {
        final message = response.data['message'] ?? 'Login failed';
        state = AuthState.error(message);
      }
    } on DioException catch (e) {
      state = AuthState.error(e.toApiException().message);
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String businessName,
  }) async {
    state = const AuthState.loading();
    
    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        phone: phone,
        password: password,
        businessName: businessName,
      );
      
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: request.toJson(),
      );
      
      if (response.statusCode == 201) {
        final tokens = AuthTokens.fromJson(response.data['tokens']);
        final user = User.fromJson(response.data['user']);
        
        await _apiClient.setAuthToken(tokens.accessToken);
        
        state = AuthState.authenticated(user, tokens);
      } else {
        final message = response.data['message'] ?? 'Registration failed';
        state = AuthState.error(message);
      }
    } on DioException catch (e) {
      state = AuthState.error(e.toApiException().message);
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  Future<void> forgotPassword(String email) async {
    state = const AuthState.loading();
    
    try {
      final request = ForgotPasswordRequest(email: email);
      
      final response = await _apiClient.dio.post(
        '/auth/forgot-password',
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        state = const AuthState.unauthenticated();
      } else {
        final message = response.data['message'] ?? 'Failed to send reset email';
        state = AuthState.error(message);
      }
    } on DioException catch (e) {
      state = AuthState.error(e.toApiException().message);
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AuthState.loading();
    
    try {
      final request = ResetPasswordRequest(
        token: token,
        password: password,
        confirmPassword: confirmPassword,
      );
      
      final response = await _apiClient.dio.post(
        '/auth/reset-password',
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        state = const AuthState.unauthenticated();
      } else {
        final message = response.data['message'] ?? 'Failed to reset password';
        state = AuthState.error(message);
      }
    } on DioException catch (e) {
      state = AuthState.error(e.toApiException().message);
    } catch (e) {
      state = AuthState.error('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    await _apiClient.clearAuthToken();
    state = const AuthState.unauthenticated();
  }

  void clearError() {
    if (state is _Error) {
      state = const AuthState.unauthenticated();
    }
  }
}

@riverpod
ApiClient apiClient(Ref ref) {
  final client = ApiClient();
  client.initialize();
  return client;
}

@riverpod
User? currentUser(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (user, tokens) => user,
    orElse: () => null,
  );
}

@riverpod
AuthTokens? authTokens(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (user, tokens) => tokens,
    orElse: () => null,
  );
}

@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (_, _) => true,
    orElse: () => false,
  );
}

@riverpod
UserRole? currentUserRole(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role;
}