import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/usecases/add_assets_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/edit_assets_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/get_assets_by_customer_id_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/params/add_assets_params.dart';
import 'package:field_ops/features/assets/domain/usecases/params/update_assets_params.dart';
import 'package:field_ops/features/assets/domain/usecases/search_assets_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assets_state.dart';

class AssetsCubit extends Cubit<AssetsState> {
  final SearchAssetsUsecase _searchAssetsUsecase;
  final AddAssetsUsecase _addAssetsUsecase;
  final GetAssetsByCustomerIdUseCase _assetsByCustomerIdUseCase; // inject CustomerCubit
  final EditAssetsUsecase _editAssetsUsecase;

  AssetsCubit(
    this._searchAssetsUsecase,
    this._addAssetsUsecase,
    this._assetsByCustomerIdUseCase,
    this._editAssetsUsecase,
  ) : super(const AssetsInitial());

  // ── Search controller ─────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();

  // ── Form controllers ──────────────────────────────────────────────
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── Assets cache ──────────────────────────────────────────────────
  List<AssetEntity>? _allAssets;
  List<AssetEntity>? get allAssets => _allAssets;

  // ── Add asset ─────────────────────────────────────────────────────
  Future<void> addAssets({
    required String name,
    required String brand,
    required String model,
    required String note,
    required String serialNumber,
  }) async {
    emit(const AssetsLoading());
    try {
      final res = await _addAssetsUsecase(
        AddAssetsParams(
          name: name,
          customerId: 25,
          brand: brand,
          model: model,
          note: note,
          serialNumber: serialNumber,
        ),
      );
      emit(AssetsSuccess(res));
      await refreshAssets();
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  // ── edit asset ─────────────────────────────────────────────────────
  Future<void> editAssets({
    required int id,
    required String name,
    required String brand,
    required String model,
    required String note,
    required String serialNumber,
  }) async {
    emit(const AssetsLoading());
    try {
      await _editAssetsUsecase(
        id,
        UpdateAssetsParams(
          name: name,
          brand: brand,
          model: model,
          note: note,
          serialNumber: serialNumber,
          customerId: 25
        ),
      );

      emit(EditAssetsSuccessfuly());
      await refreshAssets();
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  // ── Refresh assets ──────────────────────────────
  Future<void> refreshAssets() async {
    try {
      final assets = await _assetsByCustomerIdUseCase(25);
      setAssets(assets);
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  // ── Set assets ────────────────────────────────────────────────────
  void setAssets(List<AssetEntity> assets) {
    _allAssets = assets;
    emit(AssetsSearchSuccess(assets));
  }

  // ── Search ────────────────────────────────────────────────────────
  Future<void> search(String query) async {
    if (query.isEmpty) {
      if (_allAssets != null) emit(AssetsSearchSuccess(_allAssets!));
      return;
    }
    if (_allAssets == null) return;
    emit(const AssetsLoading());
    try {
      final allResults = await _searchAssetsUsecase(query);
      final result = allResults.where(
        (s) => _allAssets!.any((e) => e.id == s.id),
      );
      emit(AssetsSearchSuccess(result.toList()));
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  // ── Clear search ──────────────────────────────────────────────────
  void clearSearch() {
    searchController.clear();
    if (_allAssets != null) emit(AssetsSearchSuccess(_allAssets!));
  }

  // ── Clear form ────────────────────────────────────────────────────
  void clearForm() {
    nameController.clear();
    brandController.clear();
    modelController.clear();
    serialController.clear();
    noteController.clear();
    formKey.currentState?.reset();
  }

  // ── Dispose ───────────────────────────────────────────────────────
  @override
  Future<void> close() {
    searchController.dispose();
    nameController.dispose();
    brandController.dispose();
    modelController.dispose();
    serialController.dispose();
    noteController.dispose();
    return super.close();
  }
}
