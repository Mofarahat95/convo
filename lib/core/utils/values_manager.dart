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
extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;
}
