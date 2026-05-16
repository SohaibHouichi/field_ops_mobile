// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetResponse _$AssetResponseFromJson(Map<String, dynamic> json) =>
    AssetResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      serialNumber: json['serialNumber'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$AssetResponseToJson(AssetResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'serialNumber': instance.serialNumber,
      'brand': instance.brand,
      'model': instance.model,
      'note': instance.note,
    };
