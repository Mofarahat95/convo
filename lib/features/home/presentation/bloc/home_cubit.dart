import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:convo/features/home/presentation/bloc/home_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserModel? currentUser;
  List<String> chatIds = [];
  Map<String, UserModel> chatPartners = {};// الطرف التاني من كل شات

  Future<void> getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not signed in");

      final doc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      if (doc.exists) {
        currentUser = UserModel.fromJson(doc.data()!..addAll({'id': user.uid}));
        emit(HomeUserLoadedState(currentUser!));

        await getUserChats();
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      print("❌ Error: $e");
      emit(HomeUserErrorState(e.toString()));
    }
  }

  Future<void> getUserChats() async {
    try {
      final uid = currentUser!.id;
      final snapshot = await FirebaseFirestore.instance.collection('chats').get();

      chatIds = snapshot.docs
          .map((doc) => doc.id)
          .where((id) => id.contains(uid))
          .toList();

      await getChatPartners();
    } catch (e) {
      print("❌ Failed to fetch chat IDs: $e");
    }
  }


  Future<void> getChatPartners() async {
    final uid = currentUser!.id;
    for (var chatId in chatIds) {
      final otherUid = extractOtherUserId(chatId, uid);
      if (!chatPartners.containsKey(otherUid)) {
        final doc = await FirebaseFirestore.instance.collection('Users').doc(otherUid).get();
        if (doc.exists) {
          chatPartners[otherUid] = UserModel.fromJson(doc.data()!..addAll({'id': otherUid}));
        }
      }
    }
    emit(HomeChatsLoadedState(chatPartners));
  }

  String extractOtherUserId(String chatId, String currentUserId) {
    List<String> parts = chatId.split('_');
    return parts.first == currentUserId ? parts.last : parts.first;
  }


}

// Create state class for loaded chats
