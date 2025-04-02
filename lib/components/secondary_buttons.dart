import 'package:flutter/material.dart';
import 'package:woman_safety_app/components/custom_textfield.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  const SecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
  });
  // const SecondaryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: Text(title, style: TextStyle(color: themecolor)),
      ),
    );
  }
}
