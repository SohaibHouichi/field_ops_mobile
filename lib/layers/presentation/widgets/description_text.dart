import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  final String text ;
  final TextAlign? align ;
  const DescriptionText({super.key , 
  required this.text,
  this.align
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        letterSpacing: 0 ,
        color: secondaryText,
        fontFamily: '',
        fontSize: 14,
        fontWeight: .bold
      ),
      textAlign: align ?? .center,
    );
  }
}