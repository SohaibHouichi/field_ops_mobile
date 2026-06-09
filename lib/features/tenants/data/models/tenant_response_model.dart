import 'package:field_ops/features/tenants/domain/entities/tenant_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tenant_response_model.g.dart';

@JsonSerializable()
class TenantResponseModel {
  final String id;
  final String name;
  final String identifier;
  final bool isActive;
  final String? legalName;
  final String? taxNumber;
  final String? registrationNumber;
  final String email;
  final String phoneNumber;
  final String? website;
  final int plan;
  final DateTime subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final bool isTrial;
  final DateTime createdAt;

  const TenantResponseModel({
    required this.id,
    required this.name,
    required this.identifier,
    required this.isActive,
    this.legalName,
    this.taxNumber,
    this.registrationNumber,
    required this.email,
    required this.phoneNumber,
    this.website,
    required this.plan,
    required this.subscriptionStartDate,
    this.subscriptionEndDate,
    required this.isTrial,
    required this.createdAt,
  });

  /// Connect to generated _$TenantResponseModelFromJson
  factory TenantResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TenantResponseModelFromJson(json);

  /// Connect to generated _$TenantResponseModelToJson
  Map<String, dynamic> toJson() => _$TenantResponseModelToJson(this);
  TenantEntity toEntity() => TenantEntity(
    id: id,
    name: name,
    identifier: identifier,
    isActive: isActive,
    legalName: legalName,
    taxNumber: taxNumber,
    registrationNumber: registrationNumber,
    email: email,
    phoneNumber: phoneNumber,
    website: website,
    plan: plan,
    subscriptionStartDate: subscriptionStartDate,
    subscriptionEndDate: subscriptionEndDate,
    isTrial: isTrial,
    createdAt: createdAt,
  );
}
