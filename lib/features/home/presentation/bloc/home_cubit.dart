import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/auth/signup/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_states.dart';
import '../../../chat/presentation/bloc/chat_cubit.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserModel? currentUser;
  List<String> chatIds = [];
  Map<String, UserModel> chatPartners = {};
  Map<String, String> lastMessages = {}; // <chatId, lastDecryptedMessage>

  Future<void> getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not signed in");

      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        currentUser = UserModel.fromJson(doc.data()!..addAll({'id': user.uid}));
        emit(HomeUserLoadedState(currentUser!));
        await getUserChats();
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      print("❌ Error getting user: $e");
      emit(HomeUserErrorState(e.toString()));
    }
  }

  Future<void> getUserChats() async {
    try {
      final uid = currentUser!.id;
      final snapshot = await FirebaseFirestore.instance.collection('chats').get();

      chatIds = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['senderId'] == uid || data['receiverId'] == uid;
      }).map((doc) => doc.id).toList();

      await getChatPartners();
      await fetchLastMessages(); // 🔥 نجلب آخر رسالة هنا
    } catch (e) {
      print("❌ Failed to fetch chats: $e");
      emit(HomeUserErrorState(e.toString()));
    }
  }

  Future<void> fetchLastMessages() async {
    try {
      for (var chatId in chatIds) {
        final messages = await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (messages.docs.isNotEmpty) {
          final msg = messages.docs.first.data();
          final String rawMessage = msg['message'] ?? '';
          final bool isEncrypted = msg['isEncrypted'] == true;
          final bool isVoice = msg['isVoice'] == true;

          if (isVoice) {
            lastMessages[chatId] = "[🎤 Voice]";
          } else if (rawMessage.startsWith("https://")) {
            lastMessages[chatId] = "[📷 Image]";
          } else if (isEncrypted) {
            lastMessages[chatId] = decryptMessage(rawMessage);
          } else {
            lastMessages[chatId] = rawMessage;
          }
        }
      }

      emit(HomeChatsUpdatedWithLastMessagesState());
    } catch (e) {
      print("❌ Error getting last messages: $e");
    }
  }

  String decryptMessage(String encryptedText) {
    return ChatCubit().decryptMessage(encryptedText);
  }

  Future<void> getChatPartners() async {
    try {
      final uid = currentUser!.id;
      for (var chatId in chatIds) {
        final otherUid = extractOtherUserId(chatId, uid);
        if (!chatPartners.containsKey(otherUid)) {
          final doc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(otherUid)
              .get();
          if (doc.exists) {
            chatPartners[otherUid] =
                UserModel.fromJson(doc.data()!..addAll({'id': otherUid}));
          }
        }
      }
      emit(HomeChatsLoadedState(chatPartners));
    } catch (e) {
      print("❌ Error getting chat partners: $e");
      emit(HomeUserErrorState(e.toString()));
    }
  }

  String extractOtherUserId(String chatId, String currentUserId) {
    final parts = chatId.split('_');
    return parts.first == currentUserId ? parts.last : parts.first;
  }

  // get active stories
  Stream<List<Map<String, dynamic>>> getActiveStories() {
    final now = DateTime.now();
    return FirebaseFirestore.instance
        .collection('Status')
        .where('expireDate', isGreaterThan: now)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  // update views
  Future<void> updateStoryViews(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Status')
          .doc(userId)
          .update({
        'views': FieldValue.arrayUnion([currentUser!.id])
      });
    } catch (e) {
      print("❌ Error updating views: $e");
    }
  }

  List<UserModel> filteredContacts = [];
  List<Map<String, dynamic>> filteredMessages = [];

  Future<void> filterChatsAndMessages(String query) async {
    final normalizedQuery = query.toLowerCase();

    // فلترة جهات الاتصال
    filteredContacts = chatPartners.values.where((contact) {
      return contact.name.toLowerCase().contains(normalizedQuery) ||
          contact.phone.contains(normalizedQuery);
    }).toList();

    filteredMessages.clear();

    if (query.trim().isEmpty) {
      emit(HomeChatsFilteredState());
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collectionGroup('messages')
          .where('message', isGreaterThanOrEqualTo: query)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final messageText = (data['message'] ?? '').toString().toLowerCase();
        if (messageText.contains(normalizedQuery)) {
          final chatId = doc.reference.parent.parent!.id;

          if (chatIds.contains(chatId)) {
            filteredMessages.add({
              'chatId': chatId,
              'message': data['message'],
              'senderId': data['senderId'],
              'timestamp': data['timestamp'],
            });
          }
        }
      }

      emit(HomeChatsFilteredState());
    } catch (e) {
      print("❌ Error filtering messages: $e");
    }
  }
  void removeChat(String chatId) {
    chatIds.remove(chatId);
    chatPartners.removeWhere((key, value) => chatId.contains(value.id));
    emit(UpdateChatsState());
  }

}
