  import 'package:flutter/material.dart';
  class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', width: 24, height: 24),
          onPressed: () {},
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
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
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jhon Abraham",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                Text("Active now", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Image.asset('assets/images/Call.png', width: 24, height: 24), onPressed: () {}),
          IconButton(icon: Image.asset('assets/Video.png', width: 24, height: 24), onPressed: () {}),

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
                  Center(child: Text("Today", style: TextStyle(color: Colors.grey))),
                  SizedBox(height: 50),
                  _buildMessageBubble("Hello! Jhon Abraham", true, "10:30 AM"),
                  _buildMessageBubble("Hello! Nazrul How are you?", false, "10:32 AM"),
                  _buildMessageBubble("You did your job well!", true, "10:35 AM"),
                  _buildMessageBubble("Have a great working week!!", false, "10:40 AM"),
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
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/jhon.png'),
              radius: 18,
            ),
            SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
            icon: Image.asset('assets/Attach.png', width: 24, height: 24),
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
            icon: Image.asset('assets/cameraa.png', width: 24, height: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset('assets/Mic.png', width: 24, height: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
