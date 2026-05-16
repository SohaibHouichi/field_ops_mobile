import 'package:bloc/bloc.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/domain/usecases/create_customer_usecase.dart';
import 'package:field_ops/features/customer/domain/usecases/get_customer_by_id_usecase.dart';
import 'package:field_ops/features/customer/domain/usecases/params/add_customer_params.dart';
import 'package:meta/meta.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CreateCustomerUsecase _createCustomerUsecase;
  final GetCustomerByIdUsecase _getCustomerByIdUsecase;

  CustomerCubit({required CreateCustomerUsecase createCustomerUsecase,
                required GetCustomerByIdUsecase getCustomerByIdUsecase
      })
      : _createCustomerUsecase = createCustomerUsecase,
        _getCustomerByIdUsecase = getCustomerByIdUsecase,
        super(CustomerInitial());
  // getting customer by id -----------
  Future<CustomersEntity> getCustomerById({required int id}) async {
    emit(CustomerLoading());
    try {
      final customer = await _getCustomerByIdUsecase(id: id);
      emit(CustomerSuccess(customer));
      return customer;
    } catch (e) {
      emit(CustomerError(e.toString()));
      return Future.error(e);
    }
  }
  // Creation of a new customer -----------
  Future<void> createCustomer({
    required String firstName,
    required String lastName,
    required String email,
    required int gender,
    required String phoneNumber,
    required String addressId,
    required String note,
    DateTime? birthDate,
  }) async {
    emit(CustomerLoading());
    try {
      final customer = await _createCustomerUsecase(
        customerData: AddCustomerParams(
          firstName: firstName,
          lastName: lastName,
          email: email,
          gender: gender,
          phoneNumber: phoneNumber,
          addressId: addressId,
          note: note,
          birthDate: birthDate,
        ),
      );
      emit(CustomerSuccess(customer));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}