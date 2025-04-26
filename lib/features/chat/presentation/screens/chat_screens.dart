import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/calls/presentation/screens/vedio_call.dart';
import 'package:convo/features/calls/presentation/screens/voice_call.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: (){
                    GoRouter.of(context).push(AppRoutes.profileRoute);
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/mo.png'),
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
                    "Mohamed Farahat",
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
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Center(
                      child:
                      Text("Today", style: TextStyle(color: Colors.grey))),
                  SizedBox(height: 50),
                  _buildMessageBubble("Hello! Jhon Abraham", true, "10:30 AM"),
                  _buildMessageBubble(
                      "Hello! Nazrul How are you?", false, "10:32 AM"),
                  _buildMessageBubble(
                      "You did your job well!", true, "10:35 AM"),
                  _buildMessageBubble(
                      "Have a great working week!!", false, "10:40 AM"),
                  _buildMessageBubble("Hope you like it", false, "10:45 AM"),
                  _buildAudioMessage("00:16", "10:50 AM"),
                  _buildMessageBubble("done", false, "10:52 AM"),
                ],
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isMe, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/mo.png'),
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
    );
  }

  Widget _buildAudioMessage(String duration, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 180,
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xff44E18A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white),
                  SizedBox(width: 5),
                  Text(duration, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 3),
            Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon:
            Image.asset('assets/images/Attach.png', width: 24, height: 24),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Write your message",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon:
            Image.asset('assets/images/cameraa.png', width: 24, height: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset('assets/images/Mic.png', width: 24, height: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}