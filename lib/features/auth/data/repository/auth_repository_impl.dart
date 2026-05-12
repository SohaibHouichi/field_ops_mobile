import 'package:field_ops/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:field_ops/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:field_ops/features/auth/data/models/login_request_model.dart';
import 'package:field_ops/features/auth/data/models/login_response_model.dart';
import 'package:field_ops/features/auth/domain/entities/user_entity.dart';
import 'package:field_ops/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
   final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

@override
Future<UserEntity> login({
  required String email,
  required String password,
}) async {
  final loginRequest = LoginRequestModel(email: email, password: password);
  final LoginResponseModel response = await remoteDataSource.login(loginRequest);
  await localDataSource.cacheUser(response);
  return response.toEntity();
}
    @override
     Future<UserEntity?> getCurrentUser() async {
      try {
        final cachedUser = await localDataSource.getCachedUser();
        return cachedUser.toEntity();
      } catch (e) {
        final res = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(res);
        return res.toEntity();
      }
    }
    @override
    Future <void> logout() async {
      await localDataSource.clearUser();
    }
} 
    