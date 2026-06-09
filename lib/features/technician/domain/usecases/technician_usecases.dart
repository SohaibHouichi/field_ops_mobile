import 'package:field_ops/features/technician/domain/entities/technician_entity.dart';
import 'package:field_ops/features/technician/domain/repository/technician_repository.dart';

class GetTechnicianByIdUsecase {
  final TechnicianRepository _repository;

  GetTechnicianByIdUsecase(this._repository);

  Future<TechnicianEntity> call(int id) async {
    return await _repository.getTechnicianById(id);
  }
}