import 'package:field_ops/features/technician/domain/entities/technician_entity.dart';

abstract class TechnicianRepository {
  Future<TechnicianEntity> getTechnicianById(int id);
}