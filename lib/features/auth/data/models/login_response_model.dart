import 'package:field_ops/features/auth/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import './DTO/tenant_dto.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final int userId;
  final String username;
  final String email;
  final String role;
  final String accessToken;
  final TenantDTO tenantInfo;

  const LoginResponseModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.tenantInfo,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  UserEntity? toEntity() {
     final parsedRole = UserRoleX.fromString(role);
    if (parsedRole == null) return null; 
    return UserEntity(
      userId: userId,
      username: username,
      email: email,
      role: parsedRole,
      accessToken: accessToken,
      tenantInfo: tenantInfo.toEntity(),
    );
  }
}
