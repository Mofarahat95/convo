import 'package:convo/core/utils/assets_manager.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/strings_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

Widget buildLoginHeader() {
  return Container(
    color: AppColors.primary950,
    padding: const EdgeInsets.all(25),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login Account",
                  style: quicksand24(),
                ),
                SizedBox(height: 5),
                Text(
                  "Welcome back Prohibit thank !",
                  style: quicksand13(color: AppColors.white),
                ),
              ],
            ),
            const Spacer(),
            //_buildLanguageDropdown(),
          ],
        ),
        const SizedBox(height: 50),
        Text(
          AppStrings.login,
          style: quicksand35(),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

/*Widget _buildLanguageDropdown() {
  return DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: "ar",
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      items: const [
        DropdownMenuItem(
          value: "ar",
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundImage: AssetImage(ImageAssets.egyptImage),
              ),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "en",
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundImage: AssetImage(ImageAssets.egyptImage),
              ),
            ],
          ),
        ),
      ],
      onChanged: (value) {},
    ),
  );
}*/
