import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/domain/repository/service_request_repository.dart';

class GetSrByCustomerIdUsecase {
    final ServiceRequestRepository _requestRepository ;
    GetSrByCustomerIdUsecase(this._requestRepository);
    Future<List<ServiceRequestEntity>> call (int id) async {
      return await _requestRepository.getServiceRequestByCustomerId(id);
    }
}