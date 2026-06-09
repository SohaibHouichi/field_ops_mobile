import 'package:field_ops/features/technician/domain/entities/technician_entity.dart';

class TechnicianModel extends TechnicianEntity {
  const TechnicianModel({
    required super.id,
    required super.fullName,
    required super.gender,
    super.birthDate,
    required super.email,
    super.phoneNumber,
    super.jobTitle,
    required super.isAvailable,
    super.teamId,
    super.teamName,
    super.addressId,
    super.addressLabel,
    super.serviceRequestsList,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json['id'],
      fullName: json['fullName'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      jobTitle: json['jobTitle'],
      isAvailable: json['isAvailable'],
      teamId: json['teamId'],
      teamName: json['teamName'],
      addressId: json['addressId'],
      addressLabel: json['addressLabel'],
      serviceRequestsList: json['serviceRequestsList'],
    );
  }
}