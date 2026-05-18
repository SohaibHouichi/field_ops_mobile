import 'package:field_ops/features/assets/data/models/assets_response_model.dart';
import 'package:field_ops/features/customer/data/models/embedded/service_request_embedded_response.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customers_response.g.dart';

@JsonSerializable()
class CustomersResponse {
  final int id;
  final String fullName;
  final int gender;
  final DateTime? birthDate;
  final String email;
  final String phoneNumber;
  final String? note;
  final String? addressId;
  final String? addressLabel;
  final String? fullAddressLine;
  final List<AssetResponse>? assetsList;
  final List<ServiceRequestEmbeddedResponse>? serviceRequestsList;

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
    this.assetsList,
    this.serviceRequestsList,
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
        assetsList: assetsList?.map((e) => e.toEntity()).toList() ?? [],
        serviceRequestsList:
            serviceRequestsList?.map((e) => e.toEntity()).toList() ?? [],
      );
}