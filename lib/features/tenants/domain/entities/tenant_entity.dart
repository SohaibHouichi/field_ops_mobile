class TenantEntity {
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

  const TenantEntity({
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
}
