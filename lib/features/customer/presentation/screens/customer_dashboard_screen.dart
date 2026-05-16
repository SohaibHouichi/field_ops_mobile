import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/dashboard_widgets/asset_row_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/dashboard_widgets/status_chip_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/service_request_embedded_widgets/customer_service_requests_widget.dart';
import 'package:field_ops/features/technician/presentation/screens/technician_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});
  
  @override
  Widget build(BuildContext context) {
      final state = context.read<CustomerCubit>().state;
      if (state is! CustomerSuccess && state is! CustomerLoading) {
      context.read<CustomerCubit>().getCustomerById(id: 25);
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
        Row(
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
              child: SummaryCard(
                icon: Icons.inventory_2_outlined,
                label: 'My\nAssets',
                value: '${customer?.assetsList.length ?? 0}',
                accent: const Color(0xFFFBBF24),
              ),
            ),
          ],
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
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ActionButton(
                icon: Icons.history,
                label: 'History',
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
        const SectionHeader(title: 'RECENT ASSETS'),
        const SizedBox(height: 12),

        if (customer == null || customer.assetsList.isEmpty)
          const Center(
            child: Text(
              'No assets found.',
              style: TextStyle(color: secondaryText, fontSize: 13),
            ),
          )
        else
          ...customer.assetsList.map(
            (asset) => Column(
              children: [
                AssetRow(
                  name: asset.name,
                  location: asset.brand ?? '—',
                  status: asset.model ?? '—',
                  icon: Icons.settings_outlined,
                ),
                const Divider(color: Color(0xFF2A2D3A), height: 1),
              ],
            ),
          ),

        const SizedBox(height: 32),
      ],
    );
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