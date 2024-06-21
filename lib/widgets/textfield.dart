import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.isEmail = false,
  });
  final String hint;
  final String label;
  final bool isPassword;
  final bool isEmail;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.white),
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1))),
      // validator: (controller) {
      //   if (isPassword) {
      //     // RegExp regex = RegExp(
      //     //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
      //     if (controller!.isEmpty) {
      //       return "Please enter password";
      //     }
      //     if (controller.length < 8) {
      //       return "Password must be at least 8 characters";
      //     }
      //     // if (!regex.hasMatch(value)) {
      //     //   return "Enter valid password";
      //     // }
      //   } else if (isEmail) {
      //     RegExp regex = RegExp(
      //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

      //     if (controller!.isEmpty) {
      //       return "Please enter email";
      //     }
      //     if (!regex.hasMatch(controller)) {
      //       return "Enter valid email";
      //     }
      //   }
      // },
    );
  }
}
