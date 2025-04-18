import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woman_safety_app/components/custom_textfield.dart';
import 'package:woman_safety_app/constants/constants.dart' as constants;
import 'package:woman_safety_app/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _controller = TextEditingController();
  String? id;

  getname() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          _controller.text = value.docs.first['name'];
          id = value.docs.first['id'];
        });
  }

  @override
  void initState() {
    getname();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [themecolor, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: const Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: constants.themecolor2,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Update Your Profile',
                      style: TextStyle(
                        color: constants.themecolor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextfield(
                      controller: _controller,
                      hinttext: 'Your Name',
                      ispassword: false,
                      validate: (v) {
                        if (v!.isEmpty) {
                          constants.showFlutterToast('Please enter a name');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        constants.showFlutterToast(
                          'Changing name, please wait...',
                        );
                        Future.delayed(const Duration(seconds: 2), () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(id)
                              .update({'name': _controller.text})
                              .then((value) {
                                constants.showFlutterToast(
                                  'Name successfully changed',
                                );
                              });
                        });
                      },
                      icon: const Icon(Icons.update, color: Colors.white),
                      label: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: constants.themecolor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () async {
                        // Add logout functionality here
                        await FirebaseAuth.instance.signOut();
                        constants.gotopushandremove(context, LoginPage());
                        constants.showFlutterToast('Successfully logged out');
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
