import 'package:flutter/material.dart';

class RotatedBackground extends StatelessWidget {
  final String imagePath;

  const RotatedBackground({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // First Image: Straight from top to middle
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        // Second Image: Rotated diagonally
        Positioned(
          top:
              -50, // Adjust this value to position the rotated image as desired
          left:
              -100, // Adjust this value to position the rotated image as desired
          child: Transform.rotate(
            angle: -0.785398, // 45 degrees in radians
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width *
                  1.5, // Adjust the width for the rotated image
            ),
          ),
        ),
      ],
    );
  }
}
