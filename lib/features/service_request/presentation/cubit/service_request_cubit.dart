import 'package:field_ops/core/enums/customer_priority_enum.dart';
import 'package:field_ops/core/enums/sr_type_enum.dart';
import 'package:field_ops/core/enums/status_enums.dart';
import 'package:field_ops/core/helpers/shared_pref_helper.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/domain/usecases/create_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/delete_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/get_sr_by_customer_id_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/update_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/create_sr_params.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/update_sr_params.dart';
import 'package:field_ops/features/service_request/presentation/widgets/sheets/service_request_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'service_request_state.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  final CreateSrUsecase _createSr;
  final DeleteSrUsecase _deleteSr;
  final GetSrByCustomerIdUsecase _getSrByCustomerId;
  final UpdateSrUsecase _updateSr;

  ServiceRequestCubit({
    required CreateSrUsecase createSr,
    required DeleteSrUsecase deleteSr,
    required GetSrByCustomerIdUsecase getSrByCustomerId,
    required UpdateSrUsecase updateSr,
  }) : _createSr = createSr,
       _deleteSr = deleteSr,
       _getSrByCustomerId = getSrByCustomerId,
       _updateSr = updateSr,
       super(ServiceRequestInitial());

  // ── Search controller ─────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();

  // ── Form controllers ──────────────────────────────────────────────
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── Form ValueNotifiers (dropdown state for StatelessWidget sheet) ─
  final ValueNotifier<CustomerPriority> priorityNotifier = ValueNotifier(
    CustomerPriority.normal,
  );
  final ValueNotifier<ServiceRequestType> typeNotifier = ValueNotifier(
    ServiceRequestType.maintenance,
  );
  final ValueNotifier<AssetEntity?> assetNotifier = ValueNotifier(null);

  // ── Form scalar state ─────────────────────────────────────────────
  int? selectedAddressId;

  // ── Filters ───────────────────────────────────────────────────────
  ServiceRequestStatus? selectedStatus;

  // ── Cache ─────────────────────────────────────────────────────────
  List<ServiceRequestEntity>? _allRequests;
  List<ServiceRequestEntity>? get allRequests => _allRequests;

  // ── Active query ──────────────────────────────────────────────────
  String _currentQuery = '';

  // ── Last loaded customer ──────────────────────────────────────────
  int? lastLoadedCustomerId;

  // ── Open SR sheet (create / edit) ─────────────────────────────────
  void openServiceRequestSheet(
    BuildContext context,
    List<AssetEntity>? assets, {
    ServiceRequestEntity? sr,
  }) {
    final isEdit = sr != null;

    if (!isEdit) {
      clearForm();
    } else {
      titleController.text = sr.title;
      descriptionController.text = sr.description ?? '';
      selectedAddressId = sr.addressId != null
          ? int.tryParse(sr.addressId!)
          : null;
      priorityNotifier.value = CustomerPriority.fromInt(sr.customerPriority);
      typeNotifier.value = ServiceRequestType.fromInt(sr.type);
      // assetNotifier resolved inside sheet once assets are available
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => BlocProvider.value(
        value: this,
        child: AddServiceRequestSheet(
          assets: assets ?? [],
          sr: sr,
          titleController: titleController,
          descriptionController: descriptionController,
          formKey: formKey,
        ),
      ),
    ).whenComplete(() {
      if (isEdit) clearForm();
    });
  }

  // ── Get by customer id ────────────────────────────────────────────
  Future<void> getByCustomerId(int customerId) async {
    lastLoadedCustomerId = customerId;
    emit(ServiceRequestLoading());
    try {
      final result = await _getSrByCustomerId(customerId);
      _allRequests = result;
      _applySearchAndFilters();
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
    }
  }

  // ── Refresh ───────────────────────────────────────────────────────
  Future<void> refresh() async {
    try {
      final custId = await _getCustomerId();
      final result = await _getSrByCustomerId(custId);
      _allRequests = result;
      _applySearchAndFilters();
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
    }
  }

  // ── Create ────────────────────────────────────────────────────────
  Future<void> createServiceRequest(CreateSrParams params) async {
    emit(ServiceRequestLoading());
    try {
      await _createSr(params);
      emit(ServiceRequestCreated());
      await refresh();
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
    }
  }

  // ── Update ────────────────────────────────────────────────────────
  Future<void> updateServiceRequest(int id, UpdateSrParams params) async {
    emit(ServiceRequestLoading());
    try {
      await _updateSr(id, params);
      emit(ServiceRequestUpdated());
      await refresh();
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
    }
  }

  // ── Delete ────────────────────────────────────────────────────────
  Future<void> deleteServiceRequest(int id) async {
    emit(ServiceRequestLoading());
    try {
      await _deleteSr(id);
      emit(ServiceRequestDeleted());
      await refresh();
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
    }
  }

  // ── Search (local, no loading flicker) ───────────────────────────
  void search(String query) {
    _currentQuery = query;
    _applySearchAndFilters();
  }

  // ── Clear search ──────────────────────────────────────────────────
  void clearSearch() {
    _currentQuery = '';
    searchController.clear();
    _applySearchAndFilters();
  }

  // ── Filter by status ──────────────────────────────────────────────
  void filterByStatus(ServiceRequestStatus? status) {
    selectedStatus = status;
    _applySearchAndFilters();
  }

  // ── Clear form ────────────────────────────────────────────────────
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedAddressId = null;
    priorityNotifier.value = CustomerPriority.normal;
    typeNotifier.value = ServiceRequestType.maintenance;
    assetNotifier.value = null;
    formKey.currentState?.reset();
  }

  // ── Internal: apply search + filters then emit ────────────────────
  void _applySearchAndFilters() {
    if (_allRequests == null) return;

    var list = _allRequests!;

    if (_currentQuery.isNotEmpty) {
      final q = _currentQuery.toLowerCase();
      list = list
          .where(
            (e) =>
                e.title.toLowerCase().contains(q) ||
                e.reference.toLowerCase().contains(q) ||
                (e.description?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }

    _emitFiltered(override: list);
  }

  // ── Internal: apply status filter then emit ───────────────────────
  void _emitFiltered({List<ServiceRequestEntity>? override}) {
    if (_allRequests == null) return;

    var list = override ?? _allRequests!;

    if (selectedStatus != null) {
      list = list.where((e) => e.status == selectedStatus!.index + 1).toList();
    }

    emit(ServiceRequestListSuccess(list));
  }

  // ── Get customer id ───────────────────────────────────────────────
  Future<int> _getCustomerId() async {
    final id = await SharedPrefHelper.getInt(LocalStorageKeys.userId);
    return id.toInt();
  }

  // ── Dispose ───────────────────────────────────────────────────────
  @override
  Future<void> close() {
    searchController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priorityNotifier.dispose();
    typeNotifier.dispose();
    assetNotifier.dispose();
    return super.close();
  }
}
