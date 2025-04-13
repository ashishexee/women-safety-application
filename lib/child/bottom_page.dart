import 'package:flutter/material.dart';
import 'package:woman_safety_app/child/bottom_pages.dart/add_contacts.dart';
import 'package:woman_safety_app/child/bottom_pages.dart/chat_page.dart';
import 'package:woman_safety_app/child/bottom_pages.dart/home_screen.dart';
import 'package:woman_safety_app/child/bottom_pages.dart/profile_page.dart';
import 'package:woman_safety_app/child/bottom_pages.dart/ratings_page.dart';
import 'package:woman_safety_app/constants/constants.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    AddContacts(),
    ChatPage(),
    ReviewPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: themecolor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: 'Contacts',
            icon: Icon(Icons.contacts),
          ),
          BottomNavigationBarItem(label: 'Chat', icon: Icon(Icons.chat)),
          BottomNavigationBarItem(label: 'Reviews', icon: Icon(Icons.reviews)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
