import 'package:field_ops/features/customer/domain/repository/customer_repository.dart';

class DeleteCustomerUsecase {
  final CustomerRepository _customersRepository;
  DeleteCustomerUsecase(this._customersRepository);
  Future<void> call({required int id}) {
    return _customersRepository.deleteCustomer(id: id);
  }
}