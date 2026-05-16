import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/service_request_embedded_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum _FilterStatus { all, open, inProgress, completed }

extension _FilterStatusExt on _FilterStatus {
  String get label => switch (this) {
        _FilterStatus.all => 'All',
        _FilterStatus.open => 'Open',
        _FilterStatus.inProgress => 'In Progress',
        _FilterStatus.completed => 'Completed',
      };

  Color get color => switch (this) {
        _FilterStatus.all => primaryBlue,
        _FilterStatus.open => const Color(0xFF4CAF50),
        _FilterStatus.inProgress => const Color(0xFFFF9800),
        _FilterStatus.completed => const Color(0xFF2196F3),
      };
}

class CustomerServiceRequests extends StatefulWidget {
  const CustomerServiceRequests({super.key});

  @override
  State<CustomerServiceRequests> createState() =>
      _CustomerServiceRequestsState();
}

class _CustomerServiceRequestsState extends State<CustomerServiceRequests> {
  _FilterStatus _selected = _FilterStatus.all;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceRequestEmbeddedEntity> _filtered(
      List<ServiceRequestEmbeddedEntity> all) {
    return all.where((sr) {
      final matchesStatus = _selected == _FilterStatus.all ||
          (_selected == _FilterStatus.open && sr.status == 1) ||
          (_selected == _FilterStatus.inProgress && sr.status == 2) ||
          (_selected == _FilterStatus.completed && sr.status == 3);
      final matchesQuery = _query.isEmpty ||
          sr.title.toLowerCase().contains(_query.toLowerCase()) ||
          sr.reference.toLowerCase().contains(_query.toLowerCase());
      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        final serviceRequests = state is CustomerSuccess
            ? state.customer.serviceRequestsList
            : <ServiceRequestEmbeddedEntity>[];
        final filtered = _filtered(serviceRequests);
        final isLoading =
            state is CustomerLoading || state is CustomerInitial;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Search bar ───────────────────────────────────────
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
                    hintStyle:
                        const TextStyle(color: secondaryText, fontSize: 13),
                    prefixIcon: const Icon(Icons.search,
                        color: secondaryText, size: 18),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                color: secondaryText, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Filter chips ─────────────────────────────────────
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _FilterStatus.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final status = _FilterStatus.values[index];
                    final isActive = _selected == status;
                    return GestureDetector(
                      onTap: () => setState(() => _selected = status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? status.color.withOpacity(0.15)
                              : chipBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isActive
                                ? status.color.withOpacity(0.5)
                                : chipBorder,
                          ),
                        ),
                        child: Text(
                          status.label,
                          style: TextStyle(
                            color: isActive ? status.color : secondaryText,
                            fontSize: 11,
                            fontWeight: isActive
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

              // ── Count header ─────────────────────────────────────
              Row(
                children: [
                  const PulseDot(),
                  const SizedBox(width: 8),
                  const Text(
                    'SERVICE REQUESTS',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: chipBorder),
                    ),
                    child: Text(
                      '${filtered.length} results',
                      style: const TextStyle(
                        color: secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── List ─────────────────────────────────────────────
              Expanded(
                child: isLoading
                    ? _buildSkeletonList()
                    : filtered.isEmpty
                        ? _EmptyState(query: _query)
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) =>
                                _RequestCard(sr: filtered[index]),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonList() {
    return ListView.separated(
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const _RequestCardSkeleton(),
    );
  }
}

// ── Request card ──────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final ServiceRequestEmbeddedEntity sr;
  const _RequestCard({required this.sr});

  Color get _statusColor => switch (sr.status) {
        1 => const Color(0xFF4CAF50),
        2 => const Color(0xFFFF9800),
        3 => const Color(0xFF2196F3),
        _ => secondaryText,
      };

  String get _statusLabel => switch (sr.status) {
        1 => 'Open',
        2 => 'In Progress',
        3 => 'Completed',
        _ => 'Unknown',
      };

  IconData get _statusIcon => switch (sr.status) {
        1 => Icons.fiber_new_outlined,
        2 => Icons.pending_outlined,
        3 => Icons.check_circle_outline,
        _ => Icons.help_outline,
      };

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: inputBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ── Colored left accent bar ──────────────────────────
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

            // ── Content ──────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top row ───────────────────────────────────
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              Icon(_statusIcon, color: color, size: 14),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          sr.reference,
                          style: const TextStyle(
                            color: secondaryText,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: color.withOpacity(0.3)),
                          ),
                          child: Text(
                            _statusLabel,
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

                    // ── Title ─────────────────────────────────────
                    Text(
                      sr.title,
                      style: const TextStyle(
                        color: primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    if (sr.description != null &&
                        sr.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        sr.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: secondaryText, fontSize: 12),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // ── Dates + technician ────────────────────────
                    Row(
                      children: [
                        if (sr.scheduledDate != null) ...[
                          const Icon(Icons.play_arrow_outlined,
                              size: 12, color: secondaryText),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy')
                                .format(sr.scheduledDate!),
                            style: const TextStyle(
                                color: secondaryText, fontSize: 11),
                          ),
                        ],
                        if (sr.dueDate != null) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.flag_outlined,
                              size: 12, color: color),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy')
                                .format(sr.dueDate!),
                            style: TextStyle(
                                color: color, fontSize: 11),
                          ),
                        ],
                        const Spacer(),
                        if (sr.technicianName != null) ...[
                          const Icon(Icons.person_outline,
                              size: 12, color: secondaryText),
                          const SizedBox(width: 4),
                          Text(
                            sr.technicianName!,
                            style: const TextStyle(
                                color: secondaryText, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton card ─────────────────────────────────────────────────────────────

class _RequestCardSkeleton extends StatefulWidget {
  const _RequestCardSkeleton();

  @override
  State<_RequestCardSkeleton> createState() => _RequestCardSkeletonState();
}

class _RequestCardSkeletonState extends State<_RequestCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Opacity(
        opacity: _animation.value,
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: inputBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: inputBorder,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Bone(width: 30, height: 30, radius: 8),
                            const SizedBox(width: 10),
                            _Bone(width: 100, height: 10),
                            const Spacer(),
                            _Bone(width: 70, height: 22, radius: 6),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _Bone(width: 200, height: 14),
                        const SizedBox(height: 6),
                        _Bone(width: 140, height: 11),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _Bone(width: 80, height: 11),
                            const SizedBox(width: 12),
                            _Bone(width: 80, height: 11),
                            const Spacer(),
                            _Bone(width: 70, height: 11),
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
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _Bone({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: inputBorder,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

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
            child: const Icon(Icons.inbox_outlined,
                color: secondaryText, size: 32),
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
            style: const TextStyle(color: secondaryText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}