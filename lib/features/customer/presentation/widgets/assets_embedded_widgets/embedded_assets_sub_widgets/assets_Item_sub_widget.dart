import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:flutter/material.dart';

class AssetItem extends StatelessWidget {
  final AssetEntity asset;
  const AssetItem({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
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
          // ── Icon ──────────────────────────────────────────────
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentDim,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.settings_outlined,
              color: primaryBlue,
              size: 14,
            ),
          ),

          const SizedBox(width: 10),

          // ── Name + brand/model ─────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (asset.brand != null || asset.model != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    [asset.brand, asset.model]
                        .whereType<String>()
                        .join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Serial number ──────────────────────────────────────
          if (asset.serialNumber != null) ...[
            const SizedBox(width: 8),
            Text(
              asset.serialNumber!,
              style: const TextStyle(
                color: secondaryText,
                fontSize: 10,
                fontFamily: 'monospace',
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}