import 'dart:math';
import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:woman_safety_app/constants/constants.dart';
import 'package:woman_safety_app/db/db_helper.dart';
import 'package:woman_safety_app/home_widget/custom_appbar.dart';
import 'package:woman_safety_app/home_widget/custom_carouel.dart';
import 'package:woman_safety_app/home_widget/emergency.dart';
import 'package:woman_safety_app/home_widget/livesafe.dart';
import 'package:woman_safety_app/models/contacts.dart';
import 'package:woman_safety_app/safehome/SafeHome.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;
  _getpermission() async => await [Permission.sms].request();
  _ispermissiongranded() async {
    return await Permission.sms.status.isGranted;
  }

  _sendSms(String phonenumber, String message, {int? simslot}) async {
    await BackgroundSms.sendMessage(
      phoneNumber: phonenumber,
      message: message,
      simSlot: simslot,
    ).then((SmsStatus status) {
      if (status == SmsStatus.sent) {
        showFlutterToast('Message has been send');
      } else {
        showFlutterToast('Could not send Message');
      }
    });
  }

  _getcurrentlocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      showFlutterToast(
        "Location permission is permanently denied. Please check your device settings.",
      );
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
      _getaddresslocation();
    } catch (e) {
      showFlutterToast(e.toString());
    }
  }

  _getaddresslocation() async {
    try {
      Future.delayed(Duration(seconds: 10), () {
        if (_currentPosition == null) {
          showFlutterToast("Current position is not available.");
        }
      });
      List<Placemark> placemark = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      Placemark place = placemark[0];
      if (mounted) {
        setState(() {
          _currentAddress =
              "${place.locality},${place.postalCode},${place.street},${place.administrativeArea},${place.subAdministrativeArea}";
        });
      }
    } catch (e) {
      showFlutterToast(e.toString());
    }
  }

  int qindex = 0;
  late ShakeDetector shakeDetector;

  void getrandom() {
    setState(() {
      Random random = Random();
      qindex = random.nextInt(6);
    });
  }

  @override
  void initState() {
    super.initState();
    getrandom();
    _getaddresslocation();
    _getcurrentlocation();
    _getpermission();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: (ShakeEvent event) async {
          List<TContact> contactList = await DbHelper().getContactList();
          // we basically want to make the recp like this
          // 7678250729;8178424572;981061858;9873853802
          String recp = "";
          int index = 1;
          for (TContact contact in contactList) {
            recp += contact.number;
            if (index != contactList.length) {
              recp += ";";
              index++;
            }
          }
          String message =
              "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";
          if (await _ispermissiongranded()) {
            for (var element in contactList) {
              _sendSms(
                element.number,
                "please reach out to me at this address I am in EMERGENCY please help $message",
                simslot: 1,
              );
            }
            showFlutterToast('Sending Message.......  (EMERGENCY)');
          } else {
            showFlutterToast('Failed to send SMS  (EMERGENCY)');
          }
        },
        minimumShakeCount: 2,
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        shakeThresholdGravity: 2.7,
      );
    });
  }

  @override
  void dispose() {
    shakeDetector.stopListening();
    super.dispose();
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
