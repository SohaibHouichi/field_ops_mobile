import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_ops/features/auth/data/models/DTO/login_request_dto.dart';
import 'package:field_ops/features/auth/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late AuthRepository authRepository;
  bool isNotVisible = true;
  AuthCubit(this.authRepository) : super(AuthInitial());

  String message = '';
  void toggle() {
    isNotVisible = !isNotVisible;
    emit(AuthInitial());
  }

  Future<void> login(LoginRequestDto req) async {
    emit(AuthLoading());
    final res = await authRepository.login(req);
    if (res.statusCode == 200) {
      emit(AuthSuccess());
      // ShartedPreferences.getInstance().then((prefs) {
      //   prefs.setString('token', res.data['token']);
      // });
    } else {
      message = 'username or password invalid';
      emit(AuthFailed(message));
    }
  }
}
