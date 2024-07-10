import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/models/utils/extensions/num_extensions.dart';

class CustomInput extends StatelessWidget {
  final String labelText;
  final int maxLength;
  final String? icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const CustomInput({
    super.key,
    required this.labelText,
    this.maxLength = 50,
    this.icon,
    required this.focusNode,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      maxLength: maxLength,
      autovalidateMode: autovalidateMode,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        counterText: '',
        prefixIcon: icon != null ? Image.asset(icon!) : null,
        border: OutlineInputBorder(
          borderRadius: 10.r,
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: 10.r,
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
