import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';

class DeleteAssetsUsecase {
  final AssetsRepository _assetsRepository;
  DeleteAssetsUsecase(this._assetsRepository);
  Future<void> call(int id) async {
    await _assetsRepository.deleteAsset(id);
  }
}
