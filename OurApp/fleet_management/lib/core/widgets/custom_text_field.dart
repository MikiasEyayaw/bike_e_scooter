// custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  const CustomTextField({super.key, required this.hint});

  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: hint,
    ),
  );
}
