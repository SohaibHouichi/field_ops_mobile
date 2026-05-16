import 'package:json_annotation/json_annotation.dart';
part 'assets_request_model.g.dart';

@JsonSerializable()
class AssetRequest {
  final String name;
  final String? brand;
  final int customerId;
  final String? model;
  final String? note;
  final String? serialNumber;

  const AssetRequest({
    required this.name,
    required this.customerId,
    this.brand,
    this.model,
    this.note,
    this.serialNumber,
  });
  factory AssetRequest.fromJson(Map<String, dynamic> json) =>
      _$AssetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AssetRequestToJson(this);
  
}