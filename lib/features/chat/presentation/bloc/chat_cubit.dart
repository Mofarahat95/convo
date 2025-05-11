import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:convo/features/chat/presentation/bloc/chat_states.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  Stream<QuerySnapshot>? _cachedStream;

  String generateChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  Stream<QuerySnapshot> listenToMessages(String chatId) {
    _cachedStream ??= FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return _cachedStream!;
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String messageText,
  }) async {
    try {
      final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

      // ✅ أنشئ وثيقة الشات وسجل senderId و receiverId لو مش موجودة
      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        await chatRef.set({
          'senderId': senderId,
          'receiverId': receiverId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await chatRef.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(ChatMessageSentState());
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  Future<void> deleteMessage(String chatId, String messageId, String currentUserId) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists && docSnapshot.data()?['senderId'] == currentUserId) {
        await docRef.delete();
        emit(ChatMessageDeletedState());
      } else {
        emit(ChatErrorState("⚠️ You can only delete your own messages."));
      }
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  Future<void> editMessage(String chatId, String messageId, String newMessage) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
        'message': newMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(ChatMessageEditedState());
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }
}