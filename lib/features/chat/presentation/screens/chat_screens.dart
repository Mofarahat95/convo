import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:convo/features/calls/presentation/screens/vedio_call.dart';
import 'package:convo/features/calls/presentation/screens/voice_call.dart';
import 'package:convo/config/routes_manager/routes.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String senderId = 'ghyk2SQeK72S3qo0xoQb'; // معرف المرسل
  String receiverId = 'rGJvoy4bHjAf7f2oSotE'; // معرف المستقبل
  String chatId =
      'ghyk2SQeK72S3qo0xoQb_rGJvoy4bHjAf7f2oSotE'; // المعرف الفريد للمحادثة
  TextEditingController _controller = TextEditingController();
  String? editingMessageId; // لتخزين معرف الرسالة التي نقوم بتعديلها
  String editedMessageText = ''; // لتخزين النص المعدل

  @override
  Widget build(BuildContext context) {
    var user = GoRouterState.of(context).extra as UserModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    GoRouter.of(context)
                        .push(AppRoutes.profileRoute, extra: user);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic??""),
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
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name??"",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Active now",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/Call.png', width: 24, height: 24),
            onPressed: () {
              // الانتقال إلى شاشة المكالمة الصوتية
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ZimVoiceCall(
                    callid: "123456", // يجب تحديثها بناءً على الحالة
                    userid: "456", // يجب تحديثها بناءً على المستخدم الحالي
                    otherUserId: "123", // يجب تحديثها بناءً على المستخدم الآخر
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Image.asset('assets/images/Video.png', width: 24, height: 24),
            onPressed: () {
              // الانتقال إلى شاشة المكالمة بالفيديو
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ZegoVideoCall(
                    callid: "123456", // يجب تحديثها بناءً على الحالة
                    userid: "456", // يجب تحديثها بناءً على المستخدم الحالي
                    otherUserId: "123", // يجب تحديثها بناءً على المستخدم الآخر
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId) // استخدام chatId الفريد للمحادثة
                    .collection('messages')
                    .orderBy('timestamp',
                        descending: true) // ترتيب الرسائل من الأحدث للأقدم
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    reverse: true, // عرض الرسائل الحديثة أولاً
                    itemCount: messages.length,
                    itemBuilder: (ctx, index) {
                      final message = messages[index];
                      final isMe =
                          message['senderId'] == senderId; // تحقق من المرسل
                      String messageId = message.id; // الحصول على معرف الرسالة
                      return _buildMessageBubble(
                        context,
                        message['message'],
                        isMe,
                        message['timestamp']
                            .toDate()
                            .toString()
                            .substring(11, 16),
                        messageId,
                        chatId,
                        user.profilePic??"",
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(chatId), // تمرير chatId إلى حقل الإدخال
          ],
        ),
      ),
    );
  }

  // دالة بناء فقاعة الرسالة
  Widget _buildMessageBubble(BuildContext context, String message, bool isMe,
      String time, String messageId, String chatId, String userPic) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onLongPress: () => _showOptions(context, messageId, chatId, message,
            isMe), // التعامل مع الضغط المطول
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe) ...[
              CircleAvatar(
                backgroundImage: NetworkImage(userPic),
                radius: 18,
              ),
              SizedBox(width: 8),
            ],
            Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? Color(0xff44E18A) : Color(0xffF2F7FB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // دالة عرض خيارات "حذف" و "تعديل" عند الضغط المطول
  void _showOptions(BuildContext context, String messageId, String chatId,
      String oldMessage, bool isMe) {
    if (isMe) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Message Options'),
          content: Text(
            'Would you like to delete or edit this message?',
            style: TextStyle(color: Colors.black), // جعل النص أسود
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _deleteMessage(messageId, chatId);
                Navigator.of(ctx).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _editMessage(context, messageId, chatId, oldMessage);
                Navigator.of(ctx).pop();
              },
              child: Text('Edit', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }
  }

  // دالة حذف الرسالة من Firestore
  void _deleteMessage(String messageId, String chatId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId) // استخدام messageId لحذف الرسالة المحددة
        .delete()
        .then((_) {
      print("Message deleted successfully");
    }).catchError((error) {
      print("Failed to delete message: $error");
    });
  }

  // دالة التعديل على الرسالة
  void _editMessage(BuildContext context, String messageId, String chatId,
      String oldMessage) {
    setState(() {
      editedMessageText = oldMessage; // تعيين النص القديم في حقل التعديل
      editingMessageId = messageId; // حفظ معرف الرسالة
    });
  }

  // دالة إدخال الرسالة المعدلة
  Widget _buildMessageInput(String chatId) {
    _controller.text = editedMessageText; // تعيين النص المعدل في الـ TextField

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.black),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Write your message",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                editedMessageText = value;
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.black),
            onPressed: () {
              if (editingMessageId != null) {
                _updateMessage(editingMessageId!, chatId, editedMessageText);
              } else {
                sendMessage(editedMessageText, chatId);
              }
              _controller.clear(); // مسح الحقل بعد الإرسال
              setState(() {
                editedMessageText = ''; // إعادة تعيين النص المعدل
              });
            },
          ),
        ],
      ),
    );
  }

  // دالة لتحديث الرسالة في Firestore
  void _updateMessage(String messageId, String chatId, String newMessage) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId) // استخدام messageId لتحديد الرسالة
        .update({
      'message': newMessage, // تحديث الرسالة
      'timestamp': FieldValue.serverTimestamp(), // تحديث الوقت
    }).then((_) {
      print("Message updated successfully");
    }).catchError((error) {
      print("Failed to update message: $error");
    });
  }

  // دالة إرسال الرسالة
  void sendMessage(String messageText, String chatId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': 'ghyk2SQeK72S3qo0xoQb', // معرف المرسل
      'receiverId': 'rGJvoy4bHjAf7f2oSotE', // معرف المستقبل
      'message': messageText, // نص الرسالة
      'timestamp': FieldValue.serverTimestamp(), // الوقت
    });
  }
}
