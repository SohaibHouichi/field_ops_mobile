import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/di/di_container.dart';
import 'package:field_ops/core/routes/app_router.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DiContainer().setupContainer();
  runApp(const FieldOPS());
}

class FieldOPS extends StatelessWidget {
  const FieldOPS({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiContainer.getIt<AuthCubit>(),
      child: const _App(),
    );
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          background: bgColor,
          surface: inputFill,
        ),
        scaffoldBackgroundColor: bgColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryBlue),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryBlue, width: 1.5),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryBlue,
          selectionColor: primaryBlue.withOpacity(0.3),
          selectionHandleColor: primaryBlue,
        ),
        progressIndicatorTheme:
            ProgressIndicatorThemeData(color: primaryBlue),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}