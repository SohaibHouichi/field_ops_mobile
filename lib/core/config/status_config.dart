// lib/core/config/status_config.dart

import 'package:field_ops/core/enums/status_enums.dart';
import 'package:flutter/material.dart';

// ── Service Request Status ────────────────────────────────────────────────────
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


