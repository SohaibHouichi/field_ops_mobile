import 'package:field_ops/features/technician/data/data_source/technician_remote_datasource.dart';
import 'package:field_ops/features/technician/domain/entities/technician_entity.dart';
import 'package:field_ops/features/technician/domain/repository/technician_repository.dart';

class TechnicianRepositoryImpl implements TechnicianRepository {
  final TechnicianRemoteDataSource _remoteDataSource;

  TechnicianRepositoryImpl(this._remoteDataSource);

  @override
  Future<TechnicianEntity> getTechnicianById(int id) async {
    return await _remoteDataSource.getTechnicianById(id);
  }
}