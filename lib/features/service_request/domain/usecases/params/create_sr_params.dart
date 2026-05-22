import 'package:dio/dio.dart';

class CreateSrParams {
  final int addressId;
  final int assetId;
  final List<MultipartFile>? attachments;
  final String? description;
  final int priority;
  final String title;
  final int type;

  CreateSrParams({
    required this.addressId,
    required this.assetId,
    this.attachments,
    this.description,
    required this.priority,
    required this.title,
    required this.type,
  });
}
