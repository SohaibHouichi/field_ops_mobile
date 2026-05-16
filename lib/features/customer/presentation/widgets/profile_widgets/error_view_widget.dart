import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0x22FF4D4D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0x55FF4D4D)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}