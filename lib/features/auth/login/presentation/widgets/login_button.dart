import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/strings_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/core/utils/values_manager.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_cubit.dart';
import 'package:flutter/material.dart';

Widget buildLoginButton(
    {required BuildContext context, required Function() onLogin}) {
  return SizedBox(
    width: context.screenHeight * 0.7,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: AppColors.primary700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      onPressed: onLogin,
      child: LoginCubit.get(context).isLoading
          ? const CircularProgressIndicator(color: AppColors.white)
          : Text(
              AppStrings.login,
              style: quicksand18(),
            ),
    ),
  );
}
