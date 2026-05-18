// lib/features/customer/presentation/widgets/dashboard_widgets/customer_assets_widget.dart

import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/customer/presentation/widgets/assets_embedded_widgets/embedded_assets_sub_widgets/assets_Item_sub_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/assets_embedded_widgets/embedded_assets_sub_widgets/assets_view_more_button_sub_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerAssetsWidget extends StatelessWidget {
  final List<AssetEntity> assets;
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
            ...preview.map((asset) => AssetItem(asset: asset)),

            // ── View more ──────────────────────────────────────
            if (hasMore) ...[
              const SizedBox(height: 4),
              ViewMoreButton(
                remaining: remaining,
                onTap: () {
                  context.go('/customer/assets');
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}
