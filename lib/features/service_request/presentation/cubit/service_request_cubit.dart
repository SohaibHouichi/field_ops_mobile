import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'service_request_state.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  ServiceRequestCubit() : super(ServiceRequestInitial());
}
