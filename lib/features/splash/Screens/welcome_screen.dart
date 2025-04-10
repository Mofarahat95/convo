import 'package:convo/core/utils/assets_manager.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/strings_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/core/utils/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes_manager/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPading.p25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.welcomeImage,
            ),
            Image.asset(
              ImageAssets.logoImage,
            ),
            Text(
              AppStrings.welcomeTagline,
              style: quicksand35(color: AppColors.primary950),
            ),
            const SizedBox(height: 5),
            Text(
             AppStrings.welcomeDescription,
              textAlign: TextAlign.center,
              style: quicksand18(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push(AppRoutes.loginRoute);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(55),
                backgroundColor: AppColors.primary800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                AppStrings.startButton,
                style: quicksand20(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
