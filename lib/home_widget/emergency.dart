import 'package:flutter/material.dart';
import 'package:woman_safety_app/home_widget/all_emergencies.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: PoliceEmegency(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: AmbulancEmegency(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: FlameEmegency(),
          ),
        ],
      ),
    );
  }
}
