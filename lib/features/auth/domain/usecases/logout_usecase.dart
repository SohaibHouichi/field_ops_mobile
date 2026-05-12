import 'package:field_ops/features/auth/domain/repository/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _authRepository;
  LogoutUsecase(this._authRepository);
  Future<void> call() {
    return _authRepository.logout();
  }
}