import 'package:dio/dio.dart';

class AuthWebService {
  final Dio dioClient;
  AuthWebService(this.dioClient);
  // login request
  Future<dynamic> login(Map<String , dynamic> loginData) async {
    final res = await dioClient.post(
      '/v1/auth/login',
      data: loginData,
    );
    return res;
  }
}
