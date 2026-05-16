class AssetEmbeddedEntity {
  final int id;
  final String name;
  final String? serialNumber;
  final String? brand;
  final String? model;
  final String? note;

  const AssetEmbeddedEntity({
    required this.id,
    required this.name,
    this.serialNumber,
    this.brand,
    this.model,
    this.note,
  });
}