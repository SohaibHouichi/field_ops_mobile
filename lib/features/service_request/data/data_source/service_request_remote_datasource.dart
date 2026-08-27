import 'package:dio/dio.dart';
import 'package:field_ops/features/service_request/data/models/create_service_request_req_model.dart';
import 'package:field_ops/features/service_request/data/models/service_request_response_model.dart';

abstract class ServiceRequestRemoteDatasource {
  Future<List<ServiceRequestResponseModel>> searchServiceRequest(String query);
  Future<List<ServiceRequestResponseModel>> getServiceRequestByCustomerId(
    int id,
  );
  Future<ServiceRequestResponseModel> createServiceRequest(
    CreateServiceRequestReqModel requestData,
  );
  Future<void> editRequest(int id, CreateServiceRequestReqModel requestData);
  Future<void> deleteRequest(int id);
}

class ServiceRequestRemoteDatasourceImpl implements ServiceRequestRemoteDatasource {
  final Dio dioClient;
  ServiceRequestRemoteDatasourceImpl(this.dioClient);
  
  @override
  Future<ServiceRequestResponseModel> createServiceRequest(
    CreateServiceRequestReqModel requestData,
  ) async {
    final res = await dioClient.post(
      '/v1/service-requests/customer',
      data: requestData.toFormData(),
    );
    return ServiceRequestResponseModel.fromJson(res.data);
  }

  @override
  Future<void> deleteRequest(int id) async {
    try {
      await dioClient.delete('/v1/service-requests/$id');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> editRequest(
    int id,
    CreateServiceRequestReqModel requestData,
  ) async {
    try {
      await dioClient.put(
        '/v1/service-requests/$id',
        data: requestData.toFormData(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ServiceRequestResponseModel>> getServiceRequestByCustomerId(
    int id,
  ) async {
    final res = await dioClient.get(
      '/v1/service-requests?filter[customerId].Value=$id',
    );
    return (res.data["items"] as List)
        .map(
          (e) =>
              ServiceRequestResponseModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<ServiceRequestResponseModel>> searchServiceRequest(
    String query,
  ) async {
    final res = await dioClient.get(
      '/v1/service-requests?search[title]=$query',
    );
    return (res.data["items"] as List)
        .map(
          (e) =>
              ServiceRequestResponseModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
