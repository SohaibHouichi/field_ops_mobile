import 'package:json_annotation/json_annotation.dart';

part 'customers_request.g.dart';

@JsonSerializable()
class CustomersRequest {
  final String firstName;
  final String lastName;
  final String email;
  final int gender;
  final DateTime? birthDate;
  final String phoneNumber;
  final String addressId;
  final String note;

  CustomersRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.phoneNumber,
    required this.addressId,
    required this.note,
  });
  factory CustomersRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomersRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CustomersRequestToJson(this);
}

