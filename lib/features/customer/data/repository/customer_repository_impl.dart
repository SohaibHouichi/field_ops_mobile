import 'package:field_ops/features/customer/data/data_source/customers_remote_datasource.dart';
import 'package:field_ops/features/customer/data/models/customers_request.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/domain/repository/customer_repository.dart';
import 'package:field_ops/features/customer/domain/usecases/params/add_customer_params.dart';
import 'package:field_ops/features/customer/domain/usecases/params/update_customer_params.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomersRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({required this.remoteDataSource});

  CustomersRequest _toRequest(dynamic params) => CustomersRequest(
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        gender: params.gender,
        birthDate: params.birthDate,
        phoneNumber: params.phoneNumber,
        addressId: params.addressId,
        note: params.note,
      );

  @override
  Future<CustomersEntity> addCustomer({
    required AddCustomerParams customerData,
  }) async {
    final res = await remoteDataSource.addCustomer(
      customerData: _toRequest(customerData),
    );
    return res.toEntity();
  }

  @override
  Future<CustomersEntity> getCustomerById({required int id}) async {
    final res = await remoteDataSource.getCustomerById(id: id);
    return res.toEntity();
  }

  @override
  Future<void> updateCustomer({
    required int id,
    required UpdateCustomerParams customerData,
  }) async {
    await remoteDataSource.updateCustomer(
      id: id,
      customerData: _toRequest(customerData),
    );
  }

  @override
  Future<void> deleteCustomer({required int id}) async {
    await remoteDataSource.deleteCustomer(id: id);
  }
}