import 'package:field_ops/core/local_storage/local_storage_data.dart';
import 'package:field_ops/core/local_storage/local_storage_data_impl.dart';
import 'package:get_it/get_it.dart';

void setupLocalStorage(GetIt getIt) {
  getIt.registerLazySingleton<LocalStorageData>(
    () => LocalStorageDataImpl(),
  );
}