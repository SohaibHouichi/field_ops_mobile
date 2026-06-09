import 'package:dio/dio.dart';
import 'package:field_ops/features/technician/data/models/teachnician_response_model.dart';


abstract class TechnicianRemoteDataSource {
  Future<TechnicianModel> getTechnicianById(int id);
}

class TechnicianRemoteDataSourceImpl implements TechnicianRemoteDataSource {
  final Dio _dio;

  TechnicianRemoteDataSourceImpl(this._dio);

  @override
  Future<TechnicianModel> getTechnicianById(int id) async {
    final response = await _dio.get('/v1/technicians/$id');
    return TechnicianModel.fromJson(response.data);
  }
}