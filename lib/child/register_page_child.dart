import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woman_safety_app/components/custom_textfield.dart';
import 'package:woman_safety_app/components/primary_button.dart';
import 'package:woman_safety_app/components/secondary_buttons.dart';
import 'package:woman_safety_app/constants/constants.dart';
import 'package:woman_safety_app/login_page.dart';
import 'package:woman_safety_app/models/userModal.dart';

class RegisterPageChild extends StatefulWidget {
  const RegisterPageChild({super.key});

  @override
  State<RegisterPageChild> createState() => _RegisterPageChildState();
}

class _RegisterPageChildState extends State<RegisterPageChild> {
  bool _isPasswordVisible = false;
  bool _isconfirmpasswordvisible = false;
  final _formkey = GlobalKey<FormState>();
  final _formdata = <String, Object>{};

  _onSumbit() {
    _formkey.currentState!.save();
    if (_formdata['password'] != _formdata['confirmed_password']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Confirm Password does not match the Password'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      progressindicator(context, 'Registering');
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        auth
            .createUserWithEmailAndPassword(
              email: _formdata['email'].toString(),
              password: _formdata['password'].toString(),
            )
            // there are mainly 2 main operations where you can use WHEN and THEN
            .then((v) async {
              DocumentReference<Map<String, dynamic>> db = FirebaseFirestore
                  .instance
                  .collection('users')
                  .doc(v.user!.uid);
              final user = Usermodal(
                name: _formdata['name'].toString(),
                phone: _formdata['phone'].toString(),
                id: v.user!.uid,
                email: _formdata['email'].toString(),
                parentsEmail: _formdata['guardian_email'].toString(),
                type: 'child',
              );
              final jsonData = user.tojson();
              await db.set(jsonData).whenComplete(() {
                gotopush(context, LoginPage());
              });
            });
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage =
              'This email is already in use. Please use a different email.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } else {
          errorMessage = 'An error occurred: ${e.message}';
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    }
    print(_formdata['email']);
    print(_formdata['password']);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFfc4572);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'REGISTER AS CHILD',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
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
                  CustomTextfield(
                    hinttext: 'Enter your name',
                    preffix: Icon(Icons.person, color: themeColor),
                    ispassword: false,
                    keyboardtypee: TextInputType.emailAddress,
                    onsave: (name) {
                      _formdata['name'] = name ?? " ";
                    },
                    validate: (name) {
                      if (name!.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  CustomTextfield(
                    hinttext: 'Enter your Phone',
                    preffix: Icon(Icons.phone, color: themeColor),
                    ispassword: false,
                    keyboardtypee: TextInputType.phone,
                    onsave: (phone) {
                      _formdata['phone'] = phone ?? " ";
                    },
                    validate: (phone) {
                      if (phone!.isEmpty) {
                        return 'Phone Number cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  CustomTextfield(
                    hinttext: 'Enter your Guardian email',
                    preffix: Icon(Icons.email, color: themeColor),
                    ispassword: false,
                    keyboardtypee: TextInputType.emailAddress,
                    onsave: (guardianEmail) {
                      _formdata['guardian_email'] = guardianEmail ?? " ";
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
                  SizedBox(height: 12),
                  CustomTextfield(
                    hinttext: 'Enter your Email',
                    preffix: Icon(Icons.email, color: themeColor),
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
                  SizedBox(height: 12),
                  CustomTextfield(
                    hinttext: 'Enter your password',
                    preffix: Icon(Icons.lock, color: themeColor),
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
                        color: themeColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  CustomTextfield(
                    hinttext: 'Confirm Password',
                    preffix: Icon(Icons.lock, color: themeColor),
                    ispassword: !_isconfirmpasswordvisible,
                    onsave: (confirmedPassword) {
                      _formdata['confirmed_password'] =
                          confirmedPassword ?? " ";
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
                        _isconfirmpasswordvisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: themeColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isconfirmpasswordvisible =
                              !_isconfirmpasswordvisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 35),
                  PrimaryButton(
                    title: 'REGISTER',
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _onSumbit();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    title: 'ALready Registered? Login Here',
                    onPressed: () {
                      // Navigate to registration page
                      gotopush(context, LoginPage());
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
        ),
      ),
    );
  }
}
