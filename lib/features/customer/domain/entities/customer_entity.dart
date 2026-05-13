import 'package:field_ops/core/enums/gender_enum.dart';

class CustomersEntity {
  final int id;
  final String fullName;
  final Gender gender;
  final DateTime birthDate;
  final String email;
  final String phoneNumber;
  final String? note;
  final String? addressId;
  final String? addressLabel;

  CustomersEntity({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    required this.note,
    required this.addressId,
    required this.addressLabel,
  });
}
