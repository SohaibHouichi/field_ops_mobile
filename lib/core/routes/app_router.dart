import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/features/assets/presentation/cubit/assets_cubit.dart';
import 'package:field_ops/features/assets/presentation/screens/assets_screen.dart';
import 'package:field_ops/features/auth/domain/entities/user_entity.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/screens/customer_dashboard_screen.dart';
import 'package:field_ops/features/customer/presentation/screens/customer_profile_screen.dart';
import 'package:field_ops/features/service_request/presentation/cubit/service_request_cubit.dart';
import 'package:field_ops/features/service_request/presentation/screens/service_request_screen.dart';
import 'package:field_ops/features/technician/presentation/cubit/technician_cubit.dart';
import 'package:field_ops/features/technician/presentation/screens/technician_dashboard_screen.dart';
import 'package:field_ops/features/technician/presentation/screens/technician_profile.dart';
import 'package:field_ops/layers/business_logic/cubit/Home/home_cubit.dart';
import 'package:field_ops/features/auth/presentation/screens/login_screen.dart';
import 'package:field_ops/features/auth/presentation/screens/password_restoring_screen.dart';
import 'package:field_ops/features/customer/presentation/screens/customer_signup_screen.dart';
import 'package:field_ops/layers/presentation/screens/profile_screens/profile_screen.dart';
import 'package:field_ops/layers/presentation/screens/schedule_screens/schedule_screen.dart';
import 'package:field_ops/core/routes/shell_/main_shell_router.dart';
import 'package:field_ops/layers/presentation/screens/task_screens/task_detail_screen.dart';
import 'package:field_ops/layers/presentation/screens/task_screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/di_container.dart';

GoRouter _buildRouter() {
  final authCubit = DiContainer.getIt<AuthCubit>();
  final customerCubit = DiContainer.getIt<CustomerCubit>();
  final assetsCubit = DiContainer.getIt<AssetsCubit>();
  final srCubit = DiContainer.getIt<ServiceRequestCubit>();

  final tech = DiContainer.getIt<TechnicianCubit>();

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: loginPagePath,
    refreshListenable: _AuthStateListenable(authCubit),

    redirect: (context, state) {
      final authState = authCubit.state;
      final location = state.matchedLocation;

      if (authState is AuthInitial || authState is AuthLoading) return null;

      final isPublic =
          location == loginPagePath ||
          location == passwordRestorePath ||
          location == signUpPagePath;

      if (authState is! AuthAuthenticated) {
        return isPublic ? null : loginPagePath;
      }

      // ── authenticated on public page → redirect by role ──────────
      if (isPublic) {
        return authCubit.authenticatedUser?.role == UserRole.technician
            ? technicianHomePagePath
            : customerHomePagePath;
      }

      // ── guard cross-role access ───────────────────────────────────
      final isTechnician =
          authCubit.authenticatedUser?.role == UserRole.technician;
      final isCustomerRoute = location.startsWith('/customer');
      final isTechnicianRoute = location.startsWith('/technician');

      if (isTechnician && isCustomerRoute) return technicianHomePagePath;
      if (!isTechnician && isTechnicianRoute) return customerHomePagePath;

      return null;
    },

    routes: [
      // ── Public routes ─────────────────────────────────────────────
      GoRoute(
        path: signUpPagePath,
        name: signUpPageName,
        builder: (context, state) => BlocProvider.value(
          value: customerCubit,
          child: const CustomerSignUpScreen(),
        ),
      ),
      GoRoute(
        path: loginPagePath,
        name: loginPageName,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: passwordRestoreName,
            name: passwordRestoreName,
            builder: (context, state) => const PasswordRestoringScreen(),
          ),
        ],
      ),

      // ── Customer shell ────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: customerCubit),
            BlocProvider.value(value: assetsCubit),
            BlocProvider.value(value: srCubit),
          ],
          child: MainShellRouter(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: customerHomePagePath, // e.g. '/customer/home'
                name: customerHomePageName,
                builder: (context, state) => const CustomerDashboard(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: customerRequestsPagePath, // e.g. '/customer/requests'
                name: customerRequestsPageName,
                builder: (context, state) => ServiceRequestScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: customerAssetsPagePath, // e.g. '/customer/assets'
                name: customerAssetsPageName,
                builder: (context, state) => AssetsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: customerProfilePagePath, // e.g. '/customer/profile'
                name: customerProfilePageName,
                builder: (context, state) => CustomerProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Technician shell ──────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: tech),
          
          ],
          child: MainShellRouter(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: technicianHomePagePath, // e.g. '/technician/home'
                name: technicianHomePageName,
                builder: (context, state) => BlocProvider(
                  create: (_) => DiContainer.getIt<HomeCubit>(),
                  child: const TechnicianDashboard(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: taskPagePath, // e.g. '/technician/tasks'
                name: taskPageName,
                builder: (context, state) => const ServiceRequest(),
                routes: [
                  GoRoute(
                    path: taskDetailName,
                    name: taskDetailName,
                    builder: (context, state) => const TaskDetailScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: schedulePagePath, // e.g. '/technician/schedule'
                name: schedulePageName,
                builder: (context, state) => const AttachmentsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePagePath,
                name: profilePageName,
                builder: (context, state) => const TechnicianProfile(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

final GoRouter appRouter = _buildRouter();

class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(AuthCubit cubit) {
    cubit.stream.listen((_) => notifyListeners());
  }
}
