import 'package:convo/core/utils/assets_manager.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/features/auth/login/presentation/widgets/social_icon.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_cubit.dart';
import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(
                thickness: 1,
                color: AppColors.primary100,
                indent: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Or login with",
                style: quicksand13(),
              ),
            ),
            const Expanded(
                child: Divider(
              thickness: 1,
              color: AppColors.primary100,
              endIndent: 15,
            )),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          spacing: 20,
          children: [
            SizedBox(width: 90),
            SocialIcon(
              imagePath: ImageAssets.appleIcon,
              onTap: () {},
            ),
            SocialIcon(
              imagePath: ImageAssets.facebookIcon,
              onTap: () {
                LoginCubit.get(context).signInWithFacebook();
              },
            ),
            SocialIcon(
              imagePath: ImageAssets.googleIcon,
              onTap: () {
                LoginCubit.get(context).signInWithFacebook();
              },
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
