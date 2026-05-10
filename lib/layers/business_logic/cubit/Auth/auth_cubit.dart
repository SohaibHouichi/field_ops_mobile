import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_ops/layers/data/model/DTO/login_request_dto.dart';
import 'package:field_ops/layers/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late AuthRepository authRepository;
  bool isNotVisible = true  ;
  AuthCubit(this.authRepository) : super(AuthInitial());


  String message = '';
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void toggle() {
    isNotVisible = !isNotVisible;
    emit(AuthInitial());
  }

  /// i need later in encapsulation
  LoginRequestDto get req => LoginRequestDto(
    username: usernameController.text.trim(),
    password: passwordController.text,
  );

  Future<void> login(LoginRequestDto req) async {
    emit(AuthLoading());
    try {
      await authRepository.login(usernameController.text , passwordController.text); // changable
      emit(AuthSuccess());
    } catch (e) {
      message = 'username or password invalid';
      emit(AuthFailed(message));
    }
  }

}


