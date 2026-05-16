class AddAssetsParams {
  final String name;
  final String? brand;
  final int customerId;
  final String? model;
  final String? note;
  final String? serialNumber;

  const AddAssetsParams({
    required this.name,
    required this.customerId,
    this.brand,
    this.model,
    this.note,
    this.serialNumber,
  });
}
