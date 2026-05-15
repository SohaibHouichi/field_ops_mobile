import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
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
            _StatusChip(label: 'ACTIVE PLAN', value: 'ENTERPRISE'),
            const SizedBox(width: 8),
            _StatusChip(label: 'SLA', value: '99.8%'),
          ],
        ),

        const SizedBox(height: 20),

        // ── Summary cards ─────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.build_circle_outlined,
                label: 'Open\nRequests',
                value: '4',
                accent: primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.check_circle_outline,
                label: 'Completed\nThis Month',
                value: '11',
                accent: const Color(0xFF4ADE80),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
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
        _SectionHeader(title: 'ACTIVE REQUESTS'),
        const SizedBox(height: 12),

        _RequestCard(
          id: 'REQ-0041',
          title: 'HVAC Unit Maintenance',
          status: 'In Progress',
          statusColor: primaryBlue,
          priority: 'HIGH',
          date: 'May 14, 2026',
          icon: Icons.air,
        ),
        const SizedBox(height: 10),
        _RequestCard(
          id: 'REQ-0039',
          title: 'Electrical Panel Inspection',
          status: 'Pending',
          statusColor: const Color(0xFFFBBF24),
          priority: 'MEDIUM',
          date: 'May 12, 2026',
          icon: Icons.electrical_services_outlined,
        ),
        const SizedBox(height: 10),
        _RequestCard(
          id: 'REQ-0037',
          title: 'Compressor Replacement',
          status: 'Scheduled',
          statusColor: const Color(0xFF4ADE80),
          priority: 'LOW',
          date: 'May 10, 2026',
          icon: Icons.settings_outlined,
        ),

        const SizedBox(height: 20),

        // ── Quick actions ─────────────────────────────────────────
        _SectionHeader(title: 'QUICK ACTIONS'),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.add_circle_outline,
                label: 'New Request',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                icon: Icons.history,
                label: 'History',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                icon: Icons.support_agent_outlined,
                label: 'Support',
                onTap: () {},
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── Recent assets ─────────────────────────────────────────
        _SectionHeader(title: 'RECENT ASSETS'),
        const SizedBox(height: 12),

        _AssetRow(
          name: 'Cooling Tower Unit A',
          location: 'Building 3 — Floor 2',
          status: 'Operational',
          icon: Icons.ac_unit_outlined,
        ),
        const Divider(color: Color(0xFF2A2D3A), height: 1),
        _AssetRow(
          name: 'Generator — Main',
          location: 'Basement Level',
          status: 'Maintenance Due',
          icon: Icons.bolt_outlined,
        ),
        const Divider(color: Color(0xFF2A2D3A), height: 1),
        _AssetRow(
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

// ── Widgets ────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PulseDot(),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: primaryBlue,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatusChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: secondaryText,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String id;
  final String title;
  final String status;
  final Color statusColor;
  final String priority;
  final String date;
  final IconData icon;

  const _RequestCard({
    required this.id,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.priority,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: inputBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: statusColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      id,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Icon(Icons.chevron_right, color: secondaryText, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: chipBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryBlue, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  final String name;
  final String location;
  final String status;
  final IconData icon;
  const _AssetRow({
    required this.name,
    required this.location,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isOk = status == 'Operational';
    final statusColor =
        isOk ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: chipBorder),
            ),
            child: Icon(icon, color: secondaryText, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}