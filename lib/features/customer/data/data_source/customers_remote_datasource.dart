import 'package:dio/dio.dart';
import 'package:field_ops/features/customer/data/models/customers_request.dart';
import 'package:field_ops/features/customer/data/models/customers_response.dart';

abstract class CustomersRemoteDataSource {
  //Future<CustomersResponse> getCustomers();
  Future<CustomersResponse> addCustomer({
    required CustomersRequest customerData,
  });
  Future<void> updateCustomer({
    required int id,
    required CustomersRequest customerData,
  });
  Future<void> deleteCustomer({required int id});
}

class CustomersRemoteDataSourceImpl implements CustomersRemoteDataSource {
  final Dio dioClient;
  CustomersRemoteDataSourceImpl(this.dioClient);
  // @override
  // Future<CustomersResponse> getCustomers() async {
  //      final res = await dioClient.get(
  //     '/v1/customers',
  //   );
  //   return CustomersResponse.fromJson(res.data);
  // }
  @override
  Future<CustomersResponse> addCustomer({
    required CustomersRequest customerData,
  }) async {
    final res = await dioClient.post(
      '/v1/customers/register',
      data: customerData.toJson(),
    );
    return CustomersResponse.fromJson(res.data);
  }

  @override
  Future<void> updateCustomer({
    required int id,
    required CustomersRequest customerData,
  }) async {
    try {
      await dioClient.put('/v1/customers/$id', data: customerData.toJson());
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to update customer. Server responded with status code ${e.response?.statusCode}: ${e.response?.data}',
        );
      } else {
        throw Exception('Failed to update customer. Network error: ${e.message}');
      }
    }
  }

  @override
  Future<void> deleteCustomer({required int id}) async {
    await dioClient.delete('/v1/customers/$id');
  }
}
