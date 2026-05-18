// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomersResponse _$CustomersResponseFromJson(Map<String, dynamic> json) =>
    CustomersResponse(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      gender: (json['gender'] as num).toInt(),
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      note: json['note'] as String?,
      addressId: json['addressId'] as String?,
      addressLabel: json['addressLabel'] as String?,
      fullAddressLine: json['fullAddressLine'] as String?,
      assetsList: (json['assetsList'] as List<dynamic>?)
          ?.map((e) => AssetResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceRequestsList: (json['serviceRequestsList'] as List<dynamic>?)
          ?.map(
            (e) => ServiceRequestEmbeddedResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$CustomersResponseToJson(CustomersResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'gender': instance.gender,
      'birthDate': instance.birthDate?.toIso8601String(),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'note': instance.note,
      'addressId': instance.addressId,
      'addressLabel': instance.addressLabel,
      'fullAddressLine': instance.fullAddressLine,
      'assetsList': instance.assetsList,
      'serviceRequestsList': instance.serviceRequestsList,
    };
