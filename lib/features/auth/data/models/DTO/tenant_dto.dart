import 'package:field_ops/features/auth/domain/entities/tenant_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tenant_dto.g.dart';

@JsonSerializable()
class TenantDTO {
  final String id;
  final String name;
  final String identifier;
  final bool isActive;
  final String legalName;
  final String taxNumber;
  final String registrationNumber;
  final String email;
  final String phoneNumber;
  final String website;
  final int plan;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;
  final bool isTrial;

  const TenantDTO({
    required this.id,
    required this.name,
    required this.identifier,
    required this.isActive,
    required this.legalName,
    required this.taxNumber,
    required this.registrationNumber,
    required this.email,
    required this.phoneNumber,
    required this.website,
    required this.plan,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.isTrial,
  });

  factory TenantDTO.fromJson(Map<String, dynamic> json) =>
      _$TenantDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TenantDTOToJson(this);

  // ← ADD THIS
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
      );
}