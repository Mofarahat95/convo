import 'package:flutter/material.dart';

Widget buildSocialLoginButtons() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 70),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        socialLoginButton("assets/images/apple.png", () {}),
        socialLoginButton("assets/images/google.png", () {}),
        socialLoginButton("assets/images/facebook.png", () {}),
      ],
    ),
  );
}

Widget socialLoginButton(String asset, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Image.asset(asset),
  );
}