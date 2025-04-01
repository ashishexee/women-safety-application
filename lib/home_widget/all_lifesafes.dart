import 'package:flutter/material.dart';

class PoliceStation extends StatelessWidget {
  final Function? onMapFunction;
  const PoliceStation({super.key, this.onMapFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onMapFunction!('police station near me');
          },
          child: Card(
            elevation: 3,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: Image.asset('assets/police-badge.png', height: 42),
              ),
            ),
          ),
        ),
        Flexible(
          child: ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
            child: Text(
              "Police Station",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This color is overridden by the gradient
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HospitalCard extends StatelessWidget {
  final Function? onMapFunction;
  const HospitalCard({super.key, this.onMapFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onMapFunction!('Hospital near me');
          },
          child: Card(
            elevation: 3,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: Image.asset('assets/hospital.png', height: 42),
              ),
            ),
          ),
        ),
        Flexible(
          child: ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
            child: Text(
              "Hospital",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This color is overridden by the gradient
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MedicalFacilityCard extends StatelessWidget {
  final Function? onMapFunction;
  const MedicalFacilityCard({super.key, this.onMapFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onMapFunction!('Pharmacy near me');
          },
          child: Card(
            elevation: 3,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: Image.asset('assets/pharmacy.png', height: 42),
              ),
            ),
          ),
        ),
        Flexible(
          child: ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
            child: Text(
              "Pharmacy",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This color is overridden by the gradient
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BusStation extends StatelessWidget {
  final Function? onMapFunction;
  const BusStation({super.key, this.onMapFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onMapFunction!('Bus Stops near me');
          },
          child: Card(
            elevation: 3,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: Image.asset('assets/bus-stop.png', height: 42),
              ),
            ),
          ),
        ),
        Flexible(
          child: ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
            child: Text(
              "Bus Station",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This color is overridden by the gradient
              ),
            ),
          ),
        ),
      ],
    );
  }
}
