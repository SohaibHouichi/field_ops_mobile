import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/domain/repository/service_request_repository.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/create_sr_params.dart';

class CreateSrUsecase {
  final ServiceRequestRepository _requestRepository;
  CreateSrUsecase(this._requestRepository);
  Future<ServiceRequestEntity> call (CreateSrParams data) async {
    return _requestRepository.createServiceRequest(data);
  }
}