import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: chipBg,
              shape: BoxShape.circle,
              border: Border.all(color: chipBorder),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              color: secondaryText,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No items found',
            style: TextStyle(
              color: primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Items will appear here once available',
            style: TextStyle(color: secondaryText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}