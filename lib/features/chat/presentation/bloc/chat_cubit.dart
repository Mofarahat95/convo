import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/features/Notification/NotificationService/Notification.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_session/audio_session.dart';
import 'package:encrypt/encrypt.dart' as enc;

import 'chat_states.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);
  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;

  // تشفير AES
  final enc.Key _key = enc.Key.fromUtf8('my 32 length key................'); // لازم يكون 32 حرف
  final enc.IV _iv = enc.IV.fromLength(16);
  late final enc.Encrypter _encrypter = enc.Encrypter(enc.AES(_key));

  String encryptMessage(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptMessage(String encryptedText) {
    try {
      final decrypted = _encrypter.decrypt64(encryptedText, iv: _iv);
      return decrypted;
    } catch (e) {
      return '[رسالة غير قابلة للقراءة]';
    }
  }

  Stream<QuerySnapshot> listenToMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String generateChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  bool isImageMessage(String message) {
    return message.startsWith('https://') && message.contains('firebase');
  }

  Future<void> startRecording() async {
    try {
      if (!await Permission.microphone.isGranted) {
        await Permission.microphone.request();
        if (!await Permission.microphone.isGranted) {
          emit(ChatErrorState('Microphone permission denied'));
          return;
        }
      }

      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

      _soundRecorder = FlutterSoundRecorder();
      await _soundRecorder!.openRecorder();
      await _soundRecorder!.startRecorder(
        toFile: filePath,
        codec: Codec.aacADTS,
      );

      _isRecording = true;
      emit(ChatRecordingStartedState());
    } catch (e) {
      emit(ChatErrorState('Failed to start recording: ${e.toString()}'));
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording || _soundRecorder == null) return;
    try {
      String? filePath = await _soundRecorder!.stopRecorder();
      await _soundRecorder!.closeRecorder();
      _isRecording = false;

      if (filePath != null) {
        emit(ChatRecordingStoppedState(filePath));
      } else {
        emit(ChatErrorState('Failed to get recorded file path'));
      }
    } catch (e) {
      emit(ChatErrorState('Failed to stop recording: ${e.toString()}'));
    }
  }

  Future<void> uploadAndSendVoiceNote({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String filePath,
  }) async {
    try {
      emit(ChatVoiceUploadingState());
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('chat_voices/$fileName.aac');
      await ref.putFile(File(filePath));
      final voiceUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': voiceUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'isVoice': true,
      });

      emit(ChatVoiceUploadedState(voiceUrl));
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String messageText,
    required String fcmToken,
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

      final isImage = isImageMessage(messageText);
      final encryptedMsg = isImage ? messageText : encryptMessage(messageText);

      await chatRef.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': encryptedMsg,
        'timestamp': FieldValue.serverTimestamp(),
        'sensitive': isSensitive,
        'isVoice': false,
        'isEncrypted': !isImage,
      });

      NotificationService.sendNotification(fcmToken, "New Message", messageText);

      emit(ChatMessageSentState());
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

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

  final String apiKey = 'AIzaSyBgfY2Gv-AHExgm9S-y_EDUGN4r66wYB2I';
  Future<bool> checkImageSafeContent(String imageUrl) async {
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');

    final body = {
      "requests": [{
        "image": {"source": {"imageUri": imageUrl}},
        "features": [
          {"type": "SAFE_SEARCH_DETECTION"}
        ]
      }]
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
            if (["POSSIBLE", "LIKELY", "VERY_LIKELY"].contains(likelihood)) {
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
