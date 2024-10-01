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
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: -50,
          left: -100,
          child: Transform.rotate(
            angle: -0.785398,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
