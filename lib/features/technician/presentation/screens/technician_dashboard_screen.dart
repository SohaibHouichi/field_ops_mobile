import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:field_ops/layers/business_logic/cubit/Home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TechnicianDashboard extends StatelessWidget {
  const TechnicianDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        // ── Availability toggle ───────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: cubit.isAvailable
                  ? const Color(0xFF4ADE80).withOpacity(0.4)
                  : inputBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cubit.isAvailable
                      ? const Color(0xFF4ADE80).withOpacity(0.1)
                      : chipBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  cubit.isAvailable
                      ? Icons.wifi_tethering
                      : Icons.wifi_tethering_off_outlined,
                  color: cubit.isAvailable
                      ? const Color(0xFF4ADE80)
                      : secondaryText,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVAILABILITY STATUS',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cubit.isAvailable ? 'Available for Tasks' : 'Unavailable',
                      style: TextStyle(
                        color: cubit.isAvailable
                            ? const Color(0xFF4ADE80)
                            : primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return Switch(
                    value: cubit.isAvailable,
                    onChanged: (v) => context.read<HomeCubit>().toggle(v),
                    activeColor: const Color(0xFF4ADE80),
                    inactiveThumbColor: secondaryText,
                    inactiveTrackColor: chipBg,
                    trackOutlineColor:
                        WidgetStateProperty.all(Colors.transparent),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Summary cards ─────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.calendar_today_outlined,
                label: "Today's\nTasks",
                value: cubit.taskCountPerDay.toString(),
                accent: primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.account_tree_outlined,
                label: 'Active\nProjects',
                value: cubit.currentProjects.toString(),
                accent: const Color(0xFFFBBF24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.check_circle_outline,
                label: 'Completed\nToday',
                value: '3',
                accent: const Color(0xFF4ADE80),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── Today's schedule ──────────────────────────────────────
        _SectionHeader(title: "TODAY'S SCHEDULE"),
        const SizedBox(height: 12),

        _TaskCard(
          time: '08:30',
          title: 'HVAC Inspection — Block A',
          location: 'Building 3, Floor 2',
          status: 'In Progress',
          statusColor: primaryBlue,
          priority: 'HIGH',
          icon: Icons.air,
        ),
        const SizedBox(height: 10),
        _TaskCard(
          time: '11:00',
          title: 'Pump Station Maintenance',
          location: 'Basement Level',
          status: 'Pending',
          statusColor: const Color(0xFFFBBF24),
          priority: 'MEDIUM',
          icon: Icons.water_outlined,
        ),
        const SizedBox(height: 10),
        _TaskCard(
          time: '14:00',
          title: 'Generator Monthly Check',
          location: 'Utility Room — East Wing',
          status: 'Scheduled',
          statusColor: secondaryText,
          priority: 'LOW',
          icon: Icons.bolt_outlined,
        ),

        const SizedBox(height: 20),

        // ── Quick actions ─────────────────────────────────────────
        _SectionHeader(title: 'QUICK ACTIONS'),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.add_task,
                label: 'Log Work',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                icon: Icons.report_problem_outlined,
                label: 'Report Issue',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                icon: Icons.qr_code_scanner,
                label: 'Scan Asset',
                onTap: () {},
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── Recent activity ───────────────────────────────────────
        _SectionHeader(title: 'RECENT ACTIVITY'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: inputBorder),
          ),
          child: Column(
            children: [
              _ActivityRow(
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFF4ADE80),
                title: 'Completed — Electrical Panel Check',
                time: 'Yesterday, 16:45',
                isLast: false,
              ),
              _ActivityRow(
                icon: Icons.build_outlined,
                iconColor: primaryBlue,
                title: 'Started — Cooling Tower Inspection',
                time: 'Yesterday, 09:00',
                isLast: false,
              ),
              _ActivityRow(
                icon: Icons.assignment_turned_in_outlined,
                iconColor: const Color(0xFFFBBF24),
                title: 'Submitted Report — REQ-0038',
                time: '2 days ago',
                isLast: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────

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

class _TaskCard extends StatelessWidget {
  final String time;
  final String title;
  final String location;
  final String status;
  final Color statusColor;
  final String priority;
  final IconData icon;

  const _TaskCard({
    required this.time,
    required this.title,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.priority,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: inputBorder),
      ),
      child: Row(
        children: [
          // Time column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Text(
                  time.split(':')[0],
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                Text(
                  ':${time.split(':')[1]}',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: inputBorder,
          ),
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: statusColor, size: 16),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 11, color: secondaryText),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(color: secondaryText, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status badge
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
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
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

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final bool isLast;

  const _ActivityRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: inputBorder,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}