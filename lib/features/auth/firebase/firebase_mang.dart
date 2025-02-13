import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class firbaseeMang {
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
  signInWithGoogle() async {
// begin interactive sign in process
final GoogleSignInAccount? gUser= await GoogleSignIn().signIn();
// obtaiin auth details from request
final GoogleSignInAuthentication gAuth = await gUser!.authentication;

// create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken, idToken: gAuth.idToken,);
// finally, lets sign in

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}