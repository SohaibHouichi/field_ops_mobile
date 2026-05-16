// lib/features/customer/presentation/widgets/dashboard_widgets/customer_assets_widget.dart

import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';
import 'package:flutter/material.dart';

class CustomerAssetsWidget extends StatelessWidget {
  final List<AssetEmbeddedEntity> assets;
  const CustomerAssetsWidget({super.key, required this.assets});

  static const int _previewLimit = 3;

  @override
  Widget build(BuildContext context) {
    final preview   = assets.take(_previewLimit).toList();
    final hasMore   = assets.length > _previewLimit;
    final remaining = assets.length - _previewLimit;

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
            ...preview.map((asset) => _AssetItem(asset: asset)),

            // ── View more ──────────────────────────────────────
            if (hasMore) ...[
              const SizedBox(height: 4),
              _ViewMoreButton(
                remaining: remaining,
                onTap: () {
                  // TODO: navigate to full assets screen
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ── Asset item ────────────────────────────────────────────────────────────────

class _AssetItem extends StatelessWidget {
  final AssetEmbeddedEntity asset;
  const _AssetItem({required this.asset});

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
              '+$remaining more assets',
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