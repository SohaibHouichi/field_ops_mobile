import 'package:field_ops/core/config/status_config.dart';
import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/enums/status_enums.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/service_request_embedded_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/dashboard_widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CustomerServiceRequestsWidget extends StatelessWidget {
  final List<ServiceRequestEmbeddedEntity> serviceRequests;

  const CustomerServiceRequestsWidget({
    super.key,
    required this.serviceRequests,
  });

  static const int _previewLimit = 3;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoading || state is CustomerInitial) {
          return const ServiceRequestSkeleton();
        }

        final preview = serviceRequests.take(_previewLimit).toList();
        final hasMore = serviceRequests.length > _previewLimit;
        final remaining = serviceRequests.length - _previewLimit;

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
              // ── Header ──────────────────────────────────────────
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
                ...preview.map((sr) => _ServiceRequestItem(sr: sr)),

                // ── View more ──────────────────────────────────────
                if (hasMore) ...[
                  const SizedBox(height: 4),
                  _ViewMoreButton(
                    remaining: remaining,
                    onTap: () => context.go(customerRequestsPagePath),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

// ── Service request item ──────────────────────────────────────────────────────

class _ServiceRequestItem extends StatelessWidget {
  final ServiceRequestEmbeddedEntity sr;
  const _ServiceRequestItem({required this.sr});

  @override
  Widget build(BuildContext context) {
    final status = ServiceRequestStatus.fromInt(sr.status);
    final color  = status.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder),
      ),
      child: Row(
        children: [
          // ── Status icon dot ────────────────────────────────────
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(status.icon, color: color, size: 14),
          ),

          const SizedBox(width: 10),

          // ── Title + reference ──────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sr.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sr.reference,
                  style: const TextStyle(
                    color: secondaryText,
                    fontSize: 10,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Right: badge + date ────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: status.bgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (sr.scheduledDate != null) ...[
                const SizedBox(height: 3),
                Text(
                  DateFormat('MMM dd').format(sr.scheduledDate!),
                  style: const TextStyle(
                    color: secondaryText,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── View more button ──────────────────────────────────────────────────────────

class _ViewMoreButton extends StatelessWidget {
  final int remaining;
  final VoidCallback onTap;

  const _ViewMoreButton({required this.remaining, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: primaryBlue.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryBlue.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+$remaining more requests',
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_rounded,
                color: primaryBlue, size: 14),
          ],
        ),
      ),
    );
  }
}