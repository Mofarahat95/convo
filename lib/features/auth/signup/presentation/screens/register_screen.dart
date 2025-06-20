import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/strings_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/core/utils/values_manager.dart';
import 'package:convo/features/auth/login/presentation/widgets/error_dialog.dart';
import 'package:convo/features/auth/signup/presentation/bloc/register_cubit.dart';
import 'package:convo/features/auth/signup/presentation/bloc/register_states.dart';
import 'package:convo/features/auth/signup/presentation/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (contxt, state) {
          if (state is RegisterLoadingState) {
            Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is RegisterSuccessState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text(
                      "successRegister",
                      style: quicksand18(),
                    ),
                    backgroundColor: AppColors.primary600,
                    duration: Duration(seconds: 2),
                  ),
                )
                .closed
                .then((_) {
              GoRouter.of(context).pushReplacement(AppRoutes.loginRoute);
            });
          }
          if (state is RegisterErrorState) {
            showErrorDialog(context, state.error);
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: AppColors.primary950,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: AppSize.s30),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 90, bottom: 30),
                  child: Text(
                    AppStrings.register,
                    style: quicksand35(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                    color: AppColors.white,
                  ),
                  child: RegisterForm(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
