// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetRequest _$AssetRequestFromJson(Map<String, dynamic> json) => AssetRequest(
  name: json['name'] as String,
  customerId: (json['customerId'] as num).toInt(),
  brand: json['brand'] as String?,
  model: json['model'] as String?,
  note: json['note'] as String?,
  serialNumber: json['serialNumber'] as String?,
);

Map<String, dynamic> _$AssetRequestToJson(AssetRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'brand': instance.brand,
      'customerId': instance.customerId,
      'model': instance.model,
      'note': instance.note,
      'serialNumber': instance.serialNumber,
    };
