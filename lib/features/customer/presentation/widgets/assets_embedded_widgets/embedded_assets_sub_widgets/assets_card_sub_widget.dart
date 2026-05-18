import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/presentation/cubit/assets_cubit.dart';
import 'package:field_ops/features/assets/presentation/widgets/sheets/add_asset_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetCard extends StatelessWidget {
  final AssetEntity asset;
  const AssetCard({super.key, required this.asset});

  void _openEditSheet(BuildContext context) {
    final cubit = context.read<AssetsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddAssetsSheet(
          asset: asset, // edit mode
          nameController: cubit.nameController,
          brandController: cubit.brandController,
          modelController: cubit.modelController,
          serialController: cubit.serialController,
          noteController: cubit.noteController,
          formKey: cubit.formKey,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<AssetsCubit>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Asset',
          style: TextStyle(color: primaryText, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${asset.name}"?',
          style: const TextStyle(color: secondaryText, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: secondaryText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: cubit.deleteAsset(id: asset.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const color = primaryBlue;

    return GestureDetector(
      onTap: () => _openEditSheet(context),
      onLongPress: () => _confirmDelete(context),
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
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.build_outlined, color: color, size: 14),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            asset.serialNumber ?? 'No Serial',
                            style: const TextStyle(
                              color: secondaryText, fontSize: 10,
                              fontWeight: FontWeight.w700, letterSpacing: 1.5,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const Spacer(),
                          if (asset.brand != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(asset.brand!,
                                style: const TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Text(asset.name,
                        style: const TextStyle(color: primaryText, fontSize: 14, fontWeight: FontWeight.w600),
                      ),

                      if (asset.note != null && asset.note!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(asset.note!,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: secondaryText, fontSize: 12),
                        ),
                      ],
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          if (asset.model != null) ...[
                            const Icon(Icons.memory_outlined, size: 12, color: secondaryText),
                            const SizedBox(width: 4),
                            Text(asset.model!,
                              style: const TextStyle(color: secondaryText, fontSize: 11),
                            ),
                          ],
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: chipBg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: chipBorder),
                            ),
                            child: Text('#${asset.id}',
                              style: const TextStyle(color: secondaryText, fontSize: 10, fontWeight: FontWeight.w600),
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