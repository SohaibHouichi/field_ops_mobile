import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder),
      ),
      child: ValueListenableBuilder(
        valueListenable: controller, // يراقب الـ controller تلقائياً
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: primaryText, fontSize: 13),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: secondaryText, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: secondaryText, size: 18),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: secondaryText, size: 16),
                      onPressed: onClear,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          );
        },
      ),
    );
  }
}