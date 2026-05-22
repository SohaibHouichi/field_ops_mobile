import 'package:bloc/bloc.dart';
import 'package:field_ops/core/enums/status_enums.dart';
import 'package:field_ops/core/helpers/shared_pref_helper.dart';
import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/domain/usecases/create_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/delete_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/get_sr_by_customer_id_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/search_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/update_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/create_sr_params.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/update_sr_params.dart';
import 'package:flutter/material.dart';

part 'service_request_state.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  final CreateSrUsecase _createSr;
  final DeleteSrUsecase _deleteSr;
  final GetSrByCustomerIdUsecase _getSrByCustomerId;
  final SearchSrUsecase _searchSr;
  final UpdateSrUsecase _updateSr;

  ServiceRequestCubit({
    required CreateSrUsecase createSr,
    required DeleteSrUsecase deleteSr,
    required GetSrByCustomerIdUsecase getSrByCustomerId,
    required SearchSrUsecase searchSr,
    required UpdateSrUsecase updateSr,
  }) : _createSr = createSr,
       _deleteSr = deleteSr,
       _getSrByCustomerId = getSrByCustomerId,
       _searchSr = searchSr,
       _updateSr = updateSr,
       super(ServiceRequestInitial());

  // ── Search controller ─────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();

  // ── Filters ───────────────────────────────────────────────────────
  ServiceRequestStatus? selectedStatus;

  // ── Cache ─────────────────────────────────────────────────────────
  List<ServiceRequestEntity>? _allRequests;
  List<ServiceRequestEntity>? get allRequests => _allRequests;

  // ── Get by customer id ────────────────────────────────────────────
  Future<void> getByCustomerId(int customerId) async {
    emit(ServiceRequestLoading());
    try {
      final result = await _getSrByCustomerId(customerId);
      _allRequests = result;
      _emitFiltered();
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
      _emitFiltered();
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

  // ── Search ────────────────────────────────────────────────────────
  Future<void> search(String query) async {
    if (query.isEmpty) {
      _emitFiltered();
      return;
    }
    if (_allRequests == null) return;
    emit(ServiceRequestLoading());
    try {
      final allResults = await _searchSr(query);
      final result = allResults.where(
        (s) => _allRequests!.any((e) => e.id == s.id),
      );
      _emitFiltered(override: result.toList());
    } catch (e) {
      emit(ServiceRequestFailure(e.toString()));
    }
  }

  // ── Clear search ──────────────────────────────────────────────────
  void clearSearch() {
    searchController.clear();
    _emitFiltered();
  }

  // ── Filter by status ──────────────────────────────────────────────
  void filterByStatus(ServiceRequestStatus? status) {
    selectedStatus = status;
    _emitFiltered();
  }

  // ── Internal: apply filters and emit ─────────────────────────────
  void _emitFiltered({List<ServiceRequestEntity>? override}) {
    if (_allRequests == null) return;

    var list = override ?? _allRequests!;

    if (selectedStatus != null) {
      list = list.where((e) => e.status == selectedStatus!.index).toList();
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
    return super.close();
  }
}
