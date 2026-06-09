import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_ops/features/tenants/presentation/cubit/tenant_cubit.dart';
import 'package:field_ops/features/tenants/presentation/cubit/tenant_state.dart';

class DropDownRegistrationWidget extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const DropDownRegistrationWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenantCubit, TenantState>(
      builder: (context, state) {
        if (state is TenantLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is TenantError) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        }

        final tenants = state is TenantLoaded
            ? state.tenants
            : <dynamic>[];

        return DropdownButtonFormField<String>(
          value: value,
          hint: const Text('Select tenant'),
          isExpanded: true,
          validator: validator ??
              (v) => v == null ? 'Please select a tenant' : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: tenants
              .map(
                (tenant) => DropdownMenuItem<String>(
                  value: tenant.name,
                  child: Text(tenant.name),
                ),
              )
              .toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}