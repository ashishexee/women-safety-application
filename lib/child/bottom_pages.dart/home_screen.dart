import 'dart:math';
import 'package:flutter/material.dart';
import 'package:woman_safety_app/home_widget/custom_appbar.dart';
import 'package:woman_safety_app/home_widget/custom_carouel.dart';
import 'package:woman_safety_app/home_widget/emergency.dart';
import 'package:woman_safety_app/home_widget/livesafe.dart';
import 'package:woman_safety_app/safehome/SafeHome.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int qindex = 0;

  void getrandom() {
    setState(() {
      Random random = Random();
      qindex = random.nextInt(6);
    });
  }

  @override
  void initState() {
    getrandom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          // Add SingleChildScrollView here
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(index: qindex, ontap: getrandom),
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
                        color: Colors.white,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Livesafe(),
                Safehome(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
