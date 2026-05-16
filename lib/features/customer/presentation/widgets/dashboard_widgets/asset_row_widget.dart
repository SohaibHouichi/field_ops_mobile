import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AssetRow extends StatelessWidget {
  final String name;
  final String location;
  final String status;
  final IconData icon;
  const AssetRow({
    required this.name,
    required this.location,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isOk = status == 'Operational';
    final statusColor =
        isOk ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: chipBorder),
            ),
            child: Icon(icon, color: secondaryText, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}