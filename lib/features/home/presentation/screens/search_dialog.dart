import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchDialog extends StatefulWidget {
  final List<UserModel> contacts;
  final List<Map<String, dynamic>> messages;
  final Function(String) onSearchChanged;

  const SearchDialog({
    Key? key,
    required this.contacts,
    required this.messages,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredContacts = widget.contacts.where((user) {
      final lowerQuery = searchQuery.toLowerCase();
      return user.name.toLowerCase().contains(lowerQuery) ||
          user.phone.toLowerCase().contains(lowerQuery);
    }).toList();

    final filteredMessages = widget.messages;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  widget.onSearchChanged(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search contacts or messages',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (filteredContacts.isNotEmpty) ...[
                    const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text("Contacts",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    ...filteredContacts.map((user) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.phone),
                        onTap: () {
                          GoRouter.of(context)
                              .push(AppRoutes.chatRoute, extra: user);
                        },
                      );
                    }).toList(),
                  ],
                  if (filteredMessages.isNotEmpty) ...[
                    const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Messages",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    ...filteredMessages.map((msg) {
                      final senderId = msg['senderId'];
                      final senderName = senderId ==
                          HomeCubit.get(context).currentUser?.id
                          ? 'You'
                          : HomeCubit.get(context).chatPartners[senderId]?.name ??
                          'Unknown';

                      return ListTile(
                        leading: const Icon(Icons.message),
                        title: Text(msg['message']),
                        subtitle: Text("From: $senderName"),
                        onTap: () {
                          final otherUserId = HomeCubit.get(context)
                              .extractOtherUserId(
                              msg['chatId'], HomeCubit.get(context).currentUser!.id);
                          final otherUser =
                          HomeCubit.get(context).chatPartners[otherUserId];

                          if (otherUser != null) {
                            GoRouter.of(context)
                                .push(AppRoutes.chatRoute, extra: otherUser);
                          }
                        },
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
