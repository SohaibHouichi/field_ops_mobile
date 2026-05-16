// lib/features/customer/presentation/widgets/customer_service_requests_widget.dart

import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/service_request_embedded_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/dashboard_widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CustomerServiceRequestsWidget extends StatelessWidget {
  final List<ServiceRequestEmbeddedEntity> serviceRequests;
  const CustomerServiceRequestsWidget({super.key, required this.serviceRequests});

  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoading || state is CustomerInitial) {
          return ServiceRequestSkeleton();
        }
        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: inputBorder),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      color: secondaryText, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'SERVICE REQUESTS',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${serviceRequests.length}',
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (serviceRequests.isEmpty) ...[
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'No service requests found.',
                    style: TextStyle(color: secondaryText, fontSize: 13),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                ...serviceRequests.map((sr) => _ServiceRequestItem(sr: sr)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ServiceRequestItem extends StatelessWidget {
  final ServiceRequestEmbeddedEntity sr;
  const _ServiceRequestItem({required this.sr});

  Color get _statusColor => switch (sr.status) {
        1 => const Color(0xFF4CAF50),  // open
        2 => const Color(0xFFFF9800),  // in progress
        3 => const Color(0xFF2196F3),  // completed
        _ => secondaryText,
      };

  String get _statusLabel => switch (sr.status) {
        1 => 'Open',
        2 => 'In Progress',
        3 => 'Completed',
        _ => 'Unknown',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  sr.title,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // ── Status badge ──────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                sr.reference,
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
              const Spacer(),
              if (sr.scheduledDate != null)
                Text(
                  DateFormat('MMM dd, yyyy').format(sr.scheduledDate!),
                  style: const TextStyle(
                      color: secondaryText, fontSize: 11),
                ),
            ],
          ),
          if (sr.technicianName != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person_outline,
                    color: secondaryText, size: 12),
                const SizedBox(width: 4),
                Text(
                  sr.technicianName!,
                  style: const TextStyle(
                      color: secondaryText, fontSize: 11),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}