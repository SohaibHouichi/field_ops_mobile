import 'package:field_ops/core/widgets/hearder/count_header_widget.dart';
import 'package:field_ops/core/widgets/search_bar/search_bar_widget.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/presentation/cubit/assets_cubit.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/assets_embedded_widgets/customer_assets_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AssetsCubit>();

    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is CustomerSuccess) {
          cubit.setAssets(state.customer.assetsList);
        }
      },
      builder: (context, customerState) {
        if (customerState is CustomerSuccess && cubit.allAssets == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cubit.setAssets(customerState.customer.assetsList);
          });
        }

        final isLoading =
            customerState is CustomerLoading ||
            customerState is CustomerInitial;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchBarWidget(
                label: 'Search assets',
                controller: cubit.searchController,
                onChanged: cubit.search,
                onClear: cubit.clearSearch,
              ),
              const SizedBox(height: 24),
              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                BlocBuilder<AssetsCubit, AssetsState>(
                  builder: (context, assetsState) {
                    final assets = assetsState is AssetsSearchSuccess
                        ? assetsState.assets
                        : <AssetEntity>[];

                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CountHeader(count: assets.length, label: 'Assets'),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Skeletonizer(
                              enabled: assetsState is AssetsLoading,
                              child: assetsState is AssetsError
                                  ? const Center(child: Text('No assets found'))
                                  : CustomerAssetsListWidget(
                                      assets: assetsState is AssetsLoading
                                          ? cubit.fakeAssetsForSkeletonizer
                                          : assets,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
