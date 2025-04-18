import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:woman_safety_app/constants/constants.dart';

class MessageTextField extends StatefulWidget {
  final String currentid;
  final String friendid;
  const MessageTextField({
    super.key,
    required this.currentid,
    required this.friendid,
  });

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;
  File? imageFile;
  Future uploadimagetocloudnaryfromcamera() async {
    final picker = ImagePicker();
    final pickerfile = await picker.pickImage(source: ImageSource.camera);
    if (pickerfile == null) {
      return showFlutterToast('No Image was selected');
    }
    File imageFile = File(pickerfile.path);
    const cloudname = "dygzb2p5g";
    const uploadpreset = "images";
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudname/image/upload',
    );
    final request =
        http.MultipartRequest('POST', uri)
          ..fields['upload_preset'] = uploadpreset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(respStr);
      return jsonResponse['secure_url']; // This is the URL of the uploaded image
    } else {
      print('Upload failed: ${response.statusCode}');
      return null;
    }
  }

  Future uploadimagetocloudnaryfromgallery() async {
    final picker = ImagePicker();
    final pickerfile = await picker.pickImage(source: ImageSource.gallery);
    if (pickerfile == null) {
      return showFlutterToast('No Image was selected');
    }
    File imageFile = File(pickerfile.path);
    const cloudname = "dygzb2p5g";
    const uploadpreset = "images";
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudname/image/upload',
    );
    final request =
        http.MultipartRequest('POST', uri)
          ..fields['upload_preset'] = uploadpreset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(respStr);
      return jsonResponse['secure_url']; // This is the URL of the uploaded image
    } else {
      print('Upload failed: ${response.statusCode}');
      return null;
    }
  }

  final TextEditingController _controller = TextEditingController();
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

 sendmessage(String message, String messagetype) async {
  String messageId = Uuid().v1(); // generate a fixed ID

  Map<String, dynamic> messageData = {
    'senderid': widget.currentid,
    'recieverid': widget.friendid,
    'message': message,
    'date': DateTime.now(),
    'messagetype': messagetype,
    'messageid': messageId, // (small: 'messageid' not 'messageId' for consistency)
  };

  // use .doc(messageId).set(messageData) instead of .add()
  await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentid)
      .collection('messages')
      .doc(widget.friendid)
      .collection('chats')
      .doc(messageId)
      .set(messageData); 

  await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.friendid)
      .collection('messages')
      .doc(widget.currentid)
      .collection('chats')
      .doc(messageId)
      .set(messageData); 
}


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: themecolor,
              controller: _controller,
              style: TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(
                  color: const Color.fromRGBO(218, 58, 98, 1),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                prefixIcon: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => bottonsheet(),
                    );
                  },
                  icon: Icon(Icons.add_box_rounded, color: themecolor),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: themecolor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () async {
                sendmessage(_controller.text, 'text');
                _controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bottonsheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const Text(
              'Choose an Action',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themecolor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                chatsIcon(Icons.location_pin, 'Location', () async {
                  showFlutterToast('Fetching Location');
                  await _getcurrentlocation();
                  String message;
                  Future.delayed(Duration(seconds: 2), () {
                    message =
                        "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";
                    sendmessage(message, 'link');
                    showFlutterToast('Sent');
                    Navigator.of(context).pop();
                  });
                }),
                chatsIcon(Icons.camera, 'Camera', () async {
                  showFlutterToast('Opening Camera...');
                  Future.delayed(Duration(seconds: 2), () async {
                    String imageurl = await uploadimagetocloudnaryfromcamera();
                    sendmessage(imageurl, 'img');
                    showFlutterToast('Image Sent!!');
                    Navigator.of(context).pop();
                  });
                }),
                chatsIcon(Icons.photo, 'Photo', () async {
                  showFlutterToast('Opening Gallery...');
                  Future.delayed(Duration(seconds: 2), () async {
                    String imageurl = await uploadimagetocloudnaryfromgallery();
                    sendmessage(imageurl, 'img');
                    showFlutterToast('Image Sent!!');
                    Navigator.of(context).pop();
                  });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  chatsIcon(IconData icons, String title, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: themecolor.withOpacity(0.9),
            child: Icon(icons, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Future uploadimage() async {
    String filename = Uuid().v1();
    int status = 1;
    var ref = FirebaseStorage.instance
        .ref()
        .child('image')
        .child("$filename.jpg");
    var uploadImage = await ref.putFile(imageFile!).catchError((e) {
      status = 0;
      return showFlutterToast('An error occured $e');
    });
    if (status == 1) {
      String imageurl = await uploadImage.ref.getDownloadURL();
      await sendmessage(imageurl, 'img');
    }
  }
}
