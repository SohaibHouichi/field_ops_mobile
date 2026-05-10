
import 'package:field_ops/di/auth_injection.dart';
import 'package:field_ops/di/home_injection.dart';
import 'package:field_ops/di/shell_injection.dart';
import 'package:get_it/get_it.dart';
class DiContainer{
  final GetIt getIt = GetIt.instance;

void setupContainer() {
  setupAuth();
  setupShell();
  setupHome();
}
}