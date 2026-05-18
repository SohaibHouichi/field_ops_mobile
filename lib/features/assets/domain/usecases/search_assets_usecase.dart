import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';

class SearchAssetsUsecase {
  final AssetsRepository _assetsRepository;

  SearchAssetsUsecase(this._assetsRepository);

  Future<List<AssetEntity>> call(String name) async {
    return await _assetsRepository.searchAssets(name);
  }
}
