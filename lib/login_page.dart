import 'package:flutter/material.dart';
import 'package:woman_safety_app/components/custom_textfield.dart';
import 'package:woman_safety_app/components/primary_button.dart';
import 'package:woman_safety_app/components/secondary_buttons.dart';
import 'package:woman_safety_app/constants.dart';
import 'package:woman_safety_app/register_page_child.dart';

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
  _onSumbit() {
    _formkey.currentState!.save();
    print(_formdata['email']);
    print(_formdata['password']);
  }

  @override
  Widget build(BuildContext context) {
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
                    'User Login',
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
                      goto(context, RegisterPageChild());
                    },
                  ),
                  SecondaryButton(
                    title: 'Register as a PARENT here',
                    onPressed: () {
                      goto(context, RegisterPageChild());
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
        ),
      ),
    );
  }
}
