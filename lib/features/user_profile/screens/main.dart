import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfileScreen(),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    backgroundImage: AssetImage('assets/user_profile.png'), // ضع صورتك هنا
                  ),
                  SizedBox(height:10),
                  Text(
                    'Jhon Abraham',
                    style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '@jhonabraham',
                    style: TextStyle(color: Colors.grey, fontSize:13),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/message.png'), // ضع صورة الايقونة
                        onPressed: () {},
                      ),

                      SizedBox(width: 20,),
                      IconButton(
                        icon: Image.asset('assets/video_call.png'), // ضع صورة الايقونة
                        onPressed: () {},
                      ), SizedBox(width: 20,),
                      IconButton(
                        icon: Image.asset('assets/call.png'), // ضع صورة الايقونة
                        onPressed: () {},
                      ),SizedBox(width: 20,),
                      IconButton(
                        icon: Image.asset('assets/more.png'), // ضع صورة الايقونة
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(   height: 10),
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
                  Text('Jhon Abraham', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Email Address', style: TextStyle(color: Colors.grey)),
                  Text('jhonabraham20@gmail.com', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Address', style: TextStyle(color: Colors.grey)),
                  Text('33 street west subidbazar, sylhet', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Phone Number', style: TextStyle(color: Colors.grey)),
                  Text('(320) 555-0104', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Media Shared', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      Text('View All', style: TextStyle(color: Color(0xff20A090))
                      )],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset('assets/image.png', width:103,height: 80),
                      SizedBox(width: 10),
                      Image.asset('assets/image2.png', width: 103,height: 80),
                      SizedBox(width: 10),
                      Image.asset('assets/image3.png', width: 103,height: 80),
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
