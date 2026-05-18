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
    required this.brand,
    required this.model,
    required this.note,
    required this.serialNumber,
  });
}
