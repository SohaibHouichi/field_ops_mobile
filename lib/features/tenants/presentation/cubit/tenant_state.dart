import 'package:field_ops/features/tenants/domain/entities/tenant_entity.dart';

abstract class TenantState {}

class TenantInitial extends TenantState {}

class TenantLoading extends TenantState {}

class TenantLoaded extends TenantState {
  final List<TenantEntity> tenants;

  TenantLoaded({required this.tenants});
}

class TenantError extends TenantState {
  final String message;

  TenantError({required this.message});
}