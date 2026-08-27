import 'package:field_ops/core/local_storage/local_storage_data.dart';

class GetCustomerIdUsecase {
  final LocalStorageData _repository;

  GetCustomerIdUsecase(this._repository);

  Future<int> call() async {
    return await _repository.getDataFromLocalStorage();
  }
}