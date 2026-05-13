import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/domain/repository/customer_repository.dart';
import 'package:field_ops/features/customer/domain/usecases/params/add_customer_params.dart';

class CreateCustomerUsecase {
  final CustomerRepository _customerRepository;
  CreateCustomerUsecase(this._customerRepository);
  Future<CustomersEntity> call({required AddCustomerParams customerData}) {
    return _customerRepository.addCustomer(customerData: customerData);
  }
}