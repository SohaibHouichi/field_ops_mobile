import 'package:field_ops/core/routes/shell_/shell_config_route.dart';
import 'package:field_ops/core/routes/shell_/shell_requirement_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellConfig {
  ShellRequirementModel routeConfiguration(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final config = shellConfigRoute.entries.lastWhere((entry) {
      return location.startsWith(entry.key);
    }).value;
    return config;
  }
}
