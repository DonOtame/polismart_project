import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;

  CustomTextField({
    required this.labelText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword, // Muestra asteriscos para contraseñas.
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
