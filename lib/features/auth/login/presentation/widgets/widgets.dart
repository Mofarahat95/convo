import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildLoginOptions(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Checkbox(
            activeColor: AppColors.primary900,
            value: true,
            onChanged: (value) {},
          ),
          Text(
            "Stay logged in?",
            style: quicksand12(),
          ),
        ],
      ),
      TextButton(
        onPressed: () {
          GoRouter.of(context).push(AppRoutes.passwordResetRoute);
        }, // Forgot password logic
        child: Text("Forgot Password?", style: quicksand12()),
      ),
    ],
  );
}

Widget buildRegisterLink(BuildContext context) {
  return GestureDetector(
    onTap: () => GoRouter.of(context).push(AppRoutes.signUpRoute),
    child: const Text("Don't have an account? Register here"),
  );
}
