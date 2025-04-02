import 'package:flutter/material.dart';

const themecolor = Color(0xFFfc4572);
void goto(BuildContext context, Widget nextscreen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextscreen));
}
