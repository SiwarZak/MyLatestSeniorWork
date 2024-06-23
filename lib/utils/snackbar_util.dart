import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(
    content: Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
