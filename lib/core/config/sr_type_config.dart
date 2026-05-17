import 'package:field_ops/core/enums/sr_type_enum.dart';
import 'package:flutter/material.dart';

extension ServiceRequestTypeExt on ServiceRequestType {
  String get label => switch (this) {
    ServiceRequestType.maintenance => 'Maintenance',
    ServiceRequestType.repair => 'Repair',
    ServiceRequestType.installation => 'Installation',
    ServiceRequestType.inspection => 'Inspection',
    ServiceRequestType.other => 'Other',
    ServiceRequestType.unknown => 'Unknown',
  };

  Color get color => switch (this) {
    ServiceRequestType.maintenance => const Color(0xFF2196F3),
    ServiceRequestType.repair => const Color(0xFFFF9800),
    ServiceRequestType.installation => const Color(0xFF9C27B0),
    ServiceRequestType.inspection => const Color(0xFF00BCD4),
    ServiceRequestType.other => const Color(0xFF9E9E9E),
    ServiceRequestType.unknown => const Color(0xFF6B7280),
  };

  Color get bgColor => switch (this) {
    ServiceRequestType.maintenance => const Color(0xFFE3F2FD),
    ServiceRequestType.repair => const Color(0xFFFFF3E0),
    ServiceRequestType.installation => const Color(0xFFF3E5F5),
    ServiceRequestType.inspection => const Color(0xFFE0F7FA),
    ServiceRequestType.other => const Color(0xFFF5F5F5),
    ServiceRequestType.unknown => const Color(0xFFF3F4F6),
  };

  IconData get icon => switch (this) {
    ServiceRequestType.maintenance => Icons.build_outlined,
    ServiceRequestType.repair => Icons.handyman_outlined,
    ServiceRequestType.installation => Icons.install_desktop_outlined,
    ServiceRequestType.inspection => Icons.search_outlined,
    ServiceRequestType.other => Icons.miscellaneous_services_outlined,
    ServiceRequestType.unknown => Icons.help_outline,
  };
}
