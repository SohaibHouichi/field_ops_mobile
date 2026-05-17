import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class ViewMoreButton extends StatelessWidget {
  final int remaining;
  final VoidCallback onTap;
  const ViewMoreButton({super.key, required this.remaining, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: primaryBlue.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryBlue.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+$remaining more assets',
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_rounded,
                color: primaryBlue, size: 14),
          ],
        ),
      ),
    );
  }
}