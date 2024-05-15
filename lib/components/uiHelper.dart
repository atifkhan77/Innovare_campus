import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UiHelper {
  static CustomTextField(TextEditingController controller, String text,
      bool hide, IconData iconData) {
    return TextField(
      controller: controller,
      obscureText: hide,
      decoration: InputDecoration(hintText: text),
    );
  }

  static customText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color.fromRGBO(0, 0, 70, 1),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static customButton(
    String text,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Color.fromARGB(255, 119, 37, 243),
      ),
      onPressed: () {
        // Implement login functionality
      },
      child: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Color.fromARGB(255, 119, 37, 243),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
