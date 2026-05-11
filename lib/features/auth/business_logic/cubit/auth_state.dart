// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {
}

class AuthLoading extends AuthState {}

class AuthFailed extends AuthState {
  final String message;
  AuthFailed(this.message);
}
class AuthSuccess extends AuthState {}
