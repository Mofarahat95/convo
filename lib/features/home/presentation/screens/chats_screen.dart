import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';
import 'package:convo/features/home/presentation/bloc/home_states.dart';
import 'package:convo/features/home/presentation/screens/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../config/routes_manager/routes.dart';
import '../../../story/story_list.dart';
import '../../../story/uploadStory.dart';
import '../../../chat/presentation/bloc/chat_cubit.dart';

class ChatsScreen extends StatelessWidget {
  ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final homeCubit = HomeCubit.get(context);
        final user = homeCubit.currentUser;
        final chatPartners = homeCubit.chatPartners;
        final chatIds = homeCubit.chatIds;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Hi ${user?.name.split(" ").first ?? ""}",
              style: GoogleFonts.quicksand(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => SearchDialog(
                    contacts: homeCubit.filteredContacts.isNotEmpty
                        ? homeCubit.filteredContacts
                        : homeCubit.chatPartners.values.toList(),
                    messages: homeCubit.filteredMessages,
                    onSearchChanged: (query) {
                      homeCubit.filterChatsAndMessages(query);
                    },
                  ),
                );
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () => GoRouter.of(context).push(AppRoutes.settingsRoute),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user?.profilePic ?? ""),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 2),
              _buildStatusHeader(context, user),
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
                      child: chatPartners.isEmpty
                          ? const Center(child: Text("No chats yet"))
                          : ListView.builder(
                        itemCount: chatPartners.length,
                        itemBuilder: (context, index) {
                          final partner = chatPartners.values.elementAt(index);
                          final chatId = chatIds.firstWhere(
                                (id) => id.contains(partner.id),
                            orElse: () => '',
                          );

                          if (chatId.isEmpty) return const SizedBox();

                          return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('chats')
                                .doc(chatId)
                                .collection('messages')
                                .orderBy('timestamp', descending: true)
                                .limit(1)
                                .get(),
                            builder: (context, snapshot) {
                              String lastMessage = "No messages yet";
                              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                                final rawText = data['message'] ?? "";
                                final isVoice = data['isVoice'] == true;
                                final isImage = rawText.toString().startsWith('https://');

                                if (isVoice) {
                                  lastMessage = "🎤 Voice";
                                } else if (isImage) {
                                  lastMessage = "📷 Image";
                                } else {
                                  lastMessage = ChatCubit.get(context).decryptMessage(rawText);
                                }
                              }

                              return Slidable(
                                key: ValueKey(partner.id),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {
                                        // هنا ممكن تضيف كود حذف الشات من Firestore
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Deleted ${partner.name}')),
                                        );
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  onTap: () => GoRouter.of(context).push(AppRoutes.chatRoute, extra: partner),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(partner.profilePic),
                                  ),
                                  title: Text(
                                    partner.name,
                                    style: const TextStyle(
                                      color: Color(0xff000E08),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  trailing: const Text(
                                    "1 min ago",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 20,
                      child: GestureDetector(
                        onTap: () => GoRouter.of(context).push(AppRoutes.insidechatRoute),
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

  Widget _buildStatusHeader(BuildContext context, UserModel? user) {
    return Container(
      height: 120,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await StoryUploader().uploadStory(context);
                    HomeCubit.get(context).getUserChats();
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user?.profilePic ?? ""),
                        radius: 35,
                        backgroundColor: Colors.white,
                      ),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                const Text("My status", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: buildStoriesBar(context),
          ),
        ],
      ),
    );
  }
}
