import 'package:field_ops/features/assets/data/data_source/assets_remote_datasource.dart';
import 'package:field_ops/features/assets/data/models/assets_request_model.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';
import 'package:field_ops/features/assets/domain/usecases/params/add_assets_params.dart';
import 'package:field_ops/features/assets/domain/usecases/params/update_assets_params.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  final AssetsRemoteDataSource remoteDataSource;
  AssetsRepositoryImpl(this.remoteDataSource);

  AssetRequest _toRequest(dynamic params) => AssetRequest(
    name: params.name,
    customerId: params.customerId,
    brand: params.brand,
    model: params.model,
    serialNumber: params.serialNumber,
  );

  @override
  Future<AssetEntity> createAsset(AddAssetsParams assetParams) async {
    final res = await remoteDataSource.createAsset(_toRequest(assetParams));
    return res.toEntity();
  }

  @override
  Future<void> deleteAsset(int assetId) async {
    try {
      await remoteDataSource.deleteAsset(assetId);
    } catch (e) {
      throw Exception('Failed to delete asset: $e');
    }
  }

  @override
  Future<AssetEntity> getAssets() async {
    final res = await remoteDataSource.getAssets();
    return res.toEntity();
  }

  @override
  Future<void> updateAsset(int assetId, UpdateAssetsParams assetParams) async {
    try {
      await remoteDataSource.updateAsset(assetId, _toRequest(assetParams));
    } catch (e) {
      throw Exception('Failed to update asset: $e');
    }
  }

 @override
Future<List<AssetEmbeddedEntity>> searchAssets(String name) async {
  final res = await remoteDataSource.searchAssets(name);
  return res.map((e) => AssetEmbeddedEntity(
    id: e.id,
    name: e.name,
    serialNumber: e.serialNumber,
    brand: e.brand,
    model: e.model,
    note: e.note,
  )).toList();
}
}
