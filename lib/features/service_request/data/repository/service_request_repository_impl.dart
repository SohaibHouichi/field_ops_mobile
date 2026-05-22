import 'package:field_ops/features/service_request/data/data_source/service_request_remote_datasource.dart';
import 'package:field_ops/features/service_request/data/models/create_service_request_req_model.dart';
import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/domain/repository/service_request_repository.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/create_sr_params.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/update_sr_params.dart';

class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final ServiceRequestRemoteDatasource _remoteDatasource;
  ServiceRequestRepositoryImpl(this._remoteDatasource);

  CreateServiceRequestReqModel _toCreateRequest(dynamic params) =>
      CreateServiceRequestReqModel(
        addressId: params.addressId,
        assetId: params.assetId,
        priority: params.priority,
        title: params.title,
        type: params.type,
        description: params.description,
        attachments: params.attachments,
      );

  @override
  Future<ServiceRequestEntity> createServiceRequest(
    CreateSrParams params,
  ) async {
    final model = _toCreateRequest(params);
    final response = await _remoteDatasource.createServiceRequest(model);
    return response.toEntity();
  }

  @override
  Future<void> deleteRequest(int id) async {
    await _remoteDatasource.deleteRequest(id);
  }

  @override
  Future<void> editRequest(int id, UpdateSrParams params) async {
    final model = _toCreateRequest(params);
    try {
      await _remoteDatasource.editRequest(id, model);
    } catch (e) {
      throw Exception('Failed to update sr: ${e.toString()}');
    }
  }

  @override
  Future<List<ServiceRequestEntity>> getServiceRequestByCustomerId(
    int id,
  ) async {
    final res = await _remoteDatasource.getServiceRequestByCustomerId(id);
    return res
        .map(
          (e) => ServiceRequestEntity(
            id: e.id,
            reference: e.reference,
            type: e.type,
            title: e.title,
            status: e.status,
            customerPriority: e.customerPriority,
            employeePriority: e.employeePriority,
            customerId: e.customerId,
            attachments: e.attachments,
          ),
        )
        .toList();
  }

  @override
  Future<List<ServiceRequestEntity>> searchServiceRequest(String query) async {
    final res = await _remoteDatasource.searchServiceRequest(query);
    return res
        .map(
          (e) => ServiceRequestEntity(
            id: e.id,
            reference: e.reference,
            type: e.type,
            title: e.title,
            status: e.status,
            customerPriority: e.customerPriority,
            employeePriority: e.employeePriority,
            customerId: e.customerId,
            attachments: e.attachments,
          ),
        )
        .toList();
  }
}
