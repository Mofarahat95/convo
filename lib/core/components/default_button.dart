import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/core/utils/values_manager.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.onTab,
  });

  final Function() onTab;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenHeight * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.primary700,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: onTab,
        child: Text(text,style: quicksand18(),),
      ),
    );
    ;
  }
}
