// lib/features/customer/presentation/screens/customer_service_requests_screen.dart

import 'package:field_ops/core/config/status_config.dart';
import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/service_request_embedded_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ── Filter options ────────────────────────────────────────────────────────────

// null = All
const _filterOptions = <ServiceRequestStatus?>[
  null,
  ServiceRequestStatus.newRequest,
  ServiceRequestStatus.accepted,
  ServiceRequestStatus.rejected,
  ServiceRequestStatus.scheduled,
  ServiceRequestStatus.inProgress,
  ServiceRequestStatus.onHold,
  ServiceRequestStatus.completed,
  ServiceRequestStatus.cancelled,
];

// ── Screen (StatefulWidget — owns only local UI state) ────────────────────────

class CustomerServiceRequests extends StatefulWidget {
  const CustomerServiceRequests({super.key});

  @override
  State<CustomerServiceRequests> createState() =>
      _CustomerServiceRequestsState();
}

class _CustomerServiceRequestsState
    extends State<CustomerServiceRequests> {
  ServiceRequestStatus? _filter;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceRequestEmbeddedEntity> _applyFilter(
    List<ServiceRequestEmbeddedEntity> all,
  ) {
    return all.where((sr) {
      final matchesStatus =
          _filter == null || sr.status == _filter!.value;
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
        final all = state is CustomerSuccess
            ? state.customer.serviceRequestsList
            : <ServiceRequestEmbeddedEntity>[];
        final filtered  = _applyFilter(all);
        final isLoading = state is CustomerLoading || state is CustomerInitial;

        return _CustomerServiceRequestsView(
          filtered: filtered,
          isLoading: isLoading,
          filter: _filter,
          query: _query,
          searchController: _searchController,
          onFilterChanged: (f) => setState(() => _filter = f),
          onQueryChanged: (v) => setState(() => _query = v),
          onClearQuery: () {
            _searchController.clear();
            setState(() => _query = '');
          },
        );
      },
    );
  }
}

// ── Pure StatelessWidget view ─────────────────────────────────────────────────

class _CustomerServiceRequestsView extends StatelessWidget {
  final List<ServiceRequestEmbeddedEntity> filtered;
  final bool isLoading;
  final ServiceRequestStatus? filter;
  final String query;
  final TextEditingController searchController;
  final ValueChanged<ServiceRequestStatus?> onFilterChanged;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;

  const _CustomerServiceRequestsView({
    required this.filtered,
    required this.isLoading,
    required this.filter,
    required this.query,
    required this.searchController,
    required this.onFilterChanged,
    required this.onQueryChanged,
    required this.onClearQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Search bar ───────────────────────────────────────────
          _SearchBar(
            controller: searchController,
            query: query,
            onChanged: onQueryChanged,
            onClear: onClearQuery,
          ),

          const SizedBox(height: 12),

          // ── Filter chips ─────────────────────────────────────────
          _FilterChips(
            selected: filter,
            onSelected: onFilterChanged,
          ),

          const SizedBox(height: 16),

          // ── Count header ─────────────────────────────────────────
          _CountHeader(count: filtered.length),

          const SizedBox(height: 12),

          // ── List / skeleton / empty ───────────────────────────────
          Expanded(
            child: isLoading
                ? const _SkeletonList()
                : filtered.isEmpty
                    ? _EmptyState(query: query)
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (_, i) =>
                            _RequestCard(sr: filtered[i]),
                      ),
          ),
        ],
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: primaryText, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search service requests...',
          hintStyle: const TextStyle(color: secondaryText, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: secondaryText, size: 18),
          suffixIcon: query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: secondaryText, size: 16),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  final ServiceRequestStatus? selected;
  final ValueChanged<ServiceRequestStatus?> onSelected;

  const _FilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final option   = _filterOptions[i];
          final isActive = selected == option;
          final color    = option?.color   ?? primaryBlue;
          final bg       = option?.bgColor ?? primaryBlue.withOpacity(0.12);
          final label    = option?.label   ?? 'All';

          return GestureDetector(
            onTap: () => onSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? bg : chipBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? color.withOpacity(0.5) : chipBorder,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? color : secondaryText,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Count header ──────────────────────────────────────────────────────────────

class _CountHeader extends StatelessWidget {
  final int count;
  const _CountHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: chipBorder),
          ),
          child: Text(
            '$count results',
            style: const TextStyle(
              color: secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Request card ──────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final ServiceRequestEmbeddedEntity sr;
  const _RequestCard({required this.sr});

  @override
  Widget build(BuildContext context) {
    final status = ServiceRequestStatus.fromInt(sr.status);
    final color  = status.color;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: inputBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ── Accent bar ────────────────────────────────────────
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

            // ── Content ───────────────────────────────────────────
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
                          child: Icon(status.icon, color: color, size: 14),
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
                        // ── Status badge ──────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: status.bgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status.label,
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
                          Icon(Icons.flag_outlined, size: 12, color: color),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(sr.dueDate!),
                            style: TextStyle(color: color, fontSize: 11),
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

// ── Skeleton list ─────────────────────────────────────────────────────────────

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const _RequestCardSkeleton(),
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
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  late final Animation<double> _animation =
      Tween<double>(begin: 0.3, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

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
  const _Bone({required this.width, required this.height, this.radius = 6});

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