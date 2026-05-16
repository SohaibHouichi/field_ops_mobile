import 'package:field_ops/core/enums/gender_enum.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customers_response.g.dart';

@JsonSerializable()
class CustomersResponse {
  final int id;
  final String fullName;
  final int gender;
  final DateTime? birthDate;        // nullable
  final String email;
  final String phoneNumber;
  final String? note;
  final String? addressId;
  final String? addressLabel;
  final String? fullAddressLine;    // added

  // Ignored: addressList, assetsList, serviceRequestsList
  // (handle separately when needed)

  const CustomersResponse({
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

  factory CustomersResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomersResponseToJson(this);

  CustomersEntity toEntity() => CustomersEntity(
        id: id,
        fullName: fullName,
        gender: gender,
        email: email,
        phoneNumber: phoneNumber,
        birthDate: birthDate,
        note: note,
        addressId: addressId,
        addressLabel: addressLabel,
        fullAddressLine: fullAddressLine,
      );
}