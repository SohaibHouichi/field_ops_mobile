import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/customer/domain/entities/embedded/service_request_embedded_entity.dart';

class CustomersEntity {
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
  final List<AssetEntity> assetsList;
  final List<ServiceRequestEmbeddedEntity> serviceRequestsList;

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
    this.assetsList = const [],
    this.serviceRequestsList = const [],
  });
}