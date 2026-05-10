  import 'package:field_ops/di/di_container.dart';
import 'package:field_ops/layers/presentation/screens/shell_/shell_config.dart';

final getIt = DiContainer().getIt;


void setupShell() {

getIt.registerLazySingleton<ShellConfig>(()=>ShellConfig());

}