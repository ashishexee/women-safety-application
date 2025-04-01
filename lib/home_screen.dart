import 'dart:math';

import 'package:flutter/material.dart';
import 'package:woman_safety_app/home_widget/custom_appbar.dart';
import 'package:woman_safety_app/home_widget/custom_carouel.dart';
import 'package:woman_safety_app/home_widget/emergency.dart';
import 'package:woman_safety_app/home_widget/livesafe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // const HomeScreen({super.key});
  int qindex = 0;

  // initially the qoute index is 0
  void getrandom() {
    setState(() {
      Random random = Random();
      qindex = random.nextInt(6); // Assuming there are 6 quotes
    });
  }

  @override
  void initState() {
    // init state is basically the first function that is called back by the user
    getrandom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppbar(index: qindex, ontap: getrandom), // custom app bar
              CustomCarouel(onSlideChange: getrandom),
              Center(
                child: ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [Colors.red, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                  child: Text(
                    "Emergencies",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors
                              .white, // This color is overridden by the gradient
                    ),
                  ),
                ),
              ),
              Emergency(),
              Center(
                child: ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [Colors.red, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Explore Livesafe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors
                                .white, // This color is overridden by the gradient
                      ),
                    ),
                  ),
                ),
              ),
              Livesafe(),
              // custom carouel ,,,,, // whenever this slide change is called for it will get a random
            ],
          ),
        ),
      ),
    );
  }
}
