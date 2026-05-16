import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

Widget tenantInfoTile({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          size: 18,
          color: primaryBlue,
        ),

        const SizedBox(width: 10),

        Text(
          "$title: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        Expanded(
          child: Text(
            value.isEmpty ? "-" : value,
          ),
        ),
      ],
    ),
  );
}