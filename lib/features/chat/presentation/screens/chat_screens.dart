// chat_screen.dart
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:convo/features/calls/presentation/screens/voice_call.dart';
import 'package:convo/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../calls/presentation/screens/vedio_call.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String editedMessageText = '';
  final Set<String> _unblurredImages = {};

  @override
  Widget build(BuildContext context) {
    final otherUser = GoRouterState.of(context).extra as UserModel;
    final currentUser = HomeCubit.get(context).currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final chatCubit = ChatCubit.get(context);
    final chatId = chatCubit.generateChatId(currentUser.id, otherUser.id);
    final stream = chatCubit.listenToMessages(chatId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(otherUser.profilePic ?? ""),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(otherUser.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("Active now", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon:
              Image.asset('assets/images/Call.png', width: 30, height: 30),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ZimVoiceCall(
                    callid: "1",
                    userid: currentUser.id,
                    otherUserId: otherUser.id,
                  ),
                ));
              },
            ),
            IconButton(
              icon:
              Image.asset('assets/images/Video.png', width: 30, height: 30),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ZegoVideoCall(
                    callid: "1",
                    userid: currentUser.id,
                    otherUserId: otherUser.id,
                  ),
                ));
              },
            ),
            const SizedBox(width: 10)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUser.id;
                    final isImage = ChatCubit.get(context).isImageMessage(msg['message']);
                    final isSensitive = msg.data().toString().contains('sensitive') && msg['sensitive'] == true;

                    if (isImage) {
                      final msgId = msg.id;
                      final isUnblurred = _unblurredImages.contains(msgId) || !isSensitive;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (isSensitive) {
                              setState(() {
                                _unblurredImages.add(msgId);
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.network(
                                    msg['message'],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  if (!isUnblurred)
                                    Positioned.fill(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.2),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "Blurred\nTap to reveal",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return _buildTextMessage(msg['message'], isMe, msg);
                  },
                );
              },
            ),
          ),
          _buildBottomInput(context, chatId, currentUser.id, otherUser.id),
        ],
      ),
    );
  }

  Widget _buildTextMessage(String text, bool isMe, QueryDocumentSnapshot msg) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            const SizedBox(height: 4),
            Text(
              msg['timestamp'].toDate().toString().substring(11, 16),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInput(BuildContext context, String chatId, String senderId, String receiverId) {
    final chatCubit = ChatCubit.get(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => _openAttachmentOptions(context, chatId, senderId, receiverId),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Write your message", border: InputBorder.none),
              onChanged: (val) => editedMessageText = val,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (editedMessageText.trim().isEmpty) return;
              chatCubit.sendMessage(
                chatId: chatId,
                senderId: senderId,
                receiverId: receiverId,
                messageText: editedMessageText,
              );
              _controller.clear();
              setState(() => editedMessageText = '');
            },
          ),
        ],
      ),
    );
  }

  void _openAttachmentOptions(BuildContext context, String chatId, String senderId, String receiverId) {
    final chatCubit = ChatCubit.get(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _attachmentItem(Icons.camera_alt, "Camera", () async {
            Navigator.pop(context);
            await chatCubit.pickAndUploadImage(
              chatId: chatId,
              senderId: senderId,
              receiverId: receiverId,
              source: ImageSource.camera,
              onUploaded: (url, isSensitive) {
                chatCubit.sendMessage(
                  chatId: chatId,
                  senderId: senderId,
                  receiverId: receiverId,
                  messageText: url,
                  isSensitive: isSensitive,
                );
              },
            );
          }),
          _attachmentItem(Icons.photo, "Media", () async {
            Navigator.pop(context);
            await chatCubit.pickAndUploadImage(
              chatId: chatId,
              senderId: senderId,
              receiverId: receiverId,
              source: ImageSource.gallery,
              onUploaded: (url, isSensitive) {
                chatCubit.sendMessage(
                  chatId: chatId,
                  senderId: senderId,
                  receiverId: receiverId,
                  messageText: url,
                  isSensitive: isSensitive,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _attachmentItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.grey.shade200, child: Icon(icon)),
      title: Text(title),
      onTap: onTap,
    );
  }
}
