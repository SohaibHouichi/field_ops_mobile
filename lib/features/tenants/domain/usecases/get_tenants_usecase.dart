import 'package:field_ops/features/tenants/domain/entities/tenant_entity.dart';
import 'package:field_ops/features/tenants/domain/repository/tenant_repository.dart';

class GetTenantsUsecase {
  final TenantRepository _tenantRepository ;
  GetTenantsUsecase(this._tenantRepository);

  Future<List<TenantEntity>> call() async {
    return await _tenantRepository.getTenant();
  }
}