import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final int index;
  final VoidCallback ontap;

  // List of quotes
  final List<String> quotes = [
    "Stay strong, stay safe.",
    "Powerful and Protected.",
    "Your safety is your priority.",
    "Be aware, stay prepared.",
    "Courage is your shield.",
    "Safety is a right, not a privilege.",
  ];

  CustomAppbar({super.key, required this.index, required this.ontap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Center(
        child: ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [Colors.red, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              quotes[index],
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This will be masked by the shader
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
