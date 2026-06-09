
import 'package:field_ops/features/technician/data/data_source/technician_remote_datasource.dart';
import 'package:field_ops/features/technician/data/repository/technician_repository_impl.dart';
import 'package:field_ops/features/technician/domain/repository/technician_repository.dart';
import 'package:field_ops/features/technician/domain/usecases/technician_usecases.dart';
import 'package:field_ops/features/technician/presentation/cubit/technician_cubit.dart';
import 'package:get_it/get_it.dart';

void setupTechnicians(GetIt getIt) {
  // ── Data sources ──────────────────────────────────────────────────
  getIt.registerLazySingleton<TechnicianRemoteDataSource>(
    () => TechnicianRemoteDataSourceImpl(getIt()),
  );
  // ── Repositories ──────────────────────────────────────────────────
  getIt.registerLazySingleton<TechnicianRepository>(
    () => TechnicianRepositoryImpl(getIt<TechnicianRemoteDataSource>()),
  );
  // ── Usecases ──────────────────────────────────────────────────────
  getIt.registerLazySingleton(
    () => GetTechnicianByIdUsecase(getIt<TechnicianRepository>()),
  );
  // ── Cubits ────────────────────────────────────────────────────────
  getIt.registerFactory<TechnicianCubit>(
    () => TechnicianCubit(
      getTechnicianById: getIt<GetTechnicianByIdUsecase>(),
    ),
  );
}