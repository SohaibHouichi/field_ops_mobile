import 'package:field_ops/features/auth/domain/entities/tenant_entity.dart';
enum UserRole { technician, customer }

extension UserRoleX on UserRole {
  static UserRole? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'technician': return UserRole.technician;
      case 'customer':   return UserRole.customer;
      default:           return null;
    }
  }
  static String toStringValue(UserRole role) {
    switch (role) {
      case UserRole.technician: return 'technician';
      case UserRole.customer:   return 'customer';
    }
  }
}

class UserEntity {
  final int userId;
  final String username;
  final String fullName;
  final String email;
  final UserRole role;
  final String accessToken;
  final TenantEntity tenantInfo;

  const UserEntity({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.tenantInfo,
  });}
