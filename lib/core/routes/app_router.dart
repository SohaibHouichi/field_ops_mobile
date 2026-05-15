import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/layers/business_logic/cubit/Home/home_cubit.dart';
import 'package:field_ops/features/auth/presentation/screens/login_screen.dart';
import 'package:field_ops/features/auth/presentation/screens/password_restoring_screen.dart';
import 'package:field_ops/features/customer/presentation/screens/customer_signup_screen.dart';
import 'package:field_ops/layers/presentation/screens/home_screens/home_screen.dart';
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

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: loginPagePath,
    refreshListenable: _AuthStateListenable(authCubit),

    redirect: (context, state) {
      final authState = authCubit.state;
      final location = state.matchedLocation;

      // ── wait for decisive state ──────────────────────────────────
      if (authState is AuthInitial || authState is AuthLoading) return null;

      final isPublic = location == loginPagePath ||
          location == passwordRestorePath ||
          location == signUpPagePath;

      // ── not authenticated → force login ─────────────────────────
      if (authState is! AuthAuthenticated) {
        return isPublic ? null : loginPagePath;
      }

      // ── authenticated on public page → go home ───────────────────
      if (isPublic) return homePagePath;

      return null;
    },

    routes: [
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
        builder: (context, state) => LoginScreen(),
        routes: [
          GoRoute(
            path: passwordRestoreName,
            name: passwordRestoreName,
            builder: (context, state) => const PasswordRestoringScreen(),
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShellRouter(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: homePagePath,
                name: homePageName,
                builder: (context, state) => BlocProvider(
                  create: (_) => DiContainer.getIt<HomeCubit>(),
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: taskPagePath,
                name: taskPageName,
                builder: (context, state) => TaskScreen(),
                routes: [
                  GoRoute(
                    path: taskDetailName,
                    name: taskDetailName,
                    builder: (context, state) => TaskDetailScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: schedulePagePath,
                name: schedulePageName,
                builder: (context, state) => ScheduleScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePagePath,
                name: profilePageName,
                builder: (context, state) => ProfileScreen(),
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