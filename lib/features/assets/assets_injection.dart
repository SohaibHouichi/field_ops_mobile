import 'package:field_ops/core/local_storage/local_storage_data.dart';
import 'package:field_ops/core/usecases/local_storage_usecase.dart';
import 'package:field_ops/features/assets/data/data_source/assets_remote_datasource.dart';
import 'package:field_ops/features/assets/data/repository/assets_repository_impl.dart';
import 'package:field_ops/features/assets/domain/repository/assets_repository.dart';
import 'package:field_ops/features/assets/domain/usecases/add_assets_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/delete_assets_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/edit_assets_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/get_assets_by_customer_id_usecase.dart';
import 'package:field_ops/features/assets/domain/usecases/search_assets_usecase.dart';
import 'package:field_ops/features/assets/presentation/cubit/assets_cubit.dart';
import 'package:get_it/get_it.dart';

void setupAssets(GetIt getIt) {
  // ---------------DATA Source ---------------
  getIt.registerLazySingleton<AssetsRemoteDataSource>(
    () => AssetsRemoteDataSourceImpl(getIt()),
  );
  // -----------------Repository -------------
  getIt.registerLazySingleton<AssetsRepository>(
    () => AssetsRepositoryImpl(getIt<AssetsRemoteDataSource>()),
  );

  // ----------------- USECASES ----------------
  getIt.registerLazySingleton(
    () => SearchAssetsUsecase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddAssetsUsecase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAssetsByCustomerIdUseCase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => EditAssetsUsecase(getIt<AssetsRepository>()),
  );
   getIt.registerLazySingleton(
    () => DeleteAssetsUsecase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCustomerIdUsecase(getIt<LocalStorageData>()),
  );
  // ----------------------- CUBIT --------------------
  getIt.registerFactory(
    () => AssetsCubit(
      getIt<SearchAssetsUsecase>(),
      getIt<AddAssetsUsecase>(),
      getIt<GetAssetsByCustomerIdUseCase>(),
      getIt<EditAssetsUsecase>(),
      getIt<DeleteAssetsUsecase>(),
      getIt<GetCustomerIdUsecase>(),
    ),
  );
}
