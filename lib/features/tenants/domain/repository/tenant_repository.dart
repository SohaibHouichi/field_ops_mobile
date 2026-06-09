import 'package:field_ops/features/tenants/domain/entities/tenant_entity.dart';

abstract class TenantRepository {
  Future<List<TenantEntity>> getTenant();
}