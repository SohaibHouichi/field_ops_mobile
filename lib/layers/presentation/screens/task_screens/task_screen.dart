import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ServiceRequestStatus { all, inProgress, urgent, completed, suspended }

extension ServiceRequestStatusExt on ServiceRequestStatus {
  String get label => switch (this) {
        ServiceRequestStatus.all => 'All',
        ServiceRequestStatus.inProgress => 'In Progress',
        ServiceRequestStatus.urgent => 'Urgent',
        ServiceRequestStatus.completed => 'Completed',
        ServiceRequestStatus.suspended => 'Suspended',
      };

  Color get color => switch (this) {
        ServiceRequestStatus.all => primaryBlue,
        ServiceRequestStatus.inProgress => primaryBlue,
        ServiceRequestStatus.urgent => const Color(0xFFFF6B6B),
        ServiceRequestStatus.completed => const Color(0xFF4ADE80),
        ServiceRequestStatus.suspended => const Color(0xFFFBBF24),
      };
}

// Mock data model
class _ServiceRequest {
  final String id;
  final String projectName;
  final String taskName;
  final String startAt;
  final String deadline;
  final ServiceRequestStatus status;
  final IconData icon;

  const _ServiceRequest({
    required this.id,
    required this.projectName,
    required this.taskName,
    required this.startAt,
    required this.deadline,
    required this.status,
    required this.icon,
  });
}

final _mockRequests = [
  _ServiceRequest(
    id: 'REQ-0041',
    projectName: 'M\'sila Plant Ops',
    taskName: 'HVAC Unit Full Inspection',
    startAt: 'May 14, 2026',
    deadline: 'May 18, 2026',
    status: ServiceRequestStatus.inProgress,
    icon: Icons.air,
  ),
  _ServiceRequest(
    id: 'REQ-0039',
    projectName: 'Electrical Safety Q2',
    taskName: 'Electrical Panel Inspection',
    startAt: 'May 12, 2026',
    deadline: 'May 16, 2026',
    status: ServiceRequestStatus.urgent,
    icon: Icons.electrical_services_outlined,
  ),
  _ServiceRequest(
    id: 'REQ-0037',
    projectName: 'M\'sila Plant Ops',
    taskName: 'Compressor Replacement',
    startAt: 'May 10, 2026',
    deadline: 'May 20, 2026',
    status: ServiceRequestStatus.completed,
    icon: Icons.settings_outlined,
  ),
  _ServiceRequest(
    id: 'REQ-0035',
    projectName: 'Water Treatment Unit',
    taskName: 'Pump Station Maintenance',
    startAt: 'May 8, 2026',
    deadline: 'May 22, 2026',
    status: ServiceRequestStatus.suspended,
    icon: Icons.water_outlined,
  ),
];

class ServiceRequest extends StatefulWidget {
  const ServiceRequest({super.key});

  @override
  State<ServiceRequest> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequest> {
  ServiceRequestStatus _selected = ServiceRequestStatus.all;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ServiceRequest> get _filtered => _mockRequests.where((r) {
        final matchesStatus = _selected == ServiceRequestStatus.all ||
            r.status == _selected;
        final matchesQuery = _query.isEmpty ||
            r.taskName.toLowerCase().contains(_query.toLowerCase()) ||
            r.id.toLowerCase().contains(_query.toLowerCase()) ||
            r.projectName.toLowerCase().contains(_query.toLowerCase());
        return matchesStatus && matchesQuery;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Search bar ────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: inputBorder),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: primaryText, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search service requests...',
                hintStyle: TextStyle(color: secondaryText, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: secondaryText, size: 18),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, color: secondaryText, size: 16),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Filter chips ──────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ServiceRequestStatus.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = ServiceRequestStatus.values[index];
                final isSelected = _selected == status;
                return GestureDetector(
                  onTap: () => setState(() => _selected = status),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? status.color.withOpacity(0.15)
                          : chipBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? status.color.withOpacity(0.5)
                            : chipBorder,
                      ),
                    ),
                    child: Text(
                      status.label,
                      style: TextStyle(
                        color: isSelected ? status.color : secondaryText,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Count header ──────────────────────────────────────────
          Row(
            children: [
              PulseDot(),
              const SizedBox(width: 8),
              Text(
                'SERVICE REQUESTS',
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: chipBorder),
                ),
                child: Text(
                  '${_filtered.length} results',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── List ──────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState(query: _query)
                : ListView.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        RequestCard(request: _filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Request card ───────────────────────────────────────────────────────────

class RequestCard extends StatelessWidget {
  final _ServiceRequest request;
  const RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final color = request.status.color;

    return GestureDetector(
      onTap: () => context.go(taskDetailPath),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: inputBorder),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // ── Colored left accent bar ─────────────────────────
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
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
                      // Top row: id + status badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(request.icon, color: color, size: 14),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            request.id,
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: color.withOpacity(0.3)),
                            ),
                            child: Text(
                              request.status.label,
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Project name
                      Text(
                        request.projectName,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Task name
                      Text(
                        request.taskName,
                        style: const TextStyle(
                          color: primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Dates row
                      Row(
                        children: [
                          Icon(Icons.play_arrow_outlined,
                              size: 12, color: secondaryText),
                          const SizedBox(width: 4),
                          Text(
                            request.startAt,
                            style: TextStyle(
                                color: secondaryText, fontSize: 11),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.flag_outlined,
                              size: 12, color: color),
                          const SizedBox(width: 4),
                          Text(
                            request.deadline,
                            style: TextStyle(color: color, fontSize: 11),
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right,
                              color: secondaryText, size: 16),
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

// ── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: chipBg,
              shape: BoxShape.circle,
              border: Border.all(color: chipBorder),
            ),
            child: Icon(Icons.inbox_outlined, color: secondaryText, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            query.isNotEmpty
                ? 'No results for "$query"'
                : 'No service requests',
            style: const TextStyle(
              color: primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            query.isNotEmpty
                ? 'Try a different search term or filter'
                : 'New requests will appear here',
            style: TextStyle(color: secondaryText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}