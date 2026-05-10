import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String text ;
  const AppBarTitle({super.key , required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        letterSpacing: 1.5 ,
        color: Colors.black,
        fontFamily: '',
        fontSize: 18,
        fontWeight: .bold
      ),
    );
  }
}