class ServiceRequestEmbeddedEntity {
  final int id;
  final String reference;
  final int type;
  final String title;
  final String? description;
  final int customerPriority;
  final int employeePriority;
  final DateTime? scheduledDate;
  final DateTime? dueDate;
  final double? cost;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? satisfactionRate;
  final int status;
  final int? technicianId;
  final String? technicianName;
  final int? teamId;
  final String? teamName;
  final String? addressId;
  final String? addressLabel;
  final int? assetId;
  final String? assetName;

  const ServiceRequestEmbeddedEntity({
    required this.id,
    required this.reference,
    required this.type,
    required this.title,
    required this.status,
    required this.customerPriority,
    required this.employeePriority,
    this.description,
    this.scheduledDate,
    this.dueDate,
    this.cost,
    this.startedAt,
    this.completedAt,
    this.satisfactionRate,
    this.technicianId,
    this.technicianName,
    this.teamId,
    this.teamName,
    this.addressId,
    this.addressLabel,
    this.assetId,
    this.assetName,
  });
}
