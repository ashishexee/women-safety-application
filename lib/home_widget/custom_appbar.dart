import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final int index;
  final VoidCallback ontap;

  // List of quotes
  final List<String> quotes = [
    "Stay strong, stay safe.",
    "Empowerment begins with safety.",
    "Your safety is your priority.",
    "Be aware, stay prepared.",
    "Courage is your shield.",
    "Safety is a right, not a privilege.",
  ];

  CustomAppbar({super.key, required this.index, required this.ontap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap, // Trigger the callback when tapped
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent.withOpacity(0.8),
              Colors.orangeAccent.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Reduced opacity
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center, // Center the content
        child: Text(
          quotes[index], // Display the quote based on the index
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
