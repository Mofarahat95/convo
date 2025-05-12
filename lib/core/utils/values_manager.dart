import 'package:flutter/material.dart';

abstract class AppMargin {
  static const double m5 = 5.0;
  static const double m8 = 8.0;
  static const double m12 = 12.0;
  static const double m14 = 14.0;
  static const double m16 = 16.0;
  static const double m18 = 18.0;
  static const double m20 = 20.0;
  static const double m25 = 25.0;
}

abstract class AppPading {
  static const double p5 = 5.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p14 = 14.0;
  static const double p16 = 16.0;
  static const double p18 = 18.0;
  static const double p20 = 20.0;
  static const double p25 = 25.0;
}

abstract class AppSize {
  static const double s0 = 0;
  static const double s0_5 = 0.5;
  static const double s1 = 1.0;
  static const double s2 = 2.0;
  static const double s3 = 3.0;
  static const double s4 = 4.0;
  static const double s5 = 5.0;
  static const double s6 = 6.0;
  static const double s7 = 7.0;
  static const double s8 = 8.0;
  static const double s9 = 9.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s22 = 22.0;
  static const double s24 = 24.0;
  static const double s26 = 26.0;
  static const double s30 = 30.0;
  static const double s34 = 34.0;
  static const double s38 = 38.0;
}
extension vaidate on String{
  bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))'
        r'@((\[[0-9]{1,3}\.[0-9]{1,3}\'
        r'.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  bool isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }
  bool isValidName(String name) {
    return name.isNotEmpty && name.length > 2;
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^01[0-9]\d{8}$').hasMatch(phone);
  }
}
extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;
}
