import 'package:dio/dio.dart';
import 'package:field_ops/features/auth/data/models/DTO/login_request_dto.dart';
import 'package:field_ops/features/auth/data/models/DTO/login_response_dto.dart';

class AuthWebService {
  final Dio dioClient;
  AuthWebService(this.dioClient);
  // login request
  Future<LoginResponseDto> login(LoginRequestDto loginData) async {
    final res = await dioClient.post(
      '/v1/auth/login',
      data: loginData,
    );
    return LoginResponseDto.fromJson(res.data);
  }
}
