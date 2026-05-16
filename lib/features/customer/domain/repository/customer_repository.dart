import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/domain/usecases/params/add_customer_params.dart';
import 'package:field_ops/features/customer/domain/usecases/params/update_customer_params.dart';

abstract class CustomerRepository {
  //Future<List<CustomersEntity>> getCustomers();
    Future<CustomersEntity> getCustomerById({required int id});
  Future<CustomersEntity> addCustomer({
    required AddCustomerParams customerData,
  });
  Future<void> updateCustomer({
    required int id,
    required UpdateCustomerParams customerData,
  });
  Future<void> deleteCustomer({required int id});
}