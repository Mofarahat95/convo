// user_profile_cubit.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:convo/features/user_profile/presentation/bloc/user_profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../home/presentation/bloc/home_cubit.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());
  static UserProfileCubit get(context) => BlocProvider.of(context);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadProfileImage(context) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      emit(UserProfileLoading());

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final file = File(pickedFile.path);
      final ref = FirebaseStorage.instance.ref().child('profile_images/${user.uid}.jpg');
      await ref.putFile(file);

      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'profilePic': imageUrl,
      });

      await HomeCubit.get(context).getCurrentUser();

      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      emit(UserProfileLoaded(userDoc.data()!));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}