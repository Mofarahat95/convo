import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void navigateTo(BuildContext context) {
  LoginCubit.get(context).checkUserLoggedIn(context);
  Future.delayed(
    Duration(seconds: 3),
    () {
      if (LoginCubit.get(context).userExist) {
        GoRouter.of(context).go(AppRoutes.homeRoute);
      } else {
        GoRouter.of(context).go(AppRoutes.onBoardingRoute);
      }
    },
  );
}
