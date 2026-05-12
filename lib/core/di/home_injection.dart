import 'package:field_ops/layers/business_logic/cubit/Home/home_cubit.dart';
import 'package:get_it/get_it.dart';

void setupHome(GetIt getIt) {
  getIt.registerFactory(()=>HomeCubit());
}