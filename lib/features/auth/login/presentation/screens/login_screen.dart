import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/features/auth/login/presentation/widgets/login_button.dart';
import 'package:convo/features/auth/login/presentation/widgets/social_button.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_cubit.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_states.dart';
import 'package:convo/features/auth/login/presentation/widgets/error_dialog.dart';
import 'package:convo/features/auth/login/presentation/widgets/login_header_widget.dart';
import 'package:convo/features/auth/login/presentation/widgets/widgets.dart';
import 'package:convo/features/auth/signup/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoginSuccessState) {
            GoRouter.of(context).go(AppRoutes.homeRoute);
          }
          if (state is LoginErrorState) {
            showErrorDialog(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.primary950,
            body: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                buildLoginHeader(),
                Expanded(
                    child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 4),
                        buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          hintText: 'Enter your email',
                          validationType: 'email',
                        ),
                        buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: true,
                          hintText: 'Enter your password',
                          validationType: 'password',
                        ),
                        buildLoginOptions(context),
                        buildLoginButton(
                          context: context,
                          onLogin: () {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        buildRegisterLink(context),
                        const SizedBox(height: 10),
                        SocialButtons(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
