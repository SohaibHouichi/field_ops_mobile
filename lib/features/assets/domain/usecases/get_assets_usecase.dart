import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';

class GetAssetsUseCase {
 final AssetsRepository _assetsRepository;
  GetAssetsUseCase(this._assetsRepository);

  Future<AssetEntity> call() async {
    return await _assetsRepository.getAssets(); 
}}