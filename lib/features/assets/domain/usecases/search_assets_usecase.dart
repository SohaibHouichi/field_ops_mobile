import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';

class SearchAssetsUsecase {
  final AssetsRepository _assetsRepository;

  SearchAssetsUsecase(this._assetsRepository);

  Future<List<AssetEmbeddedEntity>> call(String name) async {
    return await _assetsRepository.searchAssets(name);
  }
}
