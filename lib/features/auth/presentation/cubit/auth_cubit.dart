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
      emit(AuthError(message: 'Invalid email or password'));
    }
  }
  Future<void> logout() async {
    emit(const AuthLoading());
    await _logoutUseCase();
    emit(const AuthUnauthenticated());
  }
}
