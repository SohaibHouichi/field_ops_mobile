import 'package:field_ops/features/customer/data/data_source/customers_remote_datasource.dart';
import 'package:field_ops/features/customer/data/repository/customer_repository_impl.dart';
import 'package:field_ops/features/customer/domain/repository/customer_repository.dart';
import 'package:field_ops/features/customer/domain/usecases/create_customer_usecase.dart';
import 'package:field_ops/features/customer/domain/usecases/delete_customer_usecase.dart';
import 'package:field_ops/features/customer/domain/usecases/update_customer_usecase.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:get_it/get_it.dart';

void setupCustomers(GetIt getIt) {
  // ---------DATA SOURCES------------------------------
  getIt.registerLazySingleton<CustomersRemoteDataSource>(
    () => CustomersRemoteDataSourceImpl(getIt()),
  );
  // ---------REPOSITORIES-----------------------------
  getIt.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(
      remoteDataSource: getIt<CustomersRemoteDataSource>(),
    ),
  );
  // ---------USECASES-----------------------------
  getIt.registerLazySingleton(() =>CreateCustomerUsecase(getIt<CustomerRepository>()) );
  getIt.registerLazySingleton(() =>DeleteCustomerUsecase(getIt<CustomerRepository>()) );
  getIt.registerLazySingleton(() =>UpdateCustomerUsecase(getIt<CustomerRepository>()) );
  // --------Cubits--------------------------------------
  getIt.registerFactory<CustomerCubit>(
    () => CustomerCubit(
      createCustomerUsecase: getIt<CreateCustomerUsecase>(),

    ),
  );
}
