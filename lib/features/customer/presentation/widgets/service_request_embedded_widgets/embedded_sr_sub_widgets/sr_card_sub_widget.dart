import 'package:field_ops/core/config/status_config.dart';
import 'package:field_ops/core/config/sr_type_config.dart';
import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/enums/sr_type_enum.dart';
import 'package:field_ops/core/enums/status_enums.dart';
import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:flutter/material.dart';

class ServiceRequestCard extends StatelessWidget {
  final ServiceRequestEntity sr;
  const ServiceRequestCard({super.key, required this.sr});

  @override
  Widget build(BuildContext context) {
    final status = ServiceRequestStatus.values.elementAtOrNull(sr.status)
        ?? ServiceRequestStatus.unknown;
    final type = ServiceRequestType.values.elementAtOrNull(sr.type)
        ?? ServiceRequestType.unknown;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: inputBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ── Accent bar ──────────────────────────────────────
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: status.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),

            // ── Content ─────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top row ──────────────────────────────────
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: type.bgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(type.icon, color: type.color, size: 14),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          sr.reference,
                          style: const TextStyle(
                            color: secondaryText,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const Spacer(),
                        // ── Status chip ──────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: status.bgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(status.icon, size: 10, color: status.color),
                              const SizedBox(width: 4),
                              Text(
                                status.label,
                                style: TextStyle(
                                  color: status.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Title ────────────────────────────────────
                    Text(
                      sr.title,
                      style: const TextStyle(
                        color: primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    if (sr.description != null &&
                        sr.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        sr.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // ── Bottom row ───────────────────────────────
                    Row(
                      children: [
                        // ── Type label ───────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: type.bgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            type.label,
                            style: TextStyle(
                              color: type.color,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (sr.assetName != null) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.settings_outlined,
                            size: 12,
                            color: secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            sr.assetName!,
                            style: const TextStyle(
                              color: secondaryText,
                              fontSize: 11,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: chipBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: chipBorder),
                          ),
                          child: Text(
                            '#${sr.id}',
                            style: const TextStyle(
                              color: secondaryText,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}