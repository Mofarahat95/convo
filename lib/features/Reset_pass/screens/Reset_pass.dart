import 'package:flutter/material.dart';
class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/Order Success.png',
                    width: 280,
                    height: 211,
                  ),
                  Image.asset(
                    'assets/images/icon _search status 1_.png',
                    width: 264,
                    height: 211,
                  ),
                  Positioned(
                    top: 35,
                    right: 35,
                    child: Image.asset(
                      'assets/images/icon _Paper Plane_.png',
                      width: 46,
                      height: 46,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: 375,
              height: 470,
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
                  const Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Enter your registered email below',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(right: 240),
                    child: const Text(
                      'Email address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff9CA3AF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
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
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Sign in',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 256,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff6D6A6A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
