import 'dart:async';

import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:flutter/material.dart';

class SwappingChip extends StatefulWidget {
  final String tenantName;
  const SwappingChip({required this.tenantName , super.key});

  @override
  State<SwappingChip> createState() => _SwappingChipState();
}

class _SwappingChipState extends State<SwappingChip> {
  bool _showTenant = true;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _showTenant = !_showTenant);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = _showTenant ? widget.tenantName.toUpperCase() : 'FIELDOPS';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PulseDot(),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: Text(
            label,
            key: ValueKey(label),
            style: const TextStyle(
              color: primaryBlue,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }
}