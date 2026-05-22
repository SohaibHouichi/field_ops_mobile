import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/create_sr_params.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/update_sr_params.dart';

abstract class ServiceRequestRepository {
  Future<List<ServiceRequestEntity>> searchServiceRequest(String query);
  Future<List<ServiceRequestEntity>> getServiceRequestByCustomerId(
    int id,
  );
  Future<ServiceRequestEntity> createServiceRequest(CreateSrParams requestData);
  Future<void> editRequest(int id, UpdateSrParams requestData);
  Future<void> deleteRequest(int id);
}
