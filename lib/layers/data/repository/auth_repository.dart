//import 'package:field_ops/layers/data/model/DTO/login_request_dto.dart';
import 'package:field_ops/layers/data/model/DTO/login_response_dto.dart';
import 'package:field_ops/layers/data/web_api/auth_web_service.dart';

class AuthRepository {
  final AuthWebService webService ; 
  AuthRepository(this.webService);
  
Future<LoginResponseDto> login(String username, String password)  {
  return webService.login(username , password);
}



















final List<String> username = [
  'sohaib' ,'louai' , 'mohamed'
];
final List<String> password =  [
  'sohaib' ,'louai' , 'mohamed'
];
}