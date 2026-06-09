import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/helpers/shared_pref_helper.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/profile_widgets/error_view_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/profile_widgets/profile_body_widget.dart';
import 'package:field_ops/features/technician/presentation/cubit/technician_cubit.dart';
import 'package:field_ops/features/technician/presentation/widgets/techician_body_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TechnicianProfile extends StatefulWidget {
  const TechnicianProfile({super.key});

  @override
  State<TechnicianProfile> createState() => _TechnicianProfileScreenState();
}

class _TechnicianProfileScreenState extends State<TechnicianProfile> {
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRoleAndFetch();
  }

  Future<void> _loadRoleAndFetch() async {
    final role = await SharedPrefHelper.getString(LocalStorageKeys.role);
    if (!mounted) return;
    setState(() => _role = role);

    if (role == 'Technician') {
      context.read<TechnicianCubit>().getTechnicianById();
    } else {
      context.read<CustomerCubit>().getCustomerById();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: _role == null
              // ── Role not loaded yet ───────────────────────────
              ? const Center(
                  child: CircularProgressIndicator(color: primaryBlue),
                )
              : _role == 'Technician'
                  // ── Technician ────────────────────────────────
                  ? BlocBuilder<TechnicianCubit, TechnicianState>(
                      builder: (context, state) {
                        if (state is TechnicianInitial ||
                            state is TechnicianLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryBlue,
                            ),
                          );
                        }
                        if (state is TechnicianError) {
                          return ErrorView(message: state.message);
                        }
                        if (state is TechnicianSuccess) {
                          return TechnicianProfileBody(
                            technician: state.technician,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  // ── Customer ──────────────────────────────────
                  : BlocBuilder<CustomerCubit, CustomerState>(
                      builder: (context, state) {
                        if (state is CustomerInitial ||
                            state is CustomerLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryBlue,
                            ),
                          );
                        }
                        if (state is CustomerError) {
                          return ErrorView(message: state.message);
                        }
                        if (state is CustomerSuccess) {
                          return ProfileBody(customer: state.customer);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
        ),
      ),
    );
  }
}