import 'package:dio/dio.dart';

class CreateServiceRequestReqModel {
  final int addressId;
  final int assetId;
  final List<MultipartFile>? attachments;
  final String? description;
  final int priority;
  final String title;
  final int? type; // ← nullable: omitted from FormData when null

  CreateServiceRequestReqModel({
    required this.addressId,
    required this.assetId,
    this.attachments,
    this.description,
    required this.priority,
    required this.title,
    this.type,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'AddressId': addressId,
      'AssetId': assetId,
      if (description != null) 'description': description,
      'Priority': priority,
      'Title': title,
      if (type != null) 'Type': type,         // ← only sent when not "other"
      if (attachments != null) 'Attachments': attachments,
    });
  }
}