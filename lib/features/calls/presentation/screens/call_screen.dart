import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../agora_call_screen.dart';

class CallScreen extends StatefulWidget {
  final String callerId;
  final String receiverId;
  final String channelId;
  final String token;

  const CallScreen({
    Key? key,
    required this.callerId,
    required this.receiverId,
    required this.channelId,
    required this.token,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final AudioPlayer player = AudioPlayer();
  late String callerName = "Unknown"; // Default caller name

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    playRingtone();
    getCallerInfo();
  }

  // تهيئة إشعارات Flutter
  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // تشغيل نغمة الرنين
  Future<void> playRingtone() async {
    await player.play(AssetSource('sounds/ringtone.mp3'), volume: 1.0);
    player.setReleaseMode(ReleaseMode.loop); // تشغيل الرنين بشكل متكرر
  }

  // إيقاف نغمة الرنين
  Future<void> stopRingtone() async {
    await player.stop();
  }

  // جلب معلومات المتصل من قاعدة البيانات
  Future<void> getCallerInfo() async {
    // يمكن تعديل هذه الطريقة لاسترجاع البيانات من Firestore
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.callerId).get();
    setState(() {
      callerName = userDoc['name'] ?? "Unknown";  // لو كانت البيانات غير موجودة هيبقى "Unknown"
    });
  }

  // إرسال إشعار للمستقبل عند استقبال المكالمة
  Future<void> showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'call_channel_id', // قناة الإشعار
      'Call Notifications', // اسم القناة
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('ringtone'),
    );
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,  // معرف الإشعار
      'Incoming Call',  // العنوان
      'From: $callerName',  // محتوى الإشعار
      generalNotificationDetails,
    );
  }

  // استجابة لرفض المكالمة
  Future<void> rejectCall() async {
    await stopRingtone();
    await FirebaseFirestore.instance.collection('calls').doc(widget.receiverId).update({
      'isCalling': false,
      'answered': false,
    });
    Navigator.pop(context);
  }

  // استجابة للرد على المكالمة
  Future<void> answerCall() async {
    await stopRingtone();
    await FirebaseFirestore.instance.collection('calls').doc(widget.receiverId).update({
      'isCalling': false,
      'answered': true,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AgoraCallScreen(
          channelId: widget.channelId,
          token: widget.token,
          uid: int.parse(widget.receiverId),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopRingtone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية ضبابية
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Image.asset(
                'lib/images/callImage.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // واجهة المكالمة
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/images/callImage.jpg'),
              ),
              const SizedBox(height: 10),
              Text(
                callerName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Incoming call',
                style: TextStyle(fontSize: 17, color: Colors.white70),
              ),
              const SizedBox(height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Icon(Icons.access_time, color: Colors.white, size: 30),
                      SizedBox(height: 5),
                      Text('Remind me', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(Icons.message, color: Colors.white, size: 30),
                      SizedBox(height: 5),
                      Text('Message', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: GestureDetector(
                  onHorizontalDragEnd: (details) async {
                    await answerCall();
                  },
                  child: Container(
                    width: 285,
                    height: 65,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.call, color: Colors.green, size: 25),
                        SizedBox(width: 35),
                        Text(
                          'Slide to answer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: GestureDetector(
                  onTap: () async {
                    await rejectCall();
                  },
                  child: Container(
                    width: 285,
                    height: 65,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.call_end, color: Colors.white, size: 25),
                        SizedBox(width: 35),
                        Text(
                          'Reject Call',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
