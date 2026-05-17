// lib/features/customer/presentation/screens/customer_service_requests_screen.dart

import 'package:field_ops/core/config/status_config.dart';
import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/enums/status_enums.dart';
import 'package:field_ops/core/widgets/filter/filter_chips_widget.dart';
import 'package:field_ops/core/widgets/hearder/count_header_widget.dart';
import 'package:field_ops/core/widgets/search_bar/search_bar_widget.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/service_request_embedded_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


// ── Screen (StatefulWidget — owns only local UI state) ────────────────────────

class CustomerServiceRequests extends StatefulWidget {
  const CustomerServiceRequests({super.key});

  @override
  State<CustomerServiceRequests> createState() =>
      _CustomerServiceRequestsState();
}

class _CustomerServiceRequestsState extends State<CustomerServiceRequests> {
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
      final matchesStatus = _filter == null || sr.status == _filter!.value;
      final matchesQuery =
          _query.isEmpty ||
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
        final filtered = _applyFilter(all);
        final isLoading = state is CustomerLoading || state is CustomerInitial;

        return _CustomerServiceRequestsView(
          filtered: filtered,
          isLoading: isLoading,
          filter: _filter,
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
  final TextEditingController searchController;
  final ValueChanged<ServiceRequestStatus?> onFilterChanged;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;

  const _CustomerServiceRequestsView({
    required this.filtered,
    required this.isLoading,
    required this.filter,
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
          SearchBarWidget(
            label: 'Search service requests...',
            controller: searchController,
            onChanged: onQueryChanged,
            onClear: onClearQuery,
          ),

          const SizedBox(height: 12),

          // ── Filter chips ─────────────────────────────────────────
          FilterChips<ServiceRequestStatus>(
            selected: filter,
            onSelected: onFilterChanged,
            options: [null, ...ServiceRequestStatus.values],
            getColor: (o) => o?.color ?? primaryBlue,
            getBgColor: (o) => o?.bgColor ?? primaryBlue.withOpacity(0.12),
            getLabel: (o) => o?.label ?? 'All',
          ),

          const SizedBox(height: 16),

          // ── Count header ─────────────────────────────────────────
          CountHeader(label: 'Service Requests', count: filtered.length),

          const SizedBox(height: 12),

          // ── List / skeleton / empty ───────────────────────────────
          Expanded(
            child: isLoading
                ? const _SkeletonList()
                : filtered.isEmpty
                ? _EmptyState(query: searchController.text)
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _RequestCard(sr: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final ServiceRequestEmbeddedEntity sr;
  const _RequestCard({required this.sr});

  @override
  Widget build(BuildContext context) {
    final status = ServiceRequestStatus.fromInt(sr.status);
    final color = status.color;

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
                            horizontal: 8,
                            vertical: 4,
                          ),
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
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // ── Dates + technician ────────────────────────
                    Row(
                      children: [
                        if (sr.scheduledDate != null) ...[
                          const Icon(
                            Icons.play_arrow_outlined,
                            size: 12,
                            color: secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(sr.scheduledDate!),
                            style: const TextStyle(
                              color: secondaryText,
                              fontSize: 11,
                            ),
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
                          const Icon(
                            Icons.person_outline,
                            size: 12,
                            color: secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            sr.technicianName!,
                            style: const TextStyle(
                              color: secondaryText,
                              fontSize: 11,
                            ),
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

  late final Animation<double> _animation = Tween<double>(
    begin: 0.3,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
            child: const Icon(
              Icons.inbox_outlined,
              color: secondaryText,
              size: 32,
            ),
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
