import 'package:field_ops/core/enums/gender_enum.dart';

class CustomersEntity {
  final int id;
  final String fullName;
  final int gender;
  final DateTime? birthDate;      // nullable — JSON can be null
  final String email;
  final String phoneNumber;
  final String? note;
  final String? addressId;
  final String? addressLabel;
  final String? fullAddressLine;  // added from JSON

  const CustomersEntity({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    this.birthDate,
    this.note,
    this.addressId,
    this.addressLabel,
    this.fullAddressLine,
  });
}