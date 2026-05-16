import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'assets_response_model.g.dart';

@JsonSerializable()
class AssetResponse {
  final int id;
  final String name;
  final String? serialNumber;
  final String? brand;
  final String? model;
  final String? note;

  const AssetResponse({
    required this.id,
    required this.name,
    this.serialNumber,
    this.brand,
    this.model,
    this.note,
  });
  factory AssetResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetResponseFromJson(json);
       Map<String, dynamic> toJson() => _$AssetResponseToJson(this);

  AssetEntity toEntity() => AssetEntity(
    id: id,
    name: name,
    serialNumber: serialNumber,
    brand: brand,
    model: model,
    note: note,
  );
}
