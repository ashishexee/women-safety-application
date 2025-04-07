// ignore_for_file: unrelated_type_equality_checks

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:woman_safety_app/constants/constants.dart';
import 'package:woman_safety_app/db/shared_pref.dart';
import 'package:woman_safety_app/child/bottom_pages.dart/home_screen.dart';
import 'package:woman_safety_app/login_page.dart';
import 'package:woman_safety_app/parents/parents_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPref.init(); // Initialize SharedPreferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        parentsroute: (context) => const ParentsHomeScreen(),
        childroute: (context) => const HomeScreen(),
      },
      home: FutureBuilder<String?>(
        future: SharedPref.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == 'child') {
              return HomeScreen();
            } else if (snapshot.data == 'parent') {
              return ParentsHomeScreen();
            } else {
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}
