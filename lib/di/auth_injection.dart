import 'package:field_ops/di/di_container.dart';
import 'package:field_ops/features/auth/business_logic/cubit/auth_cubit.dart';
import 'package:field_ops/features/auth/data/repository/auth_repository.dart';
import 'package:field_ops/features/auth/data/api/auth_web_service.dart';
import 'package:field_ops/network/dio_generate.dart';


  final getIt = DiContainer().getIt;
  final dio = DioGenerate.getDio();

void setupAuth() {

getIt.registerLazySingleton(()=>dio);

getIt.registerLazySingleton(()=>AuthWebService(getIt()));

getIt.registerLazySingleton(()=>AuthRepository(getIt())); 

getIt.registerFactory(()=>AuthCubit(getIt()));

}