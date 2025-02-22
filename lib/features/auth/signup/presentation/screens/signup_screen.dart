import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/core/utils/values_manager.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (value.length < 10) return 'Enter a valid phone number';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 90, bottom: 30),
              child: Text('Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            height: context.screenHeight * .7,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40)),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  children: [
                    SizedBox(height: 40),
                    buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        hintText: 'Enter your name, e.g: John Doe',
                        validator: validateName),
                    buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'Enter your email, e.g: johndoe@gmail.com',
                        validator: validateEmail),
                    buildTextField(
                        controller: _phoneController,
                        label: 'Phone number',
                        hintText: 'Enter your Phone number: +0112*',
                        keyboardType: TextInputType.phone,
                        validator: validatePhone),
                    buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Enter your password, at least 8 character',
                        obscureText: true,
                        validator: validatePassword),
                    buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hintText: 'Enter your password, at least 8 character',
                        obscureText: true,
                        validator: validateConfirmPassword),
                    SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6D6A6A),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 130, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FirebaseManager.creatAccount(
                                _nameController.text,
                                _phoneController.text,
                                _emailController.text,
                                _passwordController.text,
                                () => GoRouter.of(context)
                                    .pushReplacement(AppRoutes.loginRoute),
                                () => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text('Registration failed'))));
                          }
                        },
                        child: Text('Register',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
