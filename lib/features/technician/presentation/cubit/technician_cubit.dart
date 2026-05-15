import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'technician_state.dart';

class TechnicianCubit extends Cubit<TechnicianState> {
  TechnicianCubit() : super(TechnicianInitial());
}
