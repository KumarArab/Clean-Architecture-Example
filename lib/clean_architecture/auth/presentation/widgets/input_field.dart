import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.controller,
  });

  final String label;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return "$label cannot be null";
        return null;
      },
    );
  }
}
