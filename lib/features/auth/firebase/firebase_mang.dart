import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseManager {
  static Future<void> login(String email, String password, Function onSuccess,
      Function onError) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.emailVerified) {
        onSuccess();
      } else {
        onError("verify your mail");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        onError("Wrong Mail Or Password");
      }
    }
  }

  static Future<void> creatAccount(String name, String phone, String email,
      String password, Function onSuccess, Function onError) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = UserModel(
          email: email, id: credential.user!.uid, name: name, phone: phone);
      credential.user?.sendEmailVerification();
      FirebaseAuth.instance.sendPasswordResetEmail(
        email: "email",
      ); //forget password
      addUserToFireStore(userModel);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError(e.message);
      } else if (e.code == 'email-already-in-use') {
        onError(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  // get user
  static CollectionReference<UserModel> getusercollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, _) {
        return UserModel.formJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addUserToFireStore(UserModel user) async {
    var collection = getusercollection();
    var docRef = collection.doc();
    user.id = docRef.id;
    docRef.set(user);
  }

  static Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Home screen after successful login
      if (userCredential.user != null) {
        GoRouter.of(context).pushReplacement(AppRoutes.homeRoute);
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
