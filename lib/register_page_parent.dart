import 'package:flutter/material.dart';
import 'package:woman_safety_app/components/custom_textfield.dart';
import 'package:woman_safety_app/components/primary_button.dart';
import 'package:woman_safety_app/components/secondary_buttons.dart';
import 'package:woman_safety_app/constants.dart';
import 'package:woman_safety_app/login_page.dart';

class RegisterPageChild extends StatefulWidget {
  const RegisterPageChild({super.key});

  @override
  State<RegisterPageChild> createState() => _RegisterPageChildState();
}

class _RegisterPageChildState extends State<RegisterPageChild> {
  bool _isPasswordVisible = false;
  final _formkey = GlobalKey<FormState>();
  final _formdata = <String, Object>{};

  _onSumbit() {
    _formkey.currentState!.save();
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
                    'REGISTER AS PARENT',
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
                    hinttext: 'Enter your Child email',
                    preffix: Icon(Icons.email, color: themeColor),
                    ispassword: false,
                    keyboardtypee: TextInputType.emailAddress,
                    onsave: (child_email) {
                      _formdata['child_email'] = child_email ?? " ";
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
                    ispassword: !_isPasswordVisible,
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
                  const SizedBox(height: 35),
                  PrimaryButton(
                    title: 'REGISTER',
                    onPressed: () {
                      // Add login logic here
                      if (_formdata['password'] !=
                          _formdata['confirmed_password']) {
                        return 'Confirm Password does not matches the Password';
                      }
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
                      goto(context, LoginPage());
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