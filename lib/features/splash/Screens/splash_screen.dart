import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes_manager/routes.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // صورة الهاتف مع الرسائل
          Padding(
            padding: const EdgeInsets.only(top:  30, ),
            child: Image.asset(
              'assets/images/Chat.png', // تأكد من وجود الصورة في assets
              height: 300,

            ),
          ),

          // الشعار
          Image.asset(
            'assets/images/logo.png', // تأكد من وضع اللوجو الصحيح في assets
            height: 200,
          ),

          const SizedBox(height: 2),

          // اسم التطبيق


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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      onPressed: () {
                        GoRouter.of(context).push(AppRoutes.loginRoute);

                      },
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

                const SizedBox(width: 30),

                // زر التسجيل
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).push(AppRoutes.signUpRoute);
                  },
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
          const SizedBox(height: 40,),
        ],
      ),
    );
  }
}
