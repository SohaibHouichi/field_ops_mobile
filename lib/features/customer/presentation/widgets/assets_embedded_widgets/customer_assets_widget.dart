import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';
import 'package:flutter/material.dart';

class CustomerAssetsWidget extends StatelessWidget {
  final List<AssetEmbeddedEntity> assets;
  const CustomerAssetsWidget({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
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
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.build_outlined, color: secondaryText, size: 16),
              const SizedBox(width: 8),
              const Text(
                'ASSETS',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${assets.length}',
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          if (assets.isEmpty) ...[
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'No assets found.',
                style: TextStyle(color: secondaryText, fontSize: 13),
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),
            ...assets.map((asset) => _AssetItem(asset: asset)),
          ],
        ],
      ),
    );
  }
}

class _AssetItem extends StatelessWidget {
  final AssetEmbeddedEntity asset;
  const _AssetItem({required this.asset});

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
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentDim,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.settings_outlined,
              color: primaryBlue,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (asset.brand != null || asset.model != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    [asset.brand, asset.model].whereType<String>().join(' · '),
                    style: const TextStyle(color: secondaryText, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          if (asset.serialNumber != null)
            Text(
              asset.serialNumber!,
              style: const TextStyle(
                color: secondaryText,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
        ],
      ),
    );
  }
}
