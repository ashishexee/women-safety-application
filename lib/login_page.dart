import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woman_safety_app/child/bottom_page.dart';
import 'package:woman_safety_app/components/custom_textfield.dart';
import 'package:woman_safety_app/components/primary_button.dart';
import 'package:woman_safety_app/components/secondary_buttons.dart';
import 'package:woman_safety_app/constants/constants.dart';
import 'package:woman_safety_app/db/shared_pref.dart';
import 'package:woman_safety_app/child/register_page_child.dart';
import 'package:woman_safety_app/parents/parents_home_screen.dart';
import 'package:woman_safety_app/parents/register_page_parent.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

const themecolor = Color(0xFFfc4572);

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _formkey = GlobalKey<FormState>();
  final _formdata = <String, Object>{};
  bool isloading = false;

  _onSumbit() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _formdata['email'].toString(),
              password: _formdata['password'].toString(),
            );
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((value) {
              if (value.exists) {
                final userType = value.data()?['type'];
                if (userType == 'parent') {
                  SharedPref.saveUser('parent');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ParentsHomeScreen(),
                    ),
                  );
                } else if (userType == 'child') {
                  SharedPref.saveUser('child');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => BottomPage()),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Unknown user type'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User data not found'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User with this Email is not found'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error occurred ${e.code}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'USER LOGIN',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFfc4572),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/logo.png',
                          height: 150,
                          width: 150,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextfield(
                        hinttext: 'Enter your email',
                        preffix: Icon(Icons.email, color: themecolor),
                        ispassword: false,
                        keyboardtypee: TextInputType.emailAddress,
                        onsave: (email) {
                          _formdata['email'] = email ?? " ";
                        },
                        validate: (email) {
                          if (email!.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          if (email.length < 3) {
                            return 'Email is too short';
                          }
                          if (!email.contains('@')) {
                            return 'Invalid email format(Missing @)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextfield(
                        hinttext: 'Enter your password',
                        preffix: Icon(Icons.lock, color: themecolor),
                        ispassword: !_isPasswordVisible,
                        onsave: (password) {
                          _formdata['password'] = password ?? " ";
                        },
                        validate: (password) {
                          if (password!.isEmpty) {
                            return 'password cannot be empty';
                          } else if (password.length <= 7) {
                            return 'password is less than 7 words';
                          }
                          return null;
                        },
                        suffix: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: themecolor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 35),
                      PrimaryButton(
                        title: 'LOGIN',
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _onSumbit();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      SecondaryButton(
                        title: 'Register as a CHILD here',
                        onPressed: () {
                          gotopush(context, RegisterPageChild());
                        },
                      ),
                      SecondaryButton(
                        title: 'Register as a PARENT here',
                        onPressed: () {
                          gotopush(context, RegisterPageParent());
                        },
                      ),
                      const SizedBox(height: 3),
                      SecondaryButton(
                        title: 'Forgot Password? Click Here',
                        onPressed: () {
                          // Navigate to forgot password page
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '© 2025 Woman Safety App By Ashishexee',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
