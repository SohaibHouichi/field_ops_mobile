// lib/core/config/status_config.dart

import 'package:flutter/material.dart';

// ── Service Request Status ────────────────────────────────────────────────────

enum ServiceRequestStatus {
  newRequest(1),
  accepted(2),
  rejected(3),
  scheduled(4),
  inProgress(5),
  onHold(6),
  completed(7),
  cancelled(8),
  unknown(-1);

  final int value;
  const ServiceRequestStatus(this.value);

  static ServiceRequestStatus fromInt(int v) => switch (v) {
        1 => newRequest,
        2 => accepted,
        3 => rejected,
        4 => scheduled,
        5 => inProgress,
        6 => onHold,
        7 => completed,
        8 => cancelled,
        _ => unknown,
      };
}

extension ServiceRequestStatusExt on ServiceRequestStatus {
  String get label => switch (this) {
        ServiceRequestStatus.newRequest => 'New',
        ServiceRequestStatus.accepted   => 'Accepted',
        ServiceRequestStatus.rejected   => 'Rejected',
        ServiceRequestStatus.scheduled  => 'Scheduled',
        ServiceRequestStatus.inProgress => 'In Progress',
        ServiceRequestStatus.onHold     => 'On Hold',
        ServiceRequestStatus.completed  => 'Completed',
        ServiceRequestStatus.cancelled  => 'Cancelled',
        ServiceRequestStatus.unknown    => 'Unknown',
      };

  Color get color => switch (this) {
        ServiceRequestStatus.newRequest => const Color(0xFF1D4ED8),
        ServiceRequestStatus.accepted   => const Color(0xFF15803D),
        ServiceRequestStatus.rejected   => const Color(0xFFB91C1C),
        ServiceRequestStatus.scheduled  => const Color(0xFF4338CA),
        ServiceRequestStatus.inProgress => const Color(0xFFB45309),
        ServiceRequestStatus.onHold     => const Color(0xFF4B5563),
        ServiceRequestStatus.completed  => const Color(0xFF166534),
        ServiceRequestStatus.cancelled  => const Color(0xFF991B1B),
        ServiceRequestStatus.unknown    => const Color(0xFF6B7280),
      };

  Color get bgColor => switch (this) {
        ServiceRequestStatus.newRequest => const Color(0xFFDBEAFE),
        ServiceRequestStatus.accepted   => const Color(0xFFDCFCE7),
        ServiceRequestStatus.rejected   => const Color(0xFFFEE2E2),
        ServiceRequestStatus.scheduled  => const Color(0xFFE0E7FF),
        ServiceRequestStatus.inProgress => const Color(0xFFFEF9C3),
        ServiceRequestStatus.onHold     => const Color(0xFFE5E7EB),
        ServiceRequestStatus.completed  => const Color(0xFFBBF7D0),
        ServiceRequestStatus.cancelled  => const Color(0xFFFECACA),
        ServiceRequestStatus.unknown    => const Color(0xFFF3F4F6),
      };

  IconData get icon => switch (this) {
        ServiceRequestStatus.newRequest => Icons.fiber_new_outlined,
        ServiceRequestStatus.accepted   => Icons.thumb_up_outlined,
        ServiceRequestStatus.rejected   => Icons.thumb_down_outlined,
        ServiceRequestStatus.scheduled  => Icons.calendar_month_outlined,
        ServiceRequestStatus.inProgress => Icons.pending_outlined,
        ServiceRequestStatus.onHold     => Icons.pause_circle_outline,
        ServiceRequestStatus.completed  => Icons.check_circle_outline,
        ServiceRequestStatus.cancelled  => Icons.cancel_outlined,
        ServiceRequestStatus.unknown    => Icons.help_outline,
      };
}

// ── Service Request Type — Maintenance=1, Repair=2, Installation=3, Inspection=4, Other=5 ──

enum ServiceRequestType {
  maintenance(1),
  repair(2),
  installation(3),
  inspection(4),
  other(5),
  unknown(-1);

  final int value;
  const ServiceRequestType(this.value);

  static ServiceRequestType fromInt(int v) => switch (v) {
        1 => maintenance,
        2 => repair,
        3 => installation,
        4 => inspection,
        5 => other,
        _ => unknown,
      };
}

extension ServiceRequestTypeExt on ServiceRequestType {
  String get label => switch (this) {
        ServiceRequestType.maintenance  => 'Maintenance',
        ServiceRequestType.repair       => 'Repair',
        ServiceRequestType.installation => 'Installation',
        ServiceRequestType.inspection   => 'Inspection',
        ServiceRequestType.other        => 'Other',
        ServiceRequestType.unknown      => 'Unknown',
      };

  Color get color => switch (this) {
        ServiceRequestType.maintenance  => const Color(0xFF2196F3),
        ServiceRequestType.repair       => const Color(0xFFFF9800),
        ServiceRequestType.installation => const Color(0xFF9C27B0),
        ServiceRequestType.inspection   => const Color(0xFF00BCD4),
        ServiceRequestType.other        => const Color(0xFF9E9E9E),
        ServiceRequestType.unknown      => const Color(0xFF6B7280),
      };

  Color get bgColor => switch (this) {
        ServiceRequestType.maintenance  => const Color(0xFFE3F2FD),
        ServiceRequestType.repair       => const Color(0xFFFFF3E0),
        ServiceRequestType.installation => const Color(0xFFF3E5F5),
        ServiceRequestType.inspection   => const Color(0xFFE0F7FA),
        ServiceRequestType.other        => const Color(0xFFF5F5F5),
        ServiceRequestType.unknown      => const Color(0xFFF3F4F6),
      };

  IconData get icon => switch (this) {
        ServiceRequestType.maintenance  => Icons.build_outlined,
        ServiceRequestType.repair       => Icons.handyman_outlined,
        ServiceRequestType.installation => Icons.install_desktop_outlined,
        ServiceRequestType.inspection   => Icons.search_outlined,
        ServiceRequestType.other        => Icons.miscellaneous_services_outlined,
        ServiceRequestType.unknown      => Icons.help_outline,
      };
}

// ── Customer Priority — Low=1, Normal=2, High=3 ───────────────────────────────

enum CustomerPriority {
  low(1),
  normal(2),
  high(3),
  unknown(-1);

  final int value;
  const CustomerPriority(this.value);

  static CustomerPriority fromInt(int v) => switch (v) {
        1 => low,
        2 => normal,
        3 => high,
        _ => unknown,
      };
}

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

// ── Employee Priority — Low=1, Medium=2, High=3, Urgent=4 ────────────────────

enum EmployeePriority {
  low(1),
  medium(2),
  high(3),
  urgent(4),
  unknown(-1);

  final int value;
  const EmployeePriority(this.value);

  static EmployeePriority fromInt(int v) => switch (v) {
        1 => low,
        2 => medium,
        3 => high,
        4 => urgent,
        _ => unknown,
      };
}

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