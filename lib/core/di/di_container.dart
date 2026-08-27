import 'package:dio/dio.dart';
import 'package:field_ops/core/di/local_storage_injection.dart';
import 'package:field_ops/features/assets/assets_injection.dart';
import 'package:field_ops/features/auth/auth_injection.dart';
import 'package:field_ops/core/di/home_injection.dart';
import 'package:field_ops/core/di/shell_injection.dart';
import 'package:field_ops/core/helpers/dio_generate.dart';
import 'package:field_ops/features/customer/customer_injection.dart';
import 'package:field_ops/features/service_request/sr_injection.dart';
import 'package:field_ops/features/technician/technician_injection.dart';
import 'package:field_ops/features/tenants/tenant_injection.dart';
import 'package:get_it/get_it.dart';

class DiContainer {
  static final GetIt getIt = GetIt.instance;

  void setupContainer() {
    final dio = DioGenerate.getDio();
    getIt.registerLazySingleton<Dio>(() => dio);

 
    setupAuth(getIt);
    setupLocalStorage(getIt);
    setupShell(getIt);
    setupCustomers(getIt);
    setupHome(getIt);
    setupAssets(getIt);
    setupSr(getIt);
    setupTenant(getIt);
    setupTechnicians(getIt);
  }
}