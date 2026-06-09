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

  // ── Active query ──────────────────────────────────────────────────
  // Tracks the current search string so clearSearch() and setAssets()
  // don't need to re-derive it from the controller.
  String _currentQuery = '';

  // ── Last loaded customer ──────────────────────────────────────────
  // Prevents re-setting assets when the same customer is already loaded,
  // while still reloading if the customer actually changes.
  int? lastLoadedCustomerId;

  List<AssetEntity> fakeAssetsForSkeletonizer = List.generate(
    6,
    (index) => AssetEntity(
      id: 0,
      name: 'xxxxxxxxxxxx',
    ),
  );

  // ── Open asset sheet (create / edit) ──────────────────────────────
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

  // ── Edit asset ────────────────────────────────────────────────────
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

  // ── Delete asset ──────────────────────────────────────────────────
  Future<void> deleteAssets(int id) async {
    emit(const AssetsLoading());
    try {
      await _deleteAssetsUsecase(id);
      emit(DeleteAssetsSuccessfuly());
      await refreshAssets();
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  // ── Refresh assets ────────────────────────────────────────────────
  Future<void> refreshAssets() async {
    try {
      final custId = await getCustomerId();
      final assets = await _assetsByCustomerIdUseCase(custId);
      _allAssets = assets;
      _applySearch();
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  // ── Set assets (called from screen when customer loads) ───────────
  void setAssets(List<AssetEntity> assets) {
    _allAssets = assets;
    _applySearch();
  }

  // ── Search ────────────────────────────────────────────────────────
  // Filters locally — no loading emit, no API call, no flicker.
  void search(String query) {
    _currentQuery = query;
    _applySearch();
  }

  // ── Clear search ──────────────────────────────────────────────────
  // Sets _currentQuery first so the onChanged fired by controller.clear()
  // finds an empty query and doesn't double-trigger.
  void clearSearch() {
    _currentQuery = '';
    searchController.clear();
    _applySearch();
  }

  // ── Internal: apply search and emit ──────────────────────────────
  void _applySearch() {
    if (_allAssets == null) return;

    if (_currentQuery.isEmpty) {
      emit(AssetsSearchSuccess(_allAssets!));
      return;
    }

    final q = _currentQuery.toLowerCase();
    final result = _allAssets!.where((e) =>
      e.name.toLowerCase().contains(q) ||
      (e.brand?.toLowerCase().contains(q) ?? false) ||
      (e.model?.toLowerCase().contains(q) ?? false) ||
      (e.serialNumber?.toLowerCase().contains(q) ?? false),
    ).toList();

    emit(AssetsSearchSuccess(result));
  }

  // ── Get customer id ───────────────────────────────────────────────
  Future<int> getCustomerId() async {
    final id = await SharedPrefHelper.getInt(LocalStorageKeys.userId);
    return id.toInt();
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