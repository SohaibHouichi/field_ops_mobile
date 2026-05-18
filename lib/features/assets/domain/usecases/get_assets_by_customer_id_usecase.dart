import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';

class GetAssetsByCustomerIdUseCase {
 final AssetsRepository _assetsRepository;
  GetAssetsByCustomerIdUseCase(this._assetsRepository);

  Future<List<AssetEntity>> call(int id) async {
    return await _assetsRepository.getAssetsByCustomerId(id); 
}}