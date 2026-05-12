import 'package:field_ops/core/routes/shell_/shell_config.dart';
import 'package:get_it/get_it.dart';

void setupShell(GetIt getIt) {

getIt.registerLazySingleton<ShellConfig>(()=>ShellConfig());

}