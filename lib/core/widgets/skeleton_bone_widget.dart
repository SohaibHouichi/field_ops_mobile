// lib/core/widgets/skeleton_bone.dart

import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class SkeletonBone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const SkeletonBone({
    super.key,
    required this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: inputBorder,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}