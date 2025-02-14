import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // صورة الهاتف مع الرسائل
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Image.asset(
              'images/illustration_Chat_.jpg', // تأكد من وجود الصورة في assets
              height: 250,
            ),
          ),

          // الشعار
          Image.asset(
            'assets/convo_logo.png', // تأكد من وضع اللوجو الصحيح في assets
            height: 50,
          ),

          const SizedBox(height: 10),

          // اسم التطبيق
          const Text(
            "CONVO",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          // العنوان الرئيسي
          const Text(
            "Chat with ease",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 5),

          // الوصف
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Stay connected with friends and family anytime, anywhere",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // أزرار تسجيل الدخول والتسجيل
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // زر تسجيل الدخول
                Expanded(
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(1, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // زر التسجيل
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
