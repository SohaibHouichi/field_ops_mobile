import 'package:field_ops/features/customer/domain/entities/embedded/service_request_embedded_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_request_embedded_response.g.dart';

@JsonSerializable()
class ServiceRequestEmbeddedResponse {
  final int id;
  final String reference;
  final int type;
  final String title;
  final String? description;
  final int customerPriority;
  final int employeePriority;
  final DateTime? scheduledDate;
  final DateTime? dueDate;
  final double? cost;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? satisfactionRate;
  final int status;
  final int? technicianId;
  final String? technicianName;
  final int? teamId;
  final String? teamName;
  final String? addressId;
  final String? addressLabel;
  final int? assetId;
  final String? assetName;

  const ServiceRequestEmbeddedResponse({
    required this.id,
    required this.reference,
    required this.type,
    required this.title,
    required this.status,
    required this.customerPriority,
    required this.employeePriority,
    this.description,
    this.scheduledDate,
    this.dueDate,
    this.cost,
    this.startedAt,
    this.completedAt,
    this.satisfactionRate,
    this.technicianId,
    this.technicianName,
    this.teamId,
    this.teamName,
    this.addressId,
    this.addressLabel,
    this.assetId,
    this.assetName,
  });

  factory ServiceRequestEmbeddedResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestEmbeddedResponseFromJson(json);

  ServiceRequestEmbeddedEntity toEntity() => ServiceRequestEmbeddedEntity(
        id: id,
        reference: reference,
        type: type,
        title: title,
        status: status,
        customerPriority: customerPriority,
        employeePriority: employeePriority,
        description: description,
        scheduledDate: scheduledDate,
        dueDate: dueDate,
        cost: cost,
        startedAt: startedAt,
        completedAt: completedAt,
        satisfactionRate: satisfactionRate,
        technicianId: technicianId,
        technicianName: technicianName,
        teamId: teamId,
        teamName: teamName,
        addressId: addressId,
        addressLabel: addressLabel,
        assetId: assetId,
        assetName: assetName,
      );
}