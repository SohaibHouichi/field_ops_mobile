import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/features/customer/presentation/widgets/dashboard_widgets/asset_row_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/dashboard_widgets/status_chip_widget.dart';
import 'package:field_ops/features/technician/presentation/screens/technician_dashboard_screen.dart';
import 'package:flutter/material.dart';
class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        // ── Status chip row ───────────────────────────────────────
        Row(
          children: [
            StatusChip(label: 'ACTIVE PLAN', value: 'ENTERPRISE'),
            const SizedBox(width: 8),
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
                value: '4',
                accent: primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                icon: Icons.check_circle_outline,
                label: 'Completed\nThis Month',
                value: '11',
                accent: const Color(0xFF4ADE80),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                icon: Icons.inventory_2_outlined,
                label: 'My\nAssets',
                value: '7',
                accent: const Color(0xFFFBBF24),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── Active requests section ───────────────────────────────
        SectionHeader(title: 'ACTIVE REQUESTS'),
        const SizedBox(height: 12),

        // RequestCard(
        //   id: 'REQ-0041',
        //   title: 'HVAC Unit Maintenance',
        //   status: 'In Progress',
        //   statusColor: primaryBlue,
        //   priority: 'HIGH',
        //   date: 'May 14, 2026',
        //   icon: Icons.air,
        // ),
        // const SizedBox(height: 10),
        // RequestCard(
        //   id: 'REQ-0039',
        //   title: 'Electrical Panel Inspection',
        //   status: 'Pending',
        //   statusColor: const Color(0xFFFBBF24),
        //   priority: 'MEDIUM',
        //   date: 'May 12, 2026',
        //   icon: Icons.electrical_services_outlined,
        // ),
        // const SizedBox(height: 10),
        // RequestCard(
        //   id: 'REQ-0037',
        //   title: 'Compressor Replacement',
        //   status: 'Scheduled',
        //   statusColor: const Color(0xFF4ADE80),
        //   priority: 'LOW',
        //   date: 'May 10, 2026',
        //   icon: Icons.settings_outlined,
        // ),

        const SizedBox(height: 20),

        // ── Quick actions ─────────────────────────────────────────
        SectionHeader(title: 'QUICK ACTIONS'),
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
        SectionHeader(title: 'RECENT ASSETS'),
        const SizedBox(height: 12),

        AssetRow(
          name: 'Cooling Tower Unit A',
          location: 'Building 3 — Floor 2',
          status: 'Operational',
          icon: Icons.ac_unit_outlined,
        ),
        const Divider(color: Color(0xFF2A2D3A), height: 1),
        AssetRow(
          name: 'Generator — Main',
          location: 'Basement Level',
          status: 'Maintenance Due',
          icon: Icons.bolt_outlined,
        ),
        const Divider(color: Color(0xFF2A2D3A), height: 1),
        AssetRow(
          name: 'Fire Suppression System',
          location: 'All Floors',
          status: 'Operational',
          icon: Icons.local_fire_department_outlined,
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
