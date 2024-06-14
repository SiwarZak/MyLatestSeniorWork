import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String labelText; // Added labelText

  MyTextField({
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.labelText, // Updated constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Fill with white color
        labelText: labelText, // Added labelText
        labelStyle: TextStyle(color: Colors.black), // Set label color
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none, // Remove border
          borderRadius: BorderRadius.circular(10.0), // Add border radius
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none, // Remove border
          borderRadius: BorderRadius.circular(10.0), // Add border radius
        ),
      ),
    );
  }
}
