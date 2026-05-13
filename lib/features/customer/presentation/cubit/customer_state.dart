part of 'customer_cubit.dart';

@immutable
sealed class CustomerState {
  const CustomerState();
}

class CustomerInitial extends CustomerState {
  const  CustomerInitial();
}

class CustomerLoading extends CustomerState {
  const CustomerLoading();
}

class CustomerSuccess extends CustomerState {
  final CustomersEntity customer;
  const CustomerSuccess(this.customer);
}

class CustomerError extends CustomerState {
  final String message;
  const CustomerError(this.message);
}