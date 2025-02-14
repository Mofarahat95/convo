import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/auth/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseManager {

  static Future<void> login(String email, String password, Function onSuccess,
      Function onError) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      onSuccess();
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
    var docRef=collection.doc();
    user.id = docRef.id;
    docRef.set(user);
  }
}
