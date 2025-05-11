import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:convo/features/calls/presentation/screens/vedio_call.dart';
import 'package:convo/features/calls/presentation/screens/voice_call.dart';
import 'package:convo/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String? editingMessageId;
  String editedMessageText = '';
  late String chatId;
  late UserModel otherUser;
  late ChatCubit chatCubit;
  late String currentUserId;
  Stream<QuerySnapshot>? _stream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = HomeCubit.get(context).currentUser;
      if (currentUser == null) return;
      chatCubit = ChatCubit.get(context);
      otherUser = GoRouterState.of(context).extra as UserModel;
      currentUserId = currentUser.id;
      chatId = chatCubit.generateChatId(currentUserId, otherUser.id);
      setState(() {
        _stream = chatCubit.listenToMessages(chatId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = HomeCubit.get(context).currentUser;
    if (currentUser == null || _stream == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () => GoRouter.of(context).push('/profile', extra: otherUser),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(otherUser.profilePic ?? ""),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(otherUser.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                  const Text("Active now", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: Image.asset('assets/images/Call.png', width: 30, height: 30),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ZimVoiceCall(
                      callid: "123456",
                      userid: currentUserId,
                      otherUserId: otherUser.id,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/images/Video.png', width: 30, height: 30),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ZegoVideoCall(
                      callid: "123456",
                      userid: currentUserId,
                      otherUserId: otherUser.id,
                    ),
                  ),
                );
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
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("⚠️ Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == currentUser.id;
                    String messageId = message.id;
                    return _buildMessageBubble(
                      message['message'],
                      isMe,
                      message['timestamp'].toDate().toString().substring(11, 16),
                      messageId,
                      chatId,
                      otherUser.profilePic ?? "",
                      chatCubit,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(chatId, currentUser.id, otherUser.id, chatCubit),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isMe, String time, String messageId, String chatId, String userPic, ChatCubit chatCubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onLongPress: () => _showOptions(messageId, chatId, message, isMe, chatCubit),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe)
              CircleAvatar(backgroundImage: NetworkImage(userPic), radius: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xff44E18A) : const Color(0xffF2F7FB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(message, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                ),
                const SizedBox(height: 3),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(String messageId, String chatId, String oldMessage, bool isMe, ChatCubit chatCubit) {
    if (isMe) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Message Options'),
          content: const Text('Would you like to delete or edit this message?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                chatCubit.deleteMessage(chatId, messageId);
                Navigator.pop(ctx);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  editedMessageText = oldMessage;
                  editingMessageId = messageId;
                });
                Navigator.pop(ctx);
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMessageInput(String chatId, String senderId, String receiverId, ChatCubit chatCubit) {
    _controller.text = editedMessageText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
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
              if (editingMessageId != null) {
                chatCubit.editMessage(chatId, editingMessageId!, editedMessageText);
              } else {
                chatCubit.sendMessage(
                  chatId: chatId,
                  senderId: senderId,
                  receiverId: receiverId,
                  messageText: editedMessageText,
                );
              }
              _controller.clear();
              setState(() {
                editingMessageId = null;
                editedMessageText = '';
              });
            },
          )
        ],
      ),
    );
  }
}
