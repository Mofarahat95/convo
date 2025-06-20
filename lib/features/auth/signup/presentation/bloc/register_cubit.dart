import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/auth/signup/presentation/bloc/register_states.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  DateTime selectedBirthday = DateTime.now();
  bool isBirthdaySelected = false;

  Future<void> createAccount(
      String name,
      int birthday,
      String email,
      String phone,
      String password,
      ) async {
    emit(RegisterLoadingState());
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
        email: email,
        birthday: birthday,
        id: credential.user!.uid,
        name: name,
        phone: phone,
        token: "",
        profilePic: 'https://www.pngmart.com/files/23/Profile-PNG-Photo.png',
      );

      credential.user?.sendEmailVerification();
      await addUserToFireStore(userModel);
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(RegisterErrorState(e.toString()));
    } catch (e) {
      emit(RegisterErrorState(e.toString()));
    }
  }

  CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, _) =>
          UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
  }

  Future<void> addUserToFireStore(UserModel user) async {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    await docRef.set(user);
  }

  void updateBirthDate(DateTime? birthday) {
    if (birthday != null) {
      selectedBirthday = birthday;
      isBirthdaySelected = true;
      emit(BirthdayUpdateState());
    }
  }
}
