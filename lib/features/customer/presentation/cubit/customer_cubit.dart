import 'package:bloc/bloc.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/domain/usecases/create_customer_usecase.dart';
import 'package:field_ops/features/customer/domain/usecases/params/add_customer_params.dart';
import 'package:meta/meta.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CreateCustomerUsecase _createCustomerUsecase;

  CustomerCubit({required CreateCustomerUsecase createCustomerUsecase})
      : _createCustomerUsecase = createCustomerUsecase,
        super(CustomerInitial());

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