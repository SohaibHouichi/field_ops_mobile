import 'package:field_ops/constants/about_routing.dart';
import 'package:field_ops/di/auth_injection.dart';
import 'package:field_ops/layers/business_logic/cubit/Auth/auth_cubit.dart';
import 'package:field_ops/layers/business_logic/cubit/Home/home_cubit.dart';
import 'package:field_ops/features/auth/presentation/screens/login_screen.dart';
import 'package:field_ops/features/auth/presentation/screens/password_restoring_screen.dart';
import 'package:field_ops/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:field_ops/layers/presentation/screens/home_screens/home_screen.dart';
import 'package:field_ops/layers/presentation/screens/profile_screens/profile_screen.dart';
import 'package:field_ops/layers/presentation/screens/schedule_screens/schedule_screen.dart';
import 'package:field_ops/layers/presentation/screens/shell_/main_shell_router.dart';
import 'package:field_ops/layers/presentation/screens/task_screens/task_detail_screen.dart';
import 'package:field_ops/layers/presentation/screens/task_screens/task_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: loginPagePath,
  routes: [
    //
    GoRoute(
      path: signUpPagePath,
      name: signUpPageName,
      builder: (context, state) => const SignUpScreen(),
    ),
    //
    GoRoute(
      path: loginPagePath,
      name: loginPageName,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: LoginScreen(),
        );
      },
      routes: [
        GoRoute(
          path: passwordRestoreName,
          name: passwordRestoreName,
          builder: (context, state) => const PasswordRestoringScreen(),
        ),
      ],
    ),
    //
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        return MainShellRouter(navigationShell: child);
      },
      branches: [
        //
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: homePagePath,
              name: homePageName,
              builder: (context, state) => BlocProvider(
                create: (context) => getIt<HomeCubit>(),
                child: HomeScreen(),
              ),
            ),
          ],
        ),
        //
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
        //
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: schedulePagePath,
              name: schedulePageName,
              builder: (context, state) => ScheduleScreen(),
            ),
          ],
        ),
        //
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
