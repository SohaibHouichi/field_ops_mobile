import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';
import 'package:field_ops/features/assets/domain/usecases/params/update_assets_params.dart';

class EditAssetsUsecase {
  final AssetsRepository _assetsRepository; 
  EditAssetsUsecase(this._assetsRepository);
  Future<void> call(int id , UpdateAssetsParams assetsData) async {
    await _assetsRepository.updateAsset(id, assetsData);
  }
}