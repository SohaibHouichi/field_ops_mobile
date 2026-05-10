  import 'package:field_ops/di/di_container.dart';
import 'package:field_ops/layers/business_logic/cubit/Home/home_cubit.dart';

final getIt = DiContainer().getIt;

void setupHome() {
  getIt.registerFactory(()=>HomeCubit());
}