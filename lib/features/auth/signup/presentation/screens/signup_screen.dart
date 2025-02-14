import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/firebase/firebase_mang.dart';
import 'package:convo/features/auth/login/presentation/widgets/social_buttons.dart';
import 'package:convo/features/auth/signup/presentation/widgets/custom_textfield.dart';
import 'package:convo/features/auth/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 90, bottom: 30),
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      hintText: 'Enter your name, e.g: John Doe',
                    ),
                    SizedBox(height: 10),
                    buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email, e.g: johndoe@gmail.com',
                    ),
                    SizedBox(height: 10),
                    buildTextField(
                      controller: _phoneController,
                      label: 'Phone number',
                      hintText: 'Enter your Phone number: +0112*',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
                    buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Enter your password, at least 8 character',
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: 'Enter your password, at least 8 character',
                      obscureText: true,
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6D6A6A),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 130, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {
                          // Add your registration logic here
                        },
                        child: GestureDetector(
                          onTap: () {
                            FirebaseManager.creatAccount(
                                _nameController.text,
                                _phoneController.text,
                                _emailController.text,
                                _passwordController.text,
                                () {},
                                () {});
                            GoRouter.of(context)
                                .pushReplacement(AppRoutes.loginRoute);
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    buildSocialLoginButtons(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
