import 'package:field_ops/constants/about_coloring.dart';
import 'package:flutter/material.dart';

class CardText extends StatelessWidget {
  final String text ;
  const CardText({super.key , required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: 2,
      text,
      style: TextStyle(
        letterSpacing: 1.5 ,
        color: secondaryText,
        fontFamily: '',
        fontSize: 18,
        fontWeight: .w400
      ),
    );
  }
}