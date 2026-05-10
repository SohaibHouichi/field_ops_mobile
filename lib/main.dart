import 'package:field_ops/app_router.dart';
import 'package:field_ops/di/di_container.dart';
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
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter ,
    );
  }
}
