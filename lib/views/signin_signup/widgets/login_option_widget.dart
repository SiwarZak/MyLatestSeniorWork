import 'package:flutter/material.dart';

class LoginOptionWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  const LoginOptionWidget(
      {super.key,
      required this.title,
      required this.onTap,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [Icon(icon), const SizedBox(width: 12.0,) ,Text(title)],
          ),
        ),
      ),
    );
  }
}
