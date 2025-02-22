import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/core/utils/values_manager.dart';
import 'package:convo/features/auth/login/presentation/screens/Reset_pass.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 130),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background success image
                Image.asset(
                  'assets/images/OrdeSuccess.png',
                  width: MediaQuery.of(context).size.width *
                      0.8, // More responsive width
                  height: MediaQuery.of(context).size.height *
                      0.3, // More responsive height
                  fit: BoxFit.contain,
                ),
                // Email image overlay
                Positioned(
                  top: MediaQuery.of(context).size.height *
                      0.09, // Responsive positioning
                  right: MediaQuery.of(context).size.width *
                      0.25, // Responsive positioning
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/emailImage.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: context.screenHeight * .5,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Success",
                    style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please check your email for create a new password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ResetPasswordScreen();
                        }),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        children: [
                          TextSpan(text: "Can't get email? "),
                          TextSpan(
                            text: "Resubmit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 140),
                  SizedBox(
                    width: 256,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context)
                            .pushReplacement(AppRoutes.loginRoute);
                        //Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff6D6A6A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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
