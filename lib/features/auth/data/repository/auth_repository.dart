import 'package:field_ops/features/auth/data/models/DTO/login_request_dto.dart';
import 'package:field_ops/features/auth/data/api/auth_web_service.dart';

class AuthRepository {
  final AuthWebService webService;
  AuthRepository(this.webService);

  Future<dynamic> login(LoginRequestDto loginData) async {
    return await webService.login(loginData.toJson());
  }
}
