import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/calls/presentation/screens/call_screen.dart';
import 'package:convo/features/chat/presentation/screens/chat_screens.dart';
import 'package:convo/features/contacts/presentation/contact_screen.dart';
import 'package:convo/features/home/presentation/screens/chats_screen.dart';
import 'package:convo/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    ChatsScreen(),
    CallScreen(),
    ContactsScreen(),
    SettingsScreen(),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        iconSize: 30,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xff24786D),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/Message.png', width: 30),
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/Calls.png',
              width: 30,
            ),
            label: "Calls",
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Contacts.png',
                width: 30,
              ),
              label: "Contacts"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/settings.png',
                width: 30,
              ),
              label: "Settings"),
        ],
      ),
    );
  }
}
