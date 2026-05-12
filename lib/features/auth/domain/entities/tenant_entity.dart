class TenantEntity {
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

  const TenantEntity({
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
}
