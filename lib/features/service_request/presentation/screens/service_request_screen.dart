import 'package:field_ops/core/config/status_config.dart';
import 'package:field_ops/core/enums/status_enums.dart';
import 'package:field_ops/core/widgets/filter/filter_chips_widget.dart';
import 'package:field_ops/core/widgets/hearder/count_header_widget.dart';
import 'package:field_ops/core/widgets/search_bar/search_bar_widget.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/service_request_embedded_widgets/customer_service_request_list_widget.dart';
import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/presentation/cubit/service_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceRequestScreen extends StatelessWidget {
  const ServiceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServiceRequestCubit>();

    return BlocConsumer<CustomerCubit, CustomerState>(
      // ✅ Fires on state transitions after widget is mounted
      listener: (context, state) {
        if (state is CustomerSuccess) {
          cubit.lastLoadedCustomerId = state.customer.id;
          cubit.setRequests(state.customer.serviceRequestsList);
        }
      },
      builder: (context, customerState) {
        // ✅ Catches already-emitted CustomerSuccess on first build
        // Guard: only runs when requests haven't been loaded yet
        if (customerState is CustomerSuccess && cubit.allRequests == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cubit.lastLoadedCustomerId = customerState.customer.id;
            cubit.setRequests(customerState.customer.serviceRequestsList);
          });
        }

        final isLoading =
            customerState is CustomerLoading ||
            customerState is CustomerInitial;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Search ─────────────────────────────────────────
              SearchBarWidget(
                label: 'Search service requests',
                controller: cubit.searchController,
                onChanged: cubit.search,
                onClear: cubit.clearSearch,
              ),
              const SizedBox(height: 12),

              // ── Status filter ──────────────────────────────────
              BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                builder: (context, state) {
                  return FilterChips<ServiceRequestStatus>(
                    selected: cubit.selectedStatus,
                    options: [
                      null,
                      ...ServiceRequestStatus.values.where(
                        (s) => s != ServiceRequestStatus.unknown,
                      ),
                    ],
                    onSelected: cubit.filterByStatus,
                    getLabel: (s) => s == null ? 'All' : s.label,
                    getColor: (s) =>
                        s == null ? const Color(0xFF6B7280) : s.color,
                    getBgColor: (s) =>
                        s == null ? const Color(0xFFF3F4F6) : s.bgColor,
                  );
                },
              ),

              const SizedBox(height: 24),

              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                  builder: (context, srState) {
                    final requests = srState is ServiceRequestListSuccess
                        ? srState.serviceRequests
                        : <ServiceRequestEntity>[];

                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CountHeader(
                            count: requests.length,
                            label: 'Service Requests',
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: CustomerServiceRequestListWidget(
                              serviceRequests: requests,
                              isLoading: srState is ServiceRequestLoading,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}