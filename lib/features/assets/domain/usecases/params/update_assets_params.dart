class UpdateAssetsParams {
  final int customerId;
  final String name;
  final String? brand;
  final String? model;
  final String? note;
  final String? serialNumber;

  const UpdateAssetsParams({
    required this.customerId,
    required this.name,
    this.brand,
    this.model,
    this.note,
    this.serialNumber,
  });
}
