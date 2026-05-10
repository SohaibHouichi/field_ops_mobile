import 'package:flutter/material.dart';

class GeneraleTitle extends StatelessWidget {
  final String text ;
  final double? size ;
  final TextAlign? align ;
  final double? padding ;
  const GeneraleTitle({super.key , required this.text , this.size , this.align , this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 0),
      child: Text(
        text,
        style: TextStyle(
          letterSpacing: 1.0 ,
          color: Colors.black,
          fontFamily: '',
          fontSize: size ?? 28,
          fontWeight: .bold
        ),
        textAlign: align ?? .center,
      ),
    );
  }
}