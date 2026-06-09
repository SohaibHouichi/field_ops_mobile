class TechnicianEntity {
  final int id;
  final String fullName;
  final int gender;
  final String? birthDate;
  final String email;
  final String? phoneNumber;
  final String? jobTitle;
  final bool isAvailable;
  final int? teamId;
  final String? teamName;
  final int? addressId;
  final String? addressLabel;
  final List<dynamic>? serviceRequestsList;

  const TechnicianEntity({
    required this.id,
    required this.fullName,
    required this.gender,
    this.birthDate,
    required this.email,
    this.phoneNumber,
    this.jobTitle,
    required this.isAvailable,
    this.teamId,
    this.teamName,
    this.addressId,
    this.addressLabel,
    this.serviceRequestsList,
  });
}