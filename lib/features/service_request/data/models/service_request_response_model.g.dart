// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceRequestResponseModel _$ServiceRequestResponseModelFromJson(
  Map<String, dynamic> json,
) => ServiceRequestResponseModel(
  id: (json['id'] as num).toInt(),
  reference: json['reference'] as String,
  type: (json['type'] as num).toInt(),
  title: json['title'] as String,
  status: (json['status'] as num).toInt(),
  customerPriority: (json['customerPriority'] as num).toInt(),
  employeePriority: (json['employeePriority'] as num).toInt(),
  customerId: (json['customerId'] as num).toInt(),
  attachments: (json['attachments'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  description: json['description'] as String?,
  scheduledDate: json['scheduledDate'] == null
      ? null
      : DateTime.parse(json['scheduledDate'] as String),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  cost: (json['cost'] as num?)?.toDouble(),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  satisfactionRate: (json['satisfactionRate'] as num?)?.toInt(),
  customerName: json['customerName'] as String?,
  technicianId: (json['technicianId'] as num?)?.toInt(),
  technicianName: json['technicianName'] as String?,
  teamId: (json['teamId'] as num?)?.toInt(),
  teamName: json['teamName'] as String?,
  addressId: (json['addressId'] as num?)?.toInt(),
  addressLabel: json['addressLabel'] as String?,
  assetId: (json['assetId'] as num?)?.toInt(),
  assetName: json['assetName'] as String?,
);

Map<String, dynamic> _$ServiceRequestResponseModelToJson(
  ServiceRequestResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'reference': instance.reference,
  'type': instance.type,
  'title': instance.title,
  'description': instance.description,
  'customerPriority': instance.customerPriority,
  'employeePriority': instance.employeePriority,
  'scheduledDate': instance.scheduledDate?.toIso8601String(),
  'dueDate': instance.dueDate?.toIso8601String(),
  'cost': instance.cost,
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'satisfactionRate': instance.satisfactionRate,
  'status': instance.status,
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'technicianId': instance.technicianId,
  'technicianName': instance.technicianName,
  'teamId': instance.teamId,
  'teamName': instance.teamName,
  'addressId': instance.addressId,
  'addressLabel': instance.addressLabel,
  'assetId': instance.assetId,
  'assetName': instance.assetName,
  'attachments': instance.attachments,
};
