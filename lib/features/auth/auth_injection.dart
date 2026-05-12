import 'package:field_ops/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:field_ops/features/auth/data/repository/auth_repository_impl.dart';
import 'package:field_ops/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:field_ops/features/auth/domain/usecases/login_usecase.dart';
import 'package:field_ops/features/auth/domain/usecases/logout_usecase.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:field_ops/features/auth/domain/repository/auth_repository.dart';
import 'package:field_ops/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:get_it/get_it.dart';

void setupAuth(GetIt getIt) {
  // ---- DATA SOURCES --------------------------------
  getIt.registerLazySingleton<AuthRemoteDataSource>( 
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(   
    () => AuthLocalDataSourceImpl(),
  );

  // ---- REPOSITORY ----------------------------------
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(), 
      localDataSource: getIt<AuthLocalDataSource>(),   
    ),
  );

  // ---- USE CASES -----------------------------------
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUserUsecase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUsecase(getIt<AuthRepository>()));

  // ---- CUBIT ---------------------------------------
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
      logoutUsecase: getIt<LogoutUsecase>(),
    ),
  );
}
