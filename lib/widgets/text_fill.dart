import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFill extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatter;

  const TextFill({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.textInputType,
    this.textInputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: null,
      inputFormatters: textInputFormatter,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.grey[50],
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}
