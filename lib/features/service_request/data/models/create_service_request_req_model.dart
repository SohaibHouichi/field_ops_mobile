import 'dart:io';

class CreateServiceRequestReqModel {
  final int addressId;
  final int assetId;
  final List<File>? attachments; // array of IFormFile
  final String? description;
  final int priority;            // CustomerPriority enum
  final String title;
  final int type;                // ServiceRequestType enum

  CreateServiceRequestReqModel({
    required this.addressId,
    required this.assetId,
    this.attachments,
    this.description,
    required this.priority,
    required this.title,
    required this.type,
  });
}