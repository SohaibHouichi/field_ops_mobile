import 'package:field_ops/features/customer/domain/entities/embedded/assets_embedded_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assets_embedded_response.g.dart';

@JsonSerializable()
class AssetEmbeddedResponse {
  final int id;
  final String name;
  final String? serialNumber;
  final String? brand;
  final String? model;
  final String? note;

  const AssetEmbeddedResponse({
    required this.id,
    required this.name,
    this.serialNumber,
    this.brand,
    this.model,
    this.note,
  });

  factory AssetEmbeddedResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetEmbeddedResponseFromJson(json);

  AssetEmbeddedEntity toEntity() => AssetEmbeddedEntity(
        id: id,
        name: name,
        serialNumber: serialNumber,
        brand: brand,
        model: model,
        note: note,
      );
}