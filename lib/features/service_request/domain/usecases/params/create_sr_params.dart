import 'package:dio/dio.dart';

class CreateSrParams {
  final int addressId;
  final int assetId;
  final List<MultipartFile>? attachments;
  final String? description;
  final int priority;
  final String title;
  final int? type; // ← nullable: null when type is "other", not sent to API

  CreateSrParams({
    required this.addressId,
    required this.assetId,
    this.attachments,
    this.description,
    required this.priority,
    required this.title,
    this.type, // ← optional
  });
}