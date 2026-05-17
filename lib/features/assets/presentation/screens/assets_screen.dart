import 'package:field_ops/core/config/customer_priority_config.dart';
import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/enums/customer_priority_enum.dart';
import 'package:field_ops/core/widgets/filter/filter_chips_widget.dart';
import 'package:field_ops/core/widgets/hearder/count_header_widget.dart';
import 'package:field_ops/core/widgets/search_bar/search_bar_widget.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/assets_embedded_widgets/customer_assets_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerPriority?
    _priority; // This should come from the state (e.g. Bloc/Cubit)
    final TextEditingController searchController = TextEditingController();
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        final assets = state is CustomerSuccess
            ? state.customer.assetsList
            : <AssetEmbeddedEntity>[];
            final isLoading = state is CustomerLoading || state is CustomerInitial;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────
              SearchBarWidget(
                label: 'Search assets',
                controller: searchController,
                onChanged: (v) {
                  //calling search function
                },
                onClear: () {
                  searchController.clear();
                  //calling search function with empty query
                },
              ),
              const SizedBox(height: 12),
              // ── Filter Chips ─────────────────────────────────────────
              FilterChips<CustomerPriority>(
                selected: _priority,
                onSelected: (f) => _priority =
                    f, //call function to update priority filter in state
                options: [null, ...CustomerPriority.values],
                getColor: (o) => o?.color ?? primaryBlue,
                getBgColor: (o) => o?.bgColor ?? primaryBlue.withOpacity(0.12),
                getLabel: (o) => o?.label ?? 'All',
              ),
              const SizedBox(height: 12),
              CountHeader(
                count: 1,
                label: 'Assets',
              ), 
              const SizedBox(height: 20),

              Expanded(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : assets.isEmpty
                    ? const Text('No assets found')
                    : CustomerAssetsListWidget(
                        assets: assets,
                      ), 
              ),
            ],
          ),
        );
      },
    );
  }
}
