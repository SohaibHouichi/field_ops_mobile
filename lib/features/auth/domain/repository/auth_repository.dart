import 'package:field_ops/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
   required String email,
    required String password,
  });

  // Future<UserEntity> register({
  //   required String name,
  //   required String email,
  //   required String password,
  // });


  Future<UserEntity?> getCurrentUser();
  Future <void> logout();
}