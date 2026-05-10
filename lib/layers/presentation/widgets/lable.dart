// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Lable extends StatelessWidget {
  final String text;
  final Color color;
  final double? size ;
  const Lable({
    super.key,
    required this.text,
    required this.color,
    this.size,}
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: '',
        fontSize: size == 0 ? 14 : size,
        fontWeight: .bold,
      ),
    );
  }
}
