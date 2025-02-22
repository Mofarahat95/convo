import 'package:convo/core/utils/values_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SuccessScreen.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset(BuildContext context) async {
    // تحقق ما إذا كان البريد الإلكتروني موجودًا في Firestore
    bool emailExists =
        await checkIfEmailExists(emailController.text.trim()); // تعديل هنا

    if (!emailExists) {
      // عرض رسالة توضح أن البريد الإلكتروني غير موجود
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Email does not exist in the app."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return SuccessScreen();
        }),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(e.message.toString()),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('Users') // اسم المجموعة التي تخزن بيانات المستخدمين
          .where('email',
              isEqualTo:
                  email) // افترض أنك تخزن البريد الإلكتروني تحت الحقل 'email'
          .limit(1)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      return documents.isNotEmpty;
    } catch (e) {
      print("Error checking email existence: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Expanded(
            child: Center(
                child: Image.asset(
              'assets/images/wightLogo.png',
              height: 270,
            )),
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
                    style: GoogleFonts.quicksand(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'Enter your registered email below',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(right: 240),
                  child: const Text(
                    'Email address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: Colors.black87, fontSize: 15),
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
                      passwordReset(context); // تمرير الـ context هنا
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
        ],
      ),
    );
  }
}
