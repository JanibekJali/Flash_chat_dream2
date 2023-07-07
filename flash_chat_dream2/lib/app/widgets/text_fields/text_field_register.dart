import 'package:flutter/material.dart';

class TextFieldRegisterWidget extends StatelessWidget {
  TextFieldRegisterWidget({
    Key? key,
    this.onChanged,
    this.hintText,
    this.keyboardType,
    this.controller,
    this.validator,
    this.suffixIcon,
    this.obscureText = false,
  }) : super(key: key);
  final Function(String)? onChanged;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          errorStyle: const TextStyle(color: Colors.red),
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}
