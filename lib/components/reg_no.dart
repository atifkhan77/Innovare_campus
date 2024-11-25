import 'package:flutter/material.dart';

class RegistrationNumberField extends StatelessWidget {
  final TextEditingController controller;

  const RegistrationNumberField({super.key, required this.controller});

  String? _validateRegNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your registration number';
    }
    final regExp =
        RegExp(r'^(FA|SP)\d{2}-[A-Z]{3}-\d{3}$', caseSensitive: false);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid registration number e.g FA11-aaa-000 or SP11-AAA-000';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Enter your Reg No. e.g FA11-aaa-000 or SP11-AAA-000',
        hintStyle: TextStyle(color: Colors.black26),
      ),
      validator: _validateRegNo,
    );
  }
}
