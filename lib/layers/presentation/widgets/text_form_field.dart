import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/layers/presentation/widgets/lable.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? textLable;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final dynamic Function(dynamic)? onChange;

  const CustomTextFormField({
    super.key,
    required this.hint,
    required this.controller,
    required this.validator,
    this.textLable,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        textLable  == null ? SizedBox.shrink() :
        Lable(text: textLable ?? '', color: Colors.black),
        
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChange,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: secondaryText, fontSize: 14),
            fillColor: inputFill,


            border: OutlineInputBorder(
              borderSide: BorderSide(color: inputBorder),
              borderRadius: BorderRadius.circular(8),
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryBlue, width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),

            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
