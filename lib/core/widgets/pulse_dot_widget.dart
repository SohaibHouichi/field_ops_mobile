import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class PulseDot extends StatelessWidget {
  const PulseDot({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: primaryBlue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: primaryBlue.withOpacity(0.35), blurRadius: 6),
        ],
      ),
    );
  }
}