// ignore: file_names
import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woman_safety_app/components/primary_button.dart';
import 'package:woman_safety_app/constants/constants.dart';
import 'package:woman_safety_app/db/db_helper.dart';
import 'package:woman_safety_app/models/contacts.dart';

class Safehome extends StatefulWidget {
  const Safehome({super.key});

  @override
  State<Safehome> createState() => _SafehomeState();
}

class _SafehomeState extends State<Safehome> {
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
      if (_currentPosition == null) {
        showFlutterToast("Current position is not available.");
        return;
      }
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

  @override
  void initState() {
    super.initState();
    _getcurrentlocation();
  }

  void showModelissafe(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 550,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color.fromARGB(255, 255, 230, 236),
                  child: Icon(Icons.location_on, size: 50, color: themecolor),
                ),
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1.0,
                curve: Curves.easeInOut,
                child: Text(
                  'Location Sharing',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1.0,
                curve: Curves.easeInOut,
                child: Text(
                  'You can share your location with trusted contacts for safety',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: ValueNotifier(_currentAddress),
                builder: (context, value, child) {
                  return Text(value ?? '');
                },
              ),
              SizedBox(height: 10),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: PrimaryButton(
                  title: 'GET LOCATION',
                  onPressed: () {
                    _getcurrentlocation();
                    _getaddresslocation();
                  },
                ),
              ),
              SizedBox(height: 15),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: PrimaryButton(
                  title: 'SEND ALERT',
                  onPressed: () async {
                    List<TContact> contactList =
                        await DbHelper().getContactList();
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
                          "please reach out to me at this address I am in trouble $message",
                          simslot: 1,
                        );
                      }
                      showFlutterToast('Sending Message.......');
                    } else {
                      showFlutterToast('Failed to send SMS');
                    }
                  },
                ),
              ),
              SizedBox(height: 30),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: InkWell(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromARGB(255, 255, 230, 236),
                    child: Icon(Icons.close, size: 50, color: themecolor),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModelissafe(context);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6347), Color(0xFFFFA07A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Share your location with trusted contacts.',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/route.jpg',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
