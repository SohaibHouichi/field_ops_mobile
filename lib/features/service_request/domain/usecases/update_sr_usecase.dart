import 'package:field_ops/features/service_request/domain/repository/service_request_repository.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/update_sr_params.dart';


class UpdateSrUsecase {
  final ServiceRequestRepository _requestRepository;
  UpdateSrUsecase(this._requestRepository);
  Future<void> call (int id , UpdateSrParams data) async {
    await _requestRepository.editRequest(id, data);
  }
}
