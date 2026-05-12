import 'package:field_ops/features/auth/domain/entities/tenant_entity.dart';

class UserEntity {
  final int userId;
  final String username;
  final String email;
  final String role;
  final String accessToken;
  final TenantEntity tenantInfo;

  const UserEntity({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.tenantInfo,
  });}
