import 'package:field_ops/core/helpers/shared_pref_helper.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/domain/usecases/add_assets_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/delete_assets_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/edit_assets_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/get_assets_by_customer_id_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/params/add_assets_params.dart';
import 'package:field_ops/features/assets/domain/usecases/params/update_assets_params.dart';
import 'package:field_ops/features/assets/domain/usecases/search_assets_usecase.dart';
import 'package:field_ops/features/assets/presentation/widgets/sheets/add_asset_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assets_state.dart';

class AssetsCubit extends Cubit<AssetsState> {
  final SearchAssetsUsecase _searchAssetsUsecase;
  final AddAssetsUsecase _addAssetsUsecase;
  final GetAssetsByCustomerIdUseCase _assetsByCustomerIdUseCase;
  final EditAssetsUsecase _editAssetsUsecase;
  final DeleteAssetsUsecase _deleteAssetsUsecase;

  AssetsCubit(
    this._searchAssetsUsecase,
    this._addAssetsUsecase,
    this._assetsByCustomerIdUseCase,
    this._editAssetsUsecase,
    this._deleteAssetsUsecase,
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
 List<AssetEntity> fakeAssetsForSkeletonizer = List.generate(
  6,
  (index) => AssetEntity(
    // every required field filled with a harmless placeholder:
    id: 0,
    name: 'xxxxxxxxxxxx',
    // number fields  -> 0
    // string fields  -> 'xxxxx'  (give some length so the skeleton bar has width)
    // bool fields    -> false
    // date fields    -> DateTime.now()
    // nested objects -> a fake instance of that object too
  ),
);

  // ── Open asset sheet (create / edit) ──────────────────────────────
  /// Opens the asset bottom sheet.
  /// - If [asset] is null  -> CREATE mode (empty form)
  /// - If [asset] is given -> EDIT mode (pre-filled form)
  void openAssetSheet(BuildContext context, {AssetEntity? asset}) {
    final isEdit = asset != null;

    if (!isEdit) {
      clearForm();
    } else {
      nameController.text = asset.name;
      brandController.text = asset.brand ?? '';
      modelController.text = asset.model ?? '';
      serialController.text = asset.serialNumber ?? '';
      noteController.text = asset.note ?? '';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => BlocProvider.value(
        value: this,
        child: AddAssetsSheet(
          asset: asset,
          nameController: nameController,
          brandController: brandController,
          modelController: modelController,
          serialController: serialController,
          noteController: noteController,
          formKey: formKey,
        ),
      ),
    ).whenComplete(() {
      if (isEdit) clearForm();
    });
  }

  // ── Add asset ─────────────────────────────────────────────────────
  Future<void> addAssets({
    required String name,
    required String brand,
    required String model,
    required String note,
    required String serialNumber,
  }) async {
    emit(const AssetsLoading());
    final custId = await getCustomerId();
    try {
      final res = await _addAssetsUsecase(
        AddAssetsParams(
          name: name,
          customerId: custId,
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
    final custId = await getCustomerId();
    try {
      await _editAssetsUsecase(
        id,
        UpdateAssetsParams(
          name: name,
          brand: brand,
          model: model,
          note: note,
          serialNumber: serialNumber,
          customerId: custId,
        ),
      );

      emit(EditAssetsSuccessfuly());
      await refreshAssets();
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  // ── delete asset ─────────────────────────────────────────────────────
  Future<void> deleteAssets(int id) async {
    emit(AssetsLoading());
    try {
      await _deleteAssetsUsecase(id);
      emit(DeleteAssetsSuccessfuly());
      await refreshAssets();
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  // ── Refresh assets ──────────────────────────────
  Future<void> refreshAssets() async {
    try {
      final custId = await getCustomerId();
      final assets = await _assetsByCustomerIdUseCase(custId);
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
  // ── get customer id ──────────────────────────────────────────────────
  Future<int> getCustomerId () async{
    final id  = await SharedPrefHelper.getInt(LocalStorageKeys.userId);
    return id.toInt();
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