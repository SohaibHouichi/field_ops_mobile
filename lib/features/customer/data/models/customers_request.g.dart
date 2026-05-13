// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomersRequest _$CustomersRequestFromJson(Map<String, dynamic> json) =>
    CustomersRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      gender: (json['gender'] as num).toInt(),
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      phoneNumber: json['phoneNumber'] as String,
      addressId: json['addressId'] as String,
      note: json['note'] as String,
    );

Map<String, dynamic> _$CustomersRequestToJson(CustomersRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'gender': instance.gender,
      'birthDate': instance.birthDate?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'addressId': instance.addressId,
      'note': instance.note,
    };
