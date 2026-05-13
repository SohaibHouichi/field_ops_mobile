import 'package:field_ops/features/customer/data/data_source/customers_remote_datasource.dart';
import 'package:field_ops/features/customer/data/models/customers_request.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/domain/repository/customer_repository.dart';
import 'package:field_ops/features/customer/domain/usecases/params/add_customer_params.dart';
import 'package:field_ops/features/customer/domain/usecases/params/update_customer_params.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomersRemoteDataSource remoteDataSource;
  CustomerRepositoryImpl({required this.remoteDataSource});
  @override
  Future<CustomersEntity> addCustomer({required AddCustomerParams customerData}) async {
    final customerReq = CustomersRequest(
      firstName: customerData.firstName,
      lastName: customerData.lastName,
      email: customerData.email,
      gender: customerData.gender,
      birthDate: customerData.birthDate,
      phoneNumber: customerData.phoneNumber,
      addressId: customerData.addressId,
      note: customerData.note,
    );
    final res = await remoteDataSource.addCustomer(customerData: customerReq);
    final customer = res.toEntity();
    if (customer == null) {
      throw Exception('Failed to add customer. Invalid response from server.');
    }
    return customer;
  }
  @override
  Future<void> updateCustomer({required int id, required UpdateCustomerParams customerData}) async {
    final customerReq = CustomersRequest(
      firstName: customerData.firstName,
      lastName: customerData.lastName,
      email: customerData.email,
      gender: customerData.gender,
      birthDate: customerData.birthDate,
      phoneNumber: customerData.phoneNumber,
      addressId: customerData.addressId,
      note: customerData.note,
    );
    await remoteDataSource.updateCustomer(id: id, customerData: customerReq);
  }
  @override
  Future<void> deleteCustomer({required int id}) async {
    await remoteDataSource.deleteCustomer(id: id);
  }
}