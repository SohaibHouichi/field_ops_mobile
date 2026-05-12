import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/routes/app_router.dart';
import 'package:field_ops/core/di/di_container.dart';
import 'package:flutter/material.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
   DiContainer().setupContainer();
  runApp(const FieldOPS());
}

class FieldOPS extends StatelessWidget {
  const FieldOPS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,        // replaces purple seed
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
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
      ),
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

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryBlue,
    ),
  ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter ,
    );
  }
}
