import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/customer/presentation/widgets/assets_embedded_widgets/embedded_assets_sub_widgets/assets_card_sub_widget.dart';
import 'package:flutter/material.dart';

class CustomerAssetsListWidget extends StatelessWidget {
  final List<AssetEntity> assets;
  const CustomerAssetsListWidget({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: assets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => AssetCard(asset: assets[i]),
    );
  }
}
