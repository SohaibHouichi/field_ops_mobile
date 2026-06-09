import 'package:field_ops/core/helpers/shared_pref_helper.dart';
import 'package:field_ops/features/technician/domain/entities/technician_entity.dart';
import 'package:field_ops/features/technician/domain/usecases/technician_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'technician_state.dart';

class TechnicianCubit extends Cubit<TechnicianState> {
  final GetTechnicianByIdUsecase _getTechnicianById;

  TechnicianCubit({required GetTechnicianByIdUsecase getTechnicianById})
      : _getTechnicianById = getTechnicianById,
        super(TechnicianInitial());

  Future<void> getTechnicianById() async {
    emit(TechnicianLoading());
    try {
      final id = await SharedPrefHelper.getInt(LocalStorageKeys.userId);
      final technician = await _getTechnicianById(id.toInt());
      emit(TechnicianSuccess(technician));
    } catch (e) {
      emit(TechnicianError(e.toString()));
    }
  }
}