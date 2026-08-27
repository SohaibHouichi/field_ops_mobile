import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/presentation/cubit/assets_cubit.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/assets_embedded_widgets/customer_assets_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/dashboard_widgets/status_chip_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/service_request_embedded_widgets/customer_service_requests_widget.dart';
import 'package:field_ops/features/service_request/presentation/cubit/service_request_cubit.dart';
import 'package:field_ops/features/technician/presentation/screens/technician_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<CustomerCubit>().state;
    if (state is! CustomerSuccess && state is! CustomerLoading) {
      context.read<CustomerCubit>().getCustomerById();
    }
    final customer = context.select((CustomerCubit cubit) {
      final state = cubit.state;
      if (state is CustomerSuccess) return state.customer;
      return null;
    });

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        // ── Status chip row ───────────────────────────────────────
        const Row(
          children: [
            StatusChip(label: 'ACTIVE PLAN', value: 'ENTERPRISE'),
            SizedBox(width: 8),
            StatusChip(label: 'SLA', value: '99.8%'),
          ],
        ),

        const SizedBox(height: 20),

        // ── Summary cards ─────────────────────────────────────────
        // Only the "My Assets" card depends on assets, so the whole
        // row is wrapped to keep the asset count in sync once assets
        // have been loaded at least once.
        BlocBuilder<AssetsCubit, AssetsState>(
          builder: (context, _) {
            final assets = _resolveAssets(context, customer);
            return Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    icon: Icons.build_circle_outlined,
                    label: 'Open\nRequests',
                    value: _openRequests(customer),
                    accent: primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    icon: Icons.check_circle_outline,
                    label: 'Completed\nThis Month',
                    value: _completedRequests(customer),
                    accent: const Color(0xFF4ADE80),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Skeletonizer(
                    enabled: state is AssetsLoading,
                    child: SummaryCard(
                      icon: Icons.inventory_2_outlined,
                      label: 'My\nAssets',
                      value: state is AssetsLoading ? '00' : '${assets.length}',
                      accent: const Color(0xFFFBBF24),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 20),

        // ── Active requests ───────────────────────────────────────
        const SectionHeader(title: 'REQUESTS'),
        const SizedBox(height: 12),

        CustomerServiceRequestsWidget(
          serviceRequests: customer?.serviceRequestsList ?? [],
        ),

        const SizedBox(height: 20),

        // ── Quick actions ─────────────────────────────────────────
        const SectionHeader(title: 'QUICK ACTIONS'),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: ActionButton(
                icon: Icons.add_circle_outline,
                label: 'New Request',
                onTap: () async {
                  context.read<ServiceRequestCubit>().openServiceRequestSheet(
                        context,
                        await context.read<AssetsCubit>().allAssetsFuture,
                      );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ActionButton(
                icon: Icons.history,
                label: 'Requests History',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ActionButton(
                icon: Icons.support_agent_outlined,
                label: 'Support',
                onTap: () {},
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── Recent assets ─────────────────────────────────────────
        const SectionHeader(title: 'ASSETS'),
        const SizedBox(height: 12),

        BlocBuilder<AssetsCubit, AssetsState>(
          builder: (context, state) {
            final assets = _resolveAssets(context, customer);

            return Skeletonizer(
              enabled: state is AssetsLoading,
              child: CustomerAssetsWidget(
                assets: state is AssetsLoading
                    ? context.read<AssetsCubit>().fakeAssetsForSkeletonizer
                    : assets,
              ),
            );
          },
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  /// Option 3 logic:
  /// - Before AssetsCubit has ever loaded assets (allAssets == null) ->
  ///   use the customer's own list (original behavior).
  /// - Once assets have been loaded at least once -> use AssetsCubit's
  ///   live list, which stays in sync after any add/edit/delete.
  List<AssetEntity> _resolveAssets(
    BuildContext context,
    CustomersEntity? customer,
  ) {
    final loaded = context.read<AssetsCubit>().allAssets;
    if (loaded != null) return loaded;
    return customer?.assetsList ?? [];
  }

  String _openRequests(CustomersEntity? customer) {
    if (customer == null) return '0';
    return '${customer.serviceRequestsList.where((sr) => sr.status == 1 || sr.status == 2).length}';
  }

  String _completedRequests(CustomersEntity? customer) {
    if (customer == null) return '0';
    return '${customer.serviceRequestsList.where((sr) => sr.status == 3).length}';
  }
}
