import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_states.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  bool isLoading = false;

  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);
  bool userExist = false;

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());
    isLoading = true;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.emailVerified) {

        emit(LoginSuccessState());
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(e.toString()));
      isLoading = false;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        throw Exception("Sign-in aborted by user");
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        GoRouter.of(context).pushReplacement(AppRoutes.homeRoute);
      }

      return userCredential;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      bool emailExists = await checkEmailExists(email.trim());
      if (emailExists == true) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        emit(ResetPasswordSuccessState());
      }
    } catch (e) {
      emit(ResetPasswordFaildState(e.toString()));
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      return documents.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> Logout() async {
    await FirebaseAuth.instance.signOut();
    emit(LogoutSuccessState());
  }

  void checkUserLoggedIn(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userExist = prefs.getBool('isLoggedIn') ?? false;
  }
}
