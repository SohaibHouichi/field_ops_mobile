import 'package:field_ops/core/enums/gender_enum.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customers_response.g.dart';

@JsonSerializable()
class CustomersResponse {
  final int id;
  final String fullName;
  final Gender gender;
  final DateTime birthDate;
  final String email;
  final String phoneNumber;
  final String? note;
  final String? addressId;
  final String? addressLabel;

  CustomersResponse({
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
   factory CustomersResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomersResponseToJson(this);

  CustomersEntity? toEntity() {
    return CustomersEntity(
      id: id,
      fullName: fullName,
      gender: gender,
      birthDate: birthDate,
      email: email,
      phoneNumber: phoneNumber,
      note: note,
      addressId: addressId,
      addressLabel: addressLabel,
    );
  }
}