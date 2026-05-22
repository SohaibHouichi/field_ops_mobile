import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/domain/repository/service_request_repository.dart';

class SearchSrUsecase {
  final ServiceRequestRepository _requestRepository ;
  SearchSrUsecase(this._requestRepository);
  Future<List<ServiceRequestEntity>> call (String query) async {
    return await _requestRepository.searchServiceRequest(query);
  }
}