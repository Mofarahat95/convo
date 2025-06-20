import 'package:convo/features/calls/presentation/screens/call_history.dart';
import 'package:convo/features/contacts/presentation/contact_screen.dart';
import 'package:convo/features/home/presentation/screens/chats_screen.dart';
import 'package:convo/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    ChatsScreen(),
    CallHistory(),
    ContactsScreen(),
    SettingsScreen(),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        iconSize: 30,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff24786D),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: Color(0xff24786D)),
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/Message.png', width: 30),
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/Calls.png', width: 30),
            label: "Calls",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/Contacts.png', width: 30),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/settings.png', width: 30),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
