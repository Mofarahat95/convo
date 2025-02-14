import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:convo/config/routes_manager/routes.dart';
import 'package:go_router/go_router.dart';

class firbaseeMang {
 // static get context => null;

  static Future<void> createAccount(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> login(String email, String password, Function onSuccess,
      Function onError) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }

  // Google Sign In
  static Future<UserCredential> signInWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // Check if the user canceled the sign-in process
      if (gUser == null) {
        throw Exception("Sign-in aborted by user");
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for the user
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      // Finally, let's sign in
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Home screen after successful login
      if (userCredential.user != null) {
        GoRouter.of( context).pushReplacement(AppRoutes.homeRoute);
        //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AppRoutes.homeRoute), // تأكد من تغيير HomePage إلى اسم الشاشة الرئيسية لديك;
      }

      return userCredential;
      // Finally, let's sign in
      //return await FirebaseAuth.instance.signInWithCredential(credential);

    } catch (e) {
      // Handle any errors that occur during sign-in
      print('Error during Google Sign-In: $e');
      rethrow;
    }
  }
}
