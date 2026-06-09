import 'package:field_ops/core/widgets/empty_lists_ui/empty_lists_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/service_request_embedded_widgets/embedded_sr_sub_widgets/sr_card_sub_widget.dart';
import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerServiceRequestListWidget extends StatelessWidget {
  final List<ServiceRequestEntity> serviceRequests;
  final bool isLoading;

  const CustomerServiceRequestListWidget({
    super.key,
    required this.serviceRequests,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final fakeList = List.generate(
      5,
      (_) => ServiceRequestEntity(
        id: 0,
        reference: 'SR-000000-0000',
        type: 0,
        title: 'Loading service request',
        status: 0,
        customerPriority: 0,
        employeePriority: 0,
        customerId: 0,
        attachments: [],
      ),
    );

    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: ListView.separated(
          itemCount: fakeList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => ServiceRequestCard(sr: fakeList[i]),
        ),
      );
    }

    if (serviceRequests.isEmpty) return const EmptyState();

    return ListView.separated(
      itemCount: serviceRequests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => ServiceRequestCard(sr: serviceRequests[i]),
    );
  }
}
