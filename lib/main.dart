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
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter ,
    );
  }
}
