import 'package:dio/dio.dart';
import 'package:field_ops/features/tenants/domain/entities/tenant_entity.dart';
import 'package:field_ops/features/tenants/data/data_source/tenant_remote_datasource.dart';
import 'package:field_ops/features/tenants/domain/repository/tenant_repository.dart';

class TenantRepositoryImpl implements TenantRepository {
  final TenantRemoteDataSource remoteDataSource;

  const TenantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TenantEntity>> getTenant() async {
    try {
      final models = await remoteDataSource.getTenant();
      return models
          .map(
            (e) => TenantEntity(
              id: e.id,
              name: e.name,
              identifier: e.identifier,
              isActive: e.isActive,
              legalName: e.legalName,
              taxNumber: e.taxNumber,
              registrationNumber: e.registrationNumber,
              email: e.email,
              phoneNumber: e.phoneNumber,
              website: e.website,
              plan: e.plan,
              subscriptionStartDate: e.subscriptionStartDate,
              subscriptionEndDate: e.subscriptionEndDate,
              isTrial: e.isTrial,
              createdAt: e.createdAt

            ),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Server error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
