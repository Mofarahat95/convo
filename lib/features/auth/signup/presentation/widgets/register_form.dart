import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/strings_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/features/auth/signup/presentation/bloc/register_cubit.dart';
import 'package:convo/features/auth/signup/presentation/widgets/custom_barthdate_picker.dart';
import 'package:convo/features/auth/signup/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            buildTextField(
              controller: _nameController,
              label: 'Name',
              hintText: 'Enter your name, e.g: John Doe',
              validationType: 'name',
            ),
            /*buildTextField(
              controller: _confirmPasswordController,
              label: 'Birth Day',
              hintText: 'Enter your password, at least 8 character',
              obscureText: true,
              validationType: 'confirmPassword',
            ),*/
            CustomBarthDatePicker(),
            buildTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter your email, e.g: johndoe@gmail.com',
              validationType: 'email',
            ),
            buildTextField(
              controller: _phoneController,
              label: 'Phone number',
              hintText: 'Enter your Phone number: +0112*',
              keyboardType: TextInputType.phone,
              validationType: 'phone',
            ),
            buildTextField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password, at least 8 character',
              obscureText: true,
              validationType: 'password',
            ),
            buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hintText: 'Enter your password, at least 8 character',
              obscureText: true,
              validationType: 'confirmPassword',
            ),
            SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary800,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final _birthDayController = RegisterCubit.get(context)
                        .selectedBirthday
                        .millisecondsSinceEpoch;
                    print(_birthDayController);
                    RegisterCubit.get(context).createAccount(
                      _nameController.text,
                      _birthDayController,
                      _emailController.text,
                      _phoneController.text,
                      _passwordController.text,
                    );
                  }
                },
                child: Text(AppStrings.register, style: quicksand18()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
