import 'package:field_ops/features/service_request/domain/repository/service_request_repository.dart';

class DeleteSrUsecase {
   final ServiceRequestRepository _requestRepository;
   DeleteSrUsecase(this._requestRepository);
   Future<void> call(int id) async {
    await _requestRepository.deleteRequest(id);
   }
}