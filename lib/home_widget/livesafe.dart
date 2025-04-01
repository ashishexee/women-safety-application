import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woman_safety_app/home_widget/all_lifesafes.dart';

class Livesafe extends StatelessWidget {
  const Livesafe({super.key});
  static Future<void> openmap(String location) async {
    String googleurl =
        'https://www.google.com/maps/search/$location';
    final Uri url = Uri.parse(googleurl);
    try {
      await launchUrl(url);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong call emergency number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceStation(onMapFunction: openmap),
          SizedBox(width: 40), // Add spacing between the cards
          HospitalCard(onMapFunction: openmap),
          SizedBox(width: 40),
          MedicalFacilityCard(onMapFunction: openmap),
          SizedBox(width: 40),
          BusStation(onMapFunction: openmap),
        ],
      ),
    );
  }
}
