import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;

  const SocialIcon({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Image.asset(
          imagePath,
          height: 50,
        ),
      ),
    );
  }
}
