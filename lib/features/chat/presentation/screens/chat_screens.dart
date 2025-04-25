import 'package:flutter/material.dart';
import 'package:convo/features/calls/presentation/screens/vedio_call.dart'; // تأكد من استيراد شاشة الاتصال بالفيديو
import 'package:convo/features/calls/presentation/screens/voice_call.dart'; // تأكد من استيراد شاشة الاتصال الصوتي

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildChatBody(),
    );
  }

  // App Bar with user info and call buttons
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          _buildUserAvatar(),
          const SizedBox(width: 10),
          _buildUserInfo(),
        ],
      ),
      actions: _buildAppBarActions(context),
    );
  }

  Widget _buildUserAvatar() {
    return Stack(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/jhon.png'),
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
    );
  }

  Widget _buildUserInfo() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Jhon Abraham",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Active now",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
      // Call Icon
      IconButton(
        icon: Image.asset('assets/images/Call.png', width: 24, height: 24),
        onPressed: () {
          // الانتقال إلى شاشة المكالمة الصوتية
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ZimVoiceCall(
                callid: "123456", // يجب تحديثها بناءً على الحالة
                userid: "123", // يجب تحديثها بناءً على المستخدم الحالي
                otherUserId: "456", // يجب تحديثها بناءً على المستخدم الآخر
              ),
            ),
          );
        },
      ),
      // Video Icon
      IconButton(
        icon: Image.asset('assets/images/Video.png', width: 24, height: 24),
        onPressed: () {
          // الانتقال إلى شاشة المكالمة بالفيديو
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ZegoVideoCall(
                callid: "123456", // يجب تحديثها بناءً على الحالة
                userid: "123", // يجب تحديثها بناءً على المستخدم الحالي
                otherUserId: "456", // يجب تحديثها بناءً على المستخدم الآخر
              ),
            ),
          );
        },
      ),
    ];
  }

  // Main chat body with messages and input field (تم حذف حقل الإدخال)
  Widget _buildChatBody() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          // لم نعد بحاجة إلى إدخال نص أو أي حقل آخر هنا
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: Text("Today", style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 50),
        _buildMessageBubble("Hello! Jhon Abraham", true, "10:30 AM"),
        _buildMessageBubble("Hello! Nazrul How are you?", false, "10:32 AM"),
        _buildMessageBubble("You did your job well!", true, "10:35 AM"),
        _buildMessageBubble("Have a great working week!!", false, "10:40 AM"),
        _buildMessageBubble("Hope you like it", false, "10:45 AM"),
        _buildAudioMessage("00:16", "10:50 AM"),
        _buildMessageBubble("done", false, "10:52 AM"),
      ],
    );
  }

  Widget _buildMessageBubble(String message, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/jhon.png'),
              radius: 18,
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xff44E18A) : const Color(0xffF2F7FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioMessage(String duration, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 180,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xff44E18A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.play_arrow, color: Colors.white),
                  SizedBox(width: 5),
                  Text("00:16", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
