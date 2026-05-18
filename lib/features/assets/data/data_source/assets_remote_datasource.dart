import 'package:dio/dio.dart';
import 'package:field_ops/features/assets/data/models/assets_request_model.dart';
import 'package:field_ops/features/assets/data/models/assets_response_model.dart';

abstract class AssetsRemoteDataSource {
  Future<List<AssetResponse>> getAssetsByCustomerId(int id);
  Future<AssetResponse> createAsset(AssetRequest assetRequest);
  Future<void> updateAsset(int assetId, AssetRequest assetRequest);
  Future<void> deleteAsset(int assetId);
  Future<List<AssetResponse>> searchAssets(String name);
}

class AssetsRemoteDataSourceImpl implements AssetsRemoteDataSource {
  final Dio dioClient;
  AssetsRemoteDataSourceImpl(this.dioClient);
  @override
  Future<List<AssetResponse>> getAssetsByCustomerId(int id) async {
    final res = await dioClient.get('/v1/assets?filter[customerId]=${id}');
    return (res.data['items'] as List)
        .map((e) => AssetResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AssetResponse> createAsset(AssetRequest assetRequest) async {
    final res = await dioClient.post('/v1/assets', data: assetRequest.toJson());
    return AssetResponse.fromJson(res.data);
  }

  @override
  Future<void> updateAsset(int assetId, AssetRequest assetRequest) async {
    try {
      await dioClient.put('/v1/assets/$assetId', data: assetRequest.toJson());
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to update asset. Server responded with status code ${e.response?.statusCode}: ${e.response?.data}',
        );
      } else {
        throw Exception('Failed to update asset. Network error: ${e.message}');
      }
    }
  }

  @override
  Future<void> deleteAsset(int assetId) async {
    await dioClient.delete('/v1/assets/$assetId');
  }

  @override
  Future<List<AssetResponse>> searchAssets(String name) async {
    final res = await dioClient.get(
      '/v1/assets',
      queryParameters: {'search[name]': name},
    );
    return (res.data['items'] as List)
        .map((e) => AssetResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
