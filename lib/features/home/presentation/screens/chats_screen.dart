import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/signup/user_model.dart';
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
      "name": "Kero Emad",
      "message": "hi?",
      "time": "1 min ago",
      "unread": 0,
      "avatar": "assets/images/omar.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final user = HomeCubit.get(context).currentUser!;
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Hi ${user.name.split(" ").first}",
              style: GoogleFonts.quicksand(color: Colors.white),
            ),
            centerTitle: true,
            leading: const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(Icons.search, color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.settingsRoute);
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user.profilePic ?? ""),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 2),
              Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 35,
                                backgroundColor: Colors.white,
                              ),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.green,
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          const Text("My status",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
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
                              title: Text(
                                chat['name'],
                                style: const TextStyle(
                                  color: Color(0xff000E08),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(chat['message'],
                                  style: const TextStyle(color: Colors.grey)),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(chat['time'],
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  if (chat['unread'] > 0)
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        chat['unread'].toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
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
                          GoRouter.of(context).push(AppRoutes.insidechatRoute);
                        },
                        child: Image.asset(
                          'assets/images/chat_bot.png',
                          width: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
