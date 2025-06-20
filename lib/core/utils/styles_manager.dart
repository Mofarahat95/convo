import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/fonts_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Roboto Font Styles

TextStyle roboto30({Color color = Colors.black}) {
  return GoogleFonts.roboto(
    fontSize: FontSize.s30,
    fontWeight: FontWeightManager.bold,
    color: color,
  );
}

TextStyle roboto25({Color color = Colors.black}) {
  return GoogleFonts.roboto(
    fontSize: FontSize.s25,
    fontWeight: FontWeightManager.smaiBold,
    color: color,
  );
}

TextStyle roboto20({Color color = Colors.black}) {
  return GoogleFonts.roboto(
    fontSize: FontSize.s20,
    fontWeight: FontWeightManager.medium,
    color: color,
  );
}

TextStyle roboto16({Color color = Colors.black}) {
  return GoogleFonts.roboto(
    fontSize: FontSize.s16,
    fontWeight: FontWeightManager.normal,
    color: color,
  );
}

TextStyle roboto13({Color color = Colors.black}) {
  return GoogleFonts.roboto(
    fontSize: FontSize.s13,
    fontWeight: FontWeightManager.light,
    color: color,
  );
}

// Quicksand Font Styles
TextStyle quicksand35({Color color = AppColors.white}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s35,
    fontWeight: FontWeightManager.bold,
    color: color,
  );
}

TextStyle quicksand28({Color color = Colors.black}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s28,
    fontWeight: FontWeightManager.smaiBold,
    color: color,
  );
}
TextStyle quicksand24({Color color = AppColors.white}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s24,
    fontWeight: FontWeightManager.smaiBold,
    color: color,
  );
}

TextStyle quicksand20({Color color = AppColors.white}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s20,
    fontWeight: FontWeightManager.smaiBold,
    color: color,
  );
}

TextStyle quicksand18({Color color = AppColors.white}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s18,
    fontWeight: FontWeightManager.bold,
    color: color,
  );
}

TextStyle quicksand14({Color color = AppColors.white}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s14,
    fontWeight: FontWeightManager.normal,
    color: color,
  );
}

TextStyle quicksand13({Color color = AppColors.primary950}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s13,
    fontWeight: FontWeightManager.normal,
    color: color,
  );
}
TextStyle quicksand30({Color color = AppColors.primary950}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s30,
    fontWeight: FontWeightManager.bold,
    color: color,
  );
}
TextStyle quicksand12({Color color = AppColors.primary950}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s12,
    fontWeight: FontWeightManager.light,
    color: color,
  );
}

TextStyle quicksand10({Color color = Colors.black}) {
  return GoogleFonts.quicksand(
    fontSize: FontSize.s10,
    fontWeight: FontWeightManager.light,
    color: color,
  );
}
