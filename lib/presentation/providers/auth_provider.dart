import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/domain/usecases/login_usecase.dart';
import 'package:flutter_application_1/domain/usecases/signup_usecase.dart';
import 'package:flutter_application_1/domain/usecases/check_login_status_usecase.dart';

// Providers for dependencies
final authDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(dataSource: ref.read(authDataSourceProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(repository: ref.read(authRepositoryProvider));
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(repository: ref.read(authRepositoryProvider));
});

final checkLoginStatusUseCaseProvider = Provider<CheckLoginStatusUseCase>((ref) {
  return CheckLoginStatusUseCase(repository: ref.read(authRepositoryProvider));
});

// Auth state
enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final CheckLoginStatusUseCase _checkLoginStatusUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required CheckLoginStatusUseCase checkLoginStatusUseCase,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _checkLoginStatusUseCase = checkLoginStatusUseCase,
        super(AuthState(status: AuthStatus.initial));

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _checkLoginStatusUseCase();
    if (isLoggedIn) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(status: AuthStatus.authenticating);
      
      final user = await _loginUseCase(email, password);
      
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Invalid credentials',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      state = state.copyWith(status: AuthStatus.authenticating);
      
      final user = await _signupUseCase(name, email, password);
      
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Error creating account',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void logout() async {
    final authRepository = AuthRepositoryImpl(dataSource: AuthLocalDataSource());
    await authRepository.logout();
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      errorMessage: null, // Clear any previous error messages
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    signupUseCase: ref.read(signupUseCaseProvider),
    checkLoginStatusUseCase: ref.read(checkLoginStatusUseCaseProvider),
  );
});