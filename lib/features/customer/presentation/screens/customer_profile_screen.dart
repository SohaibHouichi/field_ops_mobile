import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/profile_widgets/error_view_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/profile_widgets/profile_body_widget.dart';
// import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authState = context.read<AuthCubit>().state;
    // final id = authState is AuthAuthenticated
    //     ? authState.user.userId
    //     : 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: BlocBuilder<CustomerCubit, CustomerState>(
            builder: (context, state) {
              if (state is CustomerInitial || state is CustomerLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryBlue),
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

