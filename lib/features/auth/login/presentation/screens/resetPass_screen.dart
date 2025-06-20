import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/core/components/default_button.dart';
import 'package:convo/core/utils/assets_manager.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/strings_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/core/utils/values_manager.dart';
import 'package:convo/features/auth/login/presentation/widgets/error_dialog.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_states.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is ResetPasswordSuccessState) {
            GoRouter.of(context).push(AppRoutes.successResetRoute);
          }
          if (state is ResetPasswordFaildState) {
            showErrorDialog(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.primary950,
            body: Column(
              children: [
                const SizedBox(height: 80),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      ImageAssets.resetImage,
                      height: 270,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: context.screenHeight * .55,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Reset Password',
                          style: quicksand30(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Enter your registered email below',
                          style: quicksand18(color: AppColors.primary200),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(right: 140),
                        child: Text(
                          'Email address',
                          style: quicksand20(color: AppColors.primary800),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Remember the password?',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DefaultButton(
                        text: AppStrings.submitButton,
                        onTab: () {
                          LoginCubit.get(context)
                              .resetPassword(_emailController.text);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
