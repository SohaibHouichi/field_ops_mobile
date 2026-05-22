import 'package:field_ops/core/widgets/empty_lists_ui/empty_lists_widget.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/customer/presentation/widgets/assets_embedded_widgets/embedded_assets_sub_widgets/assets_card_sub_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerAssetsListWidget extends StatelessWidget {
  final List<AssetEntity> assets;
  final bool isLoading;
  const CustomerAssetsListWidget({
    super.key,
    required this.assets,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final fakeAssets = List.generate(5, (_) => AssetEntity(id: 0, name: ''));

    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: ListView.separated(
          itemCount: fakeAssets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => AssetCard(asset: fakeAssets[i]),
        ),
      );
    }

    if (assets.isEmpty) return const EmptyState();

    return ListView.separated(
      itemCount: assets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => AssetCard(asset: assets[i]),
    );
  }
}
