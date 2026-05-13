import 'package:field_ops/features/customer/domain/repository/customer_repository.dart';
import 'package:field_ops/features/customer/domain/usecases/params/update_customer_params.dart';

class UpdateCustomerUsecase {
  final CustomerRepository _customersRepository;
  UpdateCustomerUsecase(this._customersRepository);
  Future<void> call({required int id, required UpdateCustomerParams customerData}) {
    return _customersRepository.updateCustomer(
      id: id,
      customerData: customerData,
    );
  }
}