import 'package:flutter/material.dart';

class RotatedBackground extends StatelessWidget {
  final String imagePath;

  const RotatedBackground({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Transform.rotate(
        angle: -0.4, // Adjust angle for diagonal effect
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black
                  .withOpacity(0.3), // Optional overlay for readability
            ),
          ),
        ),
      ),
    );
  }
}
