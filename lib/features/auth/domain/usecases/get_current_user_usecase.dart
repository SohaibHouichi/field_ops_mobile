import 'package:field_ops/features/auth/domain/entities/user_entity.dart';
import 'package:field_ops/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository _authRepository;
  
  GetCurrentUserUsecase(this._authRepository);
  
  Future<UserEntity?> call() {
    return _authRepository.getCurrentUser();
  }
}