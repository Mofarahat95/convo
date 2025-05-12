// chat_cubit.dart
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'chat_states.dart';

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
    bool isSensitive = false,
  }) async {
    try {
      final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
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
        'sensitive': isSensitive,
      });

      emit(ChatMessageSentState());
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }
//share media
  Future<void> pickAndUploadImage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required Function(String imageUrl, bool isSensitive) onUploaded,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) return;
      final file = File(pickedFile.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('chat_images/$fileName.jpg');

      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();

      final isSafe = await checkImageSafeContent(imageUrl);
      final isSensitive = !isSafe;

      onUploaded(imageUrl, isSensitive);
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  bool isImageMessage(String message) {
    return message.startsWith('https://') && message.contains('firebase');
  }

  final String apiKey = 'AIzaSyBgfY2Gv-AHExgm9S-y_EDUGN4r66wYB2I';
  Future<bool> checkImageSafeContent(String imageUrl) async {
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');

    final body = {
      "requests": [{
          "image": {"source": {"imageUri": imageUrl}},
          "features": [
            {"type": "SAFE_SEARCH_DETECTION"}
          ]
        }
      ]
    };
    try {
      final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final safeSearch = data['responses'][0]['safeSearchAnnotation'];

        if (safeSearch != null) {
          final likelihoods = [
            safeSearch['adult'],
            safeSearch['spoof'],
            safeSearch['medical'],
            safeSearch['violence'],
            safeSearch['racy']
          ];

          for (var likelihood in likelihoods) {
            if (['POSSIBLE', 'LIKELY', 'VERY_LIKELY'].contains(likelihood)) {
              return false;
            }
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
