import 'package:dio/dio.dart';
import 'package:field_ops/features/tenants/data/models/tenant_response_model.dart';

abstract class TenantRemoteDataSource {
  Future<List<TenantResponseModel>> getTenant();
}

class TenantRemoteDataSourceImpl implements TenantRemoteDataSource {
  final Dio dioClient;
  TenantRemoteDataSourceImpl(this.dioClient);
  @override
  Future<List<TenantResponseModel>> getTenant() async {
    final res = await dioClient.get('/v1/tenants');
    return (res.data['items'] as List)
        .map((e) => TenantResponseModel.fromJson(e))
        .toList();
  }
}
