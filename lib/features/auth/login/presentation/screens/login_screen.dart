import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/login/presentation/widgets/social_buttons.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:convo/features/auth/firebase/firebase_mang.dart';

class LoginScreenConstants {
  static const double borderRadius = 40.0;
  static const double padding = 20.0;
  static const Color primaryColor = Color(0xff6D6A6A);
  static const TextStyle headerStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _stayLoggedIn = false;
  bool _isLoading = false;
  String selectedLanguage = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Text(
                      "Login Account",
                      style: LoginScreenConstants.headerStyle,
                    ),
                    Image.asset('assets/images/User.png', width: 40),
                    const Spacer(),
                    Image.asset('assets/images/egypt.png', width: 30),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() => selectedLanguage = value);
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 30,
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'English',
                          child: Text('English'),
                        ),
                        const PopupMenuItem(
                          value: 'Arabic',
                          child: Text('العربية'),
                        ),
                      ],
                    )
                  ],
                ),
                const Text(
                  "Welcome back To Application",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    "Login",
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(LoginScreenConstants.borderRadius),
                  topLeft: Radius.circular(LoginScreenConstants.borderRadius),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: LoginScreenConstants.padding,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _stayLoggedIn,
                              onChanged: (value) {
                                setState(() => _stayLoggedIn = value ?? false);
                              },
                            ),
                            const Text(
                              "Stay logged in?",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);
                                  await FirebaseManager.login(
                                    _emailController.text,
                                    _passwordController.text,
                                    () {
                                      GoRouter.of(context)
                                          .go(AppRoutes.homeRoute);
                                    },
                                    (message) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => AlertDialog(
                                          title: Text("Error"),
                                          content: Text(message),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                GoRouter.of(context).pop();
                                              },
                                              child: Text("Okay"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  setState(() => _isLoading = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LoginScreenConstants.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(AppRoutes.signUpRoute);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account yet? Register",
                            style: GoogleFonts.quicksand(color: Colors.black),
                            children: const [
                              TextSpan(
                                text: " here",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            endIndent: 5,
                            indent: 10,
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 20,
                          ),
                          child: Text(
                            'Or login with',
                            style: GoogleFonts.quicksand(
                              color: Colors.grey,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            endIndent: 5,
                            indent: 10,
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    buildSocialLoginButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
