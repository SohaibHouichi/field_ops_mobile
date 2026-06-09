import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_ops/features/tenants/domain/usecases/get_tenants_usecase.dart';
import 'tenant_state.dart';

class TenantCubit extends Cubit<TenantState> {
  final GetTenantsUsecase getTenants;

  TenantCubit({required this.getTenants}) : super(TenantInitial());

  Future<void> fetchTenants() async {
    try {
      emit(TenantLoading());
      final tenants = await getTenants.call();
      emit(TenantLoaded(tenants: tenants));
    } catch (e) {
      emit(TenantError(message: e.toString()));
    }
  }
}