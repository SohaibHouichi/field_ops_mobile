

import 'package:field_ops/core/enums/customer_priority_enum.dart';
import 'package:flutter/material.dart';

extension CustomerPriorityExt on CustomerPriority {
  String get label => switch (this) {
        CustomerPriority.low     => 'Low',
        CustomerPriority.normal  => 'Normal',
        CustomerPriority.high    => 'High',
        CustomerPriority.unknown => 'Unknown',
      };

  Color get color => switch (this) {
        CustomerPriority.low     => const Color(0xFF15803D),
        CustomerPriority.normal  => const Color(0xFFB45309),
        CustomerPriority.high    => const Color(0xFFB91C1C),
        CustomerPriority.unknown => const Color(0xFF6B7280),
      };

  Color get bgColor => switch (this) {
        CustomerPriority.low     => const Color(0xFFDCFCE7),
        CustomerPriority.normal  => const Color(0xFFFEF9C3),
        CustomerPriority.high    => const Color(0xFFFEE2E2),
        CustomerPriority.unknown => const Color(0xFFF3F4F6),
      };

  IconData get icon => switch (this) {
        CustomerPriority.low     => Icons.arrow_downward_rounded,
        CustomerPriority.normal  => Icons.remove_rounded,
        CustomerPriority.high    => Icons.arrow_upward_rounded,
        CustomerPriority.unknown => Icons.help_outline,
      };
}