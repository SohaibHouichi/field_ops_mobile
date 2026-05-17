import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:flutter/material.dart';

class CountHeader extends StatelessWidget {
  final int count;
  final String label;
  const CountHeader({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const PulseDot(),
        const SizedBox(width: 8),
         Text(
          label,
          style: TextStyle(
            color: primaryBlue,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: chipBorder),
          ),
          child: Text(
            '$count results',
            style: const TextStyle(
              color: secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
