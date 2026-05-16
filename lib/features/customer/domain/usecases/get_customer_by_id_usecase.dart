import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/domain/repository/customer_repository.dart';

class GetCustomerByIdUsecase {
  final CustomerRepository _customerRepository;

  GetCustomerByIdUsecase(this._customerRepository);

  Future<CustomersEntity> call({required int id}) async {
    return await _customerRepository.getCustomerById(id: id);
  }
}
