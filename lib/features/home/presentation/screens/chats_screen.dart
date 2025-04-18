import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';
import 'package:convo/features/home/presentation/bloc/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsScreen extends StatelessWidget {
  ChatsScreen({super.key});

  final List<Map<String, dynamic>> chats = [
    {
      "name": "Alex",
      "message": "How are you today?",
      "time": "2 min ago",
      "unread": 3,
      "avatar": "assets/images/alex.png"
    },
    {
      "name": "Team Align",
      "message": "Don't miss to attend the meeting.",
      "time": "2 min ago",
      "unread": 4,
      "avatar": "assets/images/team.png"
    },
    {
      "name": "John",
      "message": "Hey! Can you join the meeting?",
      "time": "2 min ago",
      "unread": 0,
      "avatar": "assets/images/john.png"
    },
  ];

  final List<Map<String, String>> statusList = [
    {"name": "Max", "avatar": "assets/images/max.png"},
    {"name": "Marina", "avatar": "assets/images/marina.png"},
    {"name": "Natelia", "avatar": "assets/images/natelia.png"},
    {"name": "John", "avatar": "assets/images/john.png"},
    {"name": "Max", "avatar": "assets/images/max.png"},
    {"name": "Marina", "avatar": "assets/images/marina.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: BlocBuilder<HomeCubit, HomeStates>(
            builder: (context, state) {
              return Text(
                "Home",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                ),
              );
            },
          ),
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(Icons.search, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  // action for profile or settings
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 2),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/profile.png'),
                              radius: 35,
                              backgroundColor: Colors.white,
                            ),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.add,
                                  color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text("My status",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  ...statusList.map((status) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.green, width: 3),
                              ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: AssetImage(status['avatar']!),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(status['name']!,
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(AppRoutes.chatRoute);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(chat['avatar']),
                          ),
                          title: Text(chat['name'],
                              style: TextStyle(
                                  color: Color(0xff000E08),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          subtitle: Text(chat['message'],
                              style: TextStyle(color: Colors.grey)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(chat['time'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              if (chat['unread'] > 0)
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: Text(chat['unread'].toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRoutes.chatBotRoute);
                      },
                      child: Image.asset(
                        'assets/images/chat_bot.png',
                        width: 30,
                      ),
                    )),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
