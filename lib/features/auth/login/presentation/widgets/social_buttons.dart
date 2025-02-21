import 'package:convo/features/auth/firebase/firebase_mang.dart';
import 'package:flutter/material.dart';

class buildSocialLoginButtons extends StatelessWidget {
  const buildSocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          socialLoginButton("assets/images/apple.png", () {}),
          socialLoginButton("assets/images/google.png", () {
            FirebaseManager.signInWithGoogle(context);
          }),
          socialLoginButton("assets/images/facebook.png", () {
            FirebaseManager.signInWithFacebook();
          }),
        ],
      ),
    );
  }
}

Widget socialLoginButton(String asset, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Image.asset(asset),
  );
}
