import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes_manager/routes.dart';
import '../../Reset_pass/screens/Reset_pass.dart';
class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Image.asset(
                    'assets/Order Success.png',
                    width: 280,
                    height: 211,
                    fit: BoxFit.contain,
                  ),


                  Positioned(
                    top: 60,
                    right: 80,
                    child: Image.asset(
                      'assets/images/Screenshot 2025-02-13 212313 1.png',
                      width: 125,
                      height: 126,
                    ),
                  ),
                ],
              ),
            ),
          ),


          Container(
            height: 450,
            width: 365,
            padding: const EdgeInsets.all(24),
            decoration:const  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const  SizedBox(height: 10),
                Text(
                  "Please check your email for create a new password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const  SizedBox(height: 40),
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
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
                const SizedBox(height: 170),
                SizedBox(
                  width: 256,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                          GoRouter.of(context).pushReplacement(AppRoutes.loginRoute);
                      //Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Color(0xff6D6A6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.white,fontSize: 16),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}