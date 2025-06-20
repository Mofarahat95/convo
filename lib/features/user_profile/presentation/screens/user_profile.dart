import 'package:convo/features/auth/signup/user_model.dart';
import 'package:convo/features/calls/presentation/screens/vedio_call.dart';
import 'package:convo/features/calls/presentation/screens/voice_call.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = GoRouterState.of(context).extra as UserModel;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 70),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(user.profilePic??""), // ضع صورتك هنا
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.name ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Web developer',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/micon.png'),
                        // ضع صورة الايقونة
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/video_call.png'),
                        // ضع صورة الايقونة
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ZegoVideoCall(
                                callid:
                                    "123456", // يجب تحديثها بناءً على الحالة
                                userid:
                                    '', // يجب تحديثها بناءً على المستخدم الحالي
                                otherUserId: user.id ?? "",
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/cicon.png'),
                        // ضع صورة الايقونة
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ZimVoiceCall(
                                callid:
                                    "1", // يجب تحديثها بناءً على الحالة
                                userid:
                                    "123", // يجب تحديثها بناءً على المستخدم الحالي
                                otherUserId:
                                    "456", // يجب تحديثها بناءً على المستخدم الآخر
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/more.png'),
                        // ضع صورة الايقونة
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Name', style: TextStyle(color: Colors.grey)),
                  Text(user.name ?? "",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Email Address', style: TextStyle(color: Colors.grey)),
                  Text(user.email ?? "",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Phone Number', style: TextStyle(color: Colors.grey)),
                  Text(user.phone ?? "",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Media Shared',
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      Text('View All',
                          style: TextStyle(color: Color(0xff20A090)))
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.network(user.profilePic,
                          width: 103, height: 80),
                      SizedBox(width: 10),
                      Image.asset('assets/images/facebook.png',
                          width: 103, height: 80),
                      SizedBox(width: 10),
                      Image.asset('assets/images/google.png',
                          width: 103, height: 80),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
