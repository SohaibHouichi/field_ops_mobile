

import 'package:field_ops/core/enums/employee_priority_enum.dart';
import 'package:flutter/material.dart';

extension EmployeePriorityExt on EmployeePriority {
  String get label => switch (this) {
        EmployeePriority.low     => 'Low',
        EmployeePriority.medium  => 'Medium',
        EmployeePriority.high    => 'High',
        EmployeePriority.urgent  => 'Urgent',
        EmployeePriority.unknown => 'Unknown',
      };

  Color get color => switch (this) {
        EmployeePriority.low     => const Color(0xFF15803D),
        EmployeePriority.medium  => const Color(0xFFB45309),
        EmployeePriority.high    => const Color(0xFFB91C1C),
        EmployeePriority.urgent  => const Color(0xFF7C3AED),
        EmployeePriority.unknown => const Color(0xFF6B7280),
      };

  Color get bgColor => switch (this) {
        EmployeePriority.low     => const Color(0xFFDCFCE7),
        EmployeePriority.medium  => const Color(0xFFFEF9C3),
        EmployeePriority.high    => const Color(0xFFFEE2E2),
        EmployeePriority.urgent  => const Color(0xFFEDE9FE),
        EmployeePriority.unknown => const Color(0xFFF3F4F6),
      };

  IconData get icon => switch (this) {
        EmployeePriority.low     => Icons.arrow_downward_rounded,
        EmployeePriority.medium  => Icons.remove_rounded,
        EmployeePriority.high    => Icons.arrow_upward_rounded,
        EmployeePriority.urgent  => Icons.priority_high_rounded,
        EmployeePriority.unknown => Icons.help_outline,
      };
}