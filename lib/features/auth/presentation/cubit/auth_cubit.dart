import 'package:field_ops/features/auth/domain/entities/user_entity.dart';
import 'package:field_ops/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:field_ops/features/auth/domain/usecases/login_usecase.dart';
import 'package:field_ops/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final GetCurrentUserUsecase _getCurrentUserUseCase;
  final LogoutUsecase _logoutUseCase;
  bool isNotVisible = true;
  AuthCubit({
    required LoginUseCase loginUseCase,
    required GetCurrentUserUsecase getCurrentUserUsecase,
    required LogoutUsecase logoutUsecase,
  }) : _loginUseCase = loginUseCase,
       _getCurrentUserUseCase = getCurrentUserUsecase,
       _logoutUseCase = logoutUsecase,
       super(AuthInitial());

  String message = '';
  void toggle() {
    isNotVisible = !isNotVisible;
    emit(AuthInitial());
  }

  UserEntity? get authenticatedUser =>
      state is AuthAuthenticated ? (state as AuthAuthenticated).user : null;

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    
    try {
      final user = await _loginUseCase(email: email, password: password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      final message = e.toString().contains('Access denied')
          ? 'Access denied. Only Technicians and Customers are allowed.'
          : 'Invalid email or password';
      emit(AuthError(message: message));
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    emit(const AuthUnauthenticated());
  }
}
