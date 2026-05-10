import 'package:dio/dio.dart';

///import 'package:field_ops/layers/data/model/DTO/login_request_dto.dart';
import 'package:field_ops/layers/data/model/DTO/login_response_dto.dart';

class AuthWebService {
  final Dio dioClient;
  AuthWebService(this.dioClient);
  // login request
  Future<LoginResponseDto> login(String username, String password) async {
    final res = await dioClient.post(
      '/login',
      data: {'username': username, 'password': password},
    );
    return LoginResponseDto.fromJson(res.data);
  }
}
