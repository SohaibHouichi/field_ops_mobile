import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/usecases/params/add_assets_params.dart';
import 'package:field_ops/features/assets/domain/usecases/params/update_assets_params.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';

abstract class AssetsRepository {
  Future<AssetEntity> getAssets();
  Future<AssetEntity> createAsset(AddAssetsParams assetParams);
  Future<void> updateAsset(int assetId, UpdateAssetsParams assetParams);
  Future<void> deleteAsset(int assetId);
  Future<List<AssetEmbeddedEntity>> searchAssets(String name);  
}