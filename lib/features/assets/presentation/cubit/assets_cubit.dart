
import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_ops/features/assets/domain/usecases/search_assets_usecase.dart';

part 'assets_state.dart';

class AssetsCubit extends Cubit<AssetsState> {
  final SearchAssetsUsecase _searchAssetsUsecase;

  AssetsCubit(this._searchAssetsUsecase) : super(const AssetsInitial());

  List<AssetEmbeddedEntity>? _allAssets; //

  void setAssets(List<AssetEmbeddedEntity> assets) {
    _allAssets = assets;
    emit(AssetsSuccess(assets));
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      if (_allAssets != null) emit(AssetsSuccess(_allAssets!));
      return;
    }
    emit(const AssetsLoading());
    try {
      final result = await _searchAssetsUsecase(query);
      emit(AssetsSuccess(result));
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  void clearSearch() {
    if (_allAssets != null) emit(AssetsSuccess(_allAssets!));
  }
}