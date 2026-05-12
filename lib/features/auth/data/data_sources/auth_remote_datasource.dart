import 'package:dio/dio.dart';
import 'package:field_ops/features/auth/data/models/login_request_model.dart';
import 'package:field_ops/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel loginData);
  Future<LoginResponseModel> getCurrentUser();
  // Future<dynamic> register(LoginRequestModel registerData);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dioClient;
  AuthRemoteDataSourceImpl(this.dioClient);

@override
  Future<LoginResponseModel> login(LoginRequestModel loginData) async {
    final res = await dioClient.post(
      '/v1/auth/login',
      data: loginData,
    );
    return LoginResponseModel.fromJson(res.data);
  }
@override
  Future<LoginResponseModel> getCurrentUser() async {
    final res = await dioClient.get('/v1/identity/me');
    return LoginResponseModel.fromJson(res.data);
  }
// @override
//   Future<LoginResponseModel> register(LoginRequestModel registerData) async {
//     final res = await dioClient.post(
//       '/v1/customers',
//       data: registerData,
//     );
//     return res;
//   }
 }
