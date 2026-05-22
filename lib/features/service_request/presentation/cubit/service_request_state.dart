part of 'service_request_cubit.dart';

abstract class ServiceRequestState {}

class ServiceRequestInitial extends ServiceRequestState {}

class ServiceRequestLoading extends ServiceRequestState {}

class ServiceRequestListSuccess extends ServiceRequestState {
  final List<ServiceRequestEntity> serviceRequests;
  ServiceRequestListSuccess(this.serviceRequests);
}

class ServiceRequestCreated extends ServiceRequestState {}

class ServiceRequestUpdated extends ServiceRequestState {}

class ServiceRequestDeleted extends ServiceRequestState {}

class ServiceRequestFailure extends ServiceRequestState {
  final String message;
  ServiceRequestFailure(this.message);
}