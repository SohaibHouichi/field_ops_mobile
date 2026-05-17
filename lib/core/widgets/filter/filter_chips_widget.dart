import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class FilterChips<T> extends StatelessWidget {
  final T? selected;
  final ValueChanged<T?> onSelected;
  final List<T?> options;
  final Color Function(T?) getColor;
  final Color Function(T?) getBgColor;
  final String Function(T?) getLabel;

  const FilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.options,
    required this.getColor,
    required this.getBgColor,
    required this.getLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final option   = options[i];
          final isActive = selected == option;
          final color    = getColor(option);
          final bg       = getBgColor(option);
          final label    = getLabel(option);

          return GestureDetector(
            onTap: () => onSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? bg : chipBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? color.withOpacity(0.5) : chipBorder,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? color : secondaryText,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}