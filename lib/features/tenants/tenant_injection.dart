
import 'package:field_ops/features/tenants/data/data_source/tenant_remote_datasource.dart';
import 'package:field_ops/features/tenants/data/repository/tenant_repository_impl.dart';
import 'package:field_ops/features/tenants/domain/repository/tenant_repository.dart';
import 'package:field_ops/features/tenants/domain/usecases/get_tenants_usecase.dart';
import 'package:field_ops/features/tenants/presentation/cubit/tenant_cubit.dart';
import 'package:get_it/get_it.dart';

void setupTenant(GetIt getIt) {
  // ---------DATA SOURCES------------------------------
  getIt.registerLazySingleton<TenantRemoteDataSource>(
    () => TenantRemoteDataSourceImpl(getIt()),
  );
  // ---------REPOSITORIES-----------------------------
  getIt.registerLazySingleton<TenantRepository>(
    () => TenantRepositoryImpl(
      remoteDataSource: getIt<TenantRemoteDataSource>(),
    ),
  );
  // ---------USECASES-----------------------------
  getIt.registerLazySingleton(() =>GetTenantsUsecase(getIt<TenantRepository>()) );
 
  // --------Cubits--------------------------------------
  getIt.registerFactory<TenantCubit>(
    () => TenantCubit(
      getTenants: getIt<GetTenantsUsecase>(),

    ),
  );
}
