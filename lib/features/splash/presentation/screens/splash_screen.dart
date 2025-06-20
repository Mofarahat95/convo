import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/core/utils/assets_manager.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_cubit.dart';
import 'package:convo/features/splash/presentation/widgets/navigate_to.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateTo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(ImageAssets.logoImage)),
    );
  }
}
