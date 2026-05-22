import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_request_response_model.g.dart';

@JsonSerializable()
class ServiceRequestResponseModel {
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
  final int customerId;
  final String? customerName;
  final int? technicianId;
  final String? technicianName;
  final int? teamId;
  final String? teamName;
  final String? addressId;
  final String? addressLabel;
  final int? assetId;
  final String? assetName;
  final List<String> attachments;

  const ServiceRequestResponseModel({
    required this.id,
    required this.reference,
    required this.type,
    required this.title,
    required this.status,
    required this.customerPriority,
    required this.employeePriority,
    required this.customerId,
    required this.attachments,
    this.description,
    this.scheduledDate,
    this.dueDate,
    this.cost,
    this.startedAt,
    this.completedAt,
    this.satisfactionRate,
    this.customerName,
    this.technicianId,
    this.technicianName,
    this.teamId,
    this.teamName,
    this.addressId,
    this.addressLabel,
    this.assetId,
    this.assetName,
  });

  factory ServiceRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceRequestResponseModelToJson(this);
  ServiceRequestEntity toEntity() => ServiceRequestEntity(
      id: id,
      reference: reference,
      type: type,
      title: title,
      status: status,
      customerPriority: customerPriority,
      employeePriority: employeePriority,
      customerId: customerId,
      attachments: attachments,
      description: description,
      scheduledDate: scheduledDate,
      dueDate: dueDate,
      cost: cost,
      startedAt: startedAt,
      completedAt: completedAt,
      satisfactionRate: satisfactionRate,
      customerName: customerName,
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
