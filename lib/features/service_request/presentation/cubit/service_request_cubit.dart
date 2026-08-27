import 'package:field_ops/core/enums/customer_priority_enum.dart';
import 'package:field_ops/core/enums/sr_type_enum.dart';
import 'package:field_ops/core/enums/status_enums.dart';
import 'package:field_ops/core/helpers/shared_pref_helper.dart';
import 'package:field_ops/core/usecases/local_storage_usecase.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/service_request_embedded_entity.dart';
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
  final GetCustomerIdUsecase _getCustomerIdUsecase;

  ServiceRequestCubit({
    required CreateSrUsecase createSr,
    required DeleteSrUsecase deleteSr,
    required GetSrByCustomerIdUsecase getSrByCustomerId,
    required UpdateSrUsecase updateSr,
    required GetCustomerIdUsecase getCustomerId,
  }) : _createSr = createSr,
       _deleteSr = deleteSr,
       _getSrByCustomerId = getSrByCustomerId,
       _updateSr = updateSr,
       _getCustomerIdUsecase = getCustomerId,
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

  // ── Fake requests for skeletonizer ────────────────────────────────
  List<ServiceRequestEntity> fakeRequestsForSkeletonizer = List.generate(
    6,
    (index) => ServiceRequestEntity(
      id: 0,
      title: 'xxxxxxxxxxxx',
      reference: 'xxxxxx',
      status: 1,
      type: 1,
      customerPriority: 1,
      employeePriority: 0,
      customerId: 0,
      attachments: [],
    ),
  );

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
      selectedAddressId = sr.addressId != 0 ? sr.addressId! : null;
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

  // ── Set requests (called from screen when customer loads) ─────────
  // Mirrors AssetsCubit.setAssets — uses embedded data from CustomerEntity,
  // no API call needed on initial load.
  void setRequests(List<ServiceRequestEmbeddedEntity> requests) {
    _allRequests = requests
        .map(
          (e) => ServiceRequestEntity(
            id: e.id,
            title: e.title,
            reference: e.reference,
            type: e.type,
            status: e.status,
            customerPriority: e.customerPriority,
            employeePriority: e.employeePriority,
            customerId: 1,
            attachments: [],
          ),
        )
        .toList();
    _applySearchAndFilters();
  }

  Future<int> getCustomerId() async {
    final id = await _getCustomerIdUsecase();
    return id.toInt();
  }

  Future<void> refreshRequests() async {
    try {
      final customerId = await getCustomerId();
      final res = await _getSrByCustomerId(customerId);
      _allRequests = res;
      emit(ServiceRequestListSuccess(res));
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
    }
  }

  // ── Create ────────────────────────────────────────────────────────
  Future<void> createServiceRequest(CreateSrParams params) {
    try {
      return _createSr(params).then((_) async {
        emit(ServiceRequestCreated());
        await refreshRequests();
      });
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
      rethrow;
    }
  }

  // ── Update ────────────────────────────────────────────────────────
  Future<void> updateServiceRequest(int id, UpdateSrParams params) => _mutate(
    action: () => _updateSr(id, params),
    onSuccess: () => ServiceRequestUpdated(),
  );

  // ── Delete ────────────────────────────────────────────────────────
  Future<void> deleteServiceRequest(int id) => _mutate(
    action: () => _deleteSr(id),
    onSuccess: () => ServiceRequestDeleted(),
  );

  // ── Internal: shared create/update/delete plumbing ────────────────
  // Loads, runs the mutation, refreshes the list, then emits the
  // terminal state so listeners see up-to-date data alongside it.
  Future<void> _mutate({
    required Future<void> Function() action,
    required ServiceRequestState Function() onSuccess,
  }) async {
    emit(ServiceRequestLoading());
    try {
      await action();
      await refreshRequests();
      emit(onSuccess());
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
    }
  }

  // ── Search (local, no loading flicker) ────────────────────────────
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

  // ── Internal: apply search + status filter then emit ──────────────
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

    if (selectedStatus != null) {
      list = list.where((e) => e.status == selectedStatus!.index + 1).toList();
    }

    emit(ServiceRequestListSuccess(list));
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
