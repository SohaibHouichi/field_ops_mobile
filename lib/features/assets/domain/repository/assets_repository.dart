import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/usecases/params/add_assets_params.dart';
import 'package:field_ops/features/assets/domain/usecases/params/update_assets_params.dart';

abstract class AssetsRepository {
  Future<List<AssetEntity>> getAssetsByCustomerId(int id);
  Future<AssetEntity> createAsset(AddAssetsParams assetParams);
  Future<void> updateAsset(int assetId, UpdateAssetsParams assetParams);
  Future<void> deleteAsset(int assetId);
  Future<List<AssetEntity>> searchAssets(String name);  
}