import 'package:flutter/material.dart';

class SquareTite extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;

  const SquareTite({
    super.key,
    required this.imagePath,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10), // تقليل المسافة الجانبية
        child: Image.asset(
          imagePath,
          height: 60,  // تعديل الارتفاع حسب الحاجة
          width: 50,   // تحديد عرض ثابت
          fit: BoxFit.contain, // لضمان تناسب الصورة مع الحاوية
        ),
      ),
    );
  }}
