import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';
import 'package:field_ops/features/assets/domain/usecases/params/add_assets_params.dart';

class AddAssetsUsecase {
  final AssetsRepository _assetsRepository;
  AddAssetsUsecase(this._assetsRepository);

  Future<AssetEntity> call(AddAssetsParams assetsData) async {
    return await _assetsRepository.createAsset(assetsData);
  }
}
