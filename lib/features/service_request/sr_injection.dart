
import 'package:field_ops/core/usecases/local_storage_usecase.dart';
import 'package:field_ops/features/service_request/data/data_source/service_request_remote_datasource.dart';
import 'package:field_ops/features/service_request/data/repository/service_request_repository_impl.dart';
import 'package:field_ops/features/service_request/domain/repository/service_request_repository.dart';
import 'package:field_ops/features/service_request/domain/usecases/create_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/delete_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/get_sr_by_customer_id_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/search_sr_usecase.dart';
import 'package:field_ops/features/service_request/domain/usecases/update_sr_usecase.dart';
import 'package:field_ops/features/service_request/presentation/cubit/service_request_cubit.dart';
import 'package:get_it/get_it.dart';

void setupSr(GetIt getIt) {
  // ---------------DATA Source ---------------
  getIt.registerLazySingleton<ServiceRequestRemoteDatasource>(
    () => ServiceRequestRemoteDatasourceImpl(getIt()),
  );
  // -----------------Repository -------------
  getIt.registerLazySingleton<ServiceRequestRepository>(
    () => ServiceRequestRepositoryImpl(getIt<ServiceRequestRemoteDatasource>()),
  );
  // ----------------- USECASES ---------------
  getIt.registerLazySingleton(
    () => CreateSrUsecase(getIt<ServiceRequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateSrUsecase(getIt<ServiceRequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteSrUsecase(getIt<ServiceRequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => SearchSrUsecase(getIt<ServiceRequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetSrByCustomerIdUsecase(getIt<ServiceRequestRepository>()),
  );
  // ----------------------- CUBIT --------------------
  getIt.registerFactory(
    () => ServiceRequestCubit(
      createSr: getIt<CreateSrUsecase>(),
      deleteSr: getIt<DeleteSrUsecase>(),
      getSrByCustomerId: getIt<GetSrByCustomerIdUsecase>(),
   //   searchSr: getIt<SearchSrUsecase>(),
      updateSr: getIt<UpdateSrUsecase>(),
      getCustomerId: getIt<GetCustomerIdUsecase>(),
    ),
  );
}
