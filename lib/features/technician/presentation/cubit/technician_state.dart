part of 'technician_cubit.dart';

@immutable
sealed class TechnicianState {
  const TechnicianState();
}

class TechnicianInitial extends TechnicianState {
  const TechnicianInitial();
}

class TechnicianLoading extends TechnicianState {
  const TechnicianLoading();
}

class TechnicianSuccess extends TechnicianState {
  final TechnicianEntity technician;
  const TechnicianSuccess(this.technician);
}

class TechnicianError extends TechnicianState {
  final String message;
  const TechnicianError(this.message);
}