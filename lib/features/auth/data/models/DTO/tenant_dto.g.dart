// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TenantDTO _$TenantDTOFromJson(Map<String, dynamic> json) => TenantDTO(
  id: json['id'] as String,
  name: json['name'] as String,
  identifier: json['identifier'] as String,
  isActive: json['isActive'] as bool,
  legalName: json['legalName'] as String,
  taxNumber: json['taxNumber'] as String,
  registrationNumber: json['registrationNumber'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  website: json['website'] as String,
  plan: (json['plan'] as num).toInt(),
  subscriptionStartDate: DateTime.parse(
    json['subscriptionStartDate'] as String,
  ),
  subscriptionEndDate: DateTime.parse(json['subscriptionEndDate'] as String),
  isTrial: json['isTrial'] as bool,
);

Map<String, dynamic> _$TenantDTOToJson(TenantDTO instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'identifier': instance.identifier,
  'isActive': instance.isActive,
  'legalName': instance.legalName,
  'taxNumber': instance.taxNumber,
  'registrationNumber': instance.registrationNumber,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'website': instance.website,
  'plan': instance.plan,
  'subscriptionStartDate': instance.subscriptionStartDate.toIso8601String(),
  'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
  'isTrial': instance.isTrial,
};
