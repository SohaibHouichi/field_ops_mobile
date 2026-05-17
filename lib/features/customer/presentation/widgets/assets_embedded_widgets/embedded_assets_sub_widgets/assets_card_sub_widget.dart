
import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';
import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
  final AssetEmbeddedEntity asset;
  const AssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    const color = primaryBlue;

    return GestureDetector(
      onTap: () {
        // context.go('/customer/assets/${asset.id}');
      },
      child: Container(
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
                decoration: const BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
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
                          // Icon box
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.build_outlined,
                              color: color,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Serial number
                          Text(
                            asset.serialNumber ?? 'No Serial',
                            style: const TextStyle(
                              color: secondaryText,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const Spacer(),

                          // Brand badge
                          if (asset.brand != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                asset.brand!,
                                style: const TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ── Name ─────────────────────────────────────
                      Text(
                        asset.name,
                        style: const TextStyle(
                          color: primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // ── Note ─────────────────────────────────────
                      if (asset.note != null && asset.note!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          asset.note!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // ── Model row ─────────────────────────────────
                      Row(
                        children: [
                          if (asset.model != null) ...[
                            const Icon(
                              Icons.memory_outlined,
                              size: 12,
                              color: secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              asset.model!,
                              style: const TextStyle(
                                color: secondaryText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                          const Spacer(),
                          // Asset ID chip
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
                              '#${asset.id}',
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
      ),
    );
  }
}