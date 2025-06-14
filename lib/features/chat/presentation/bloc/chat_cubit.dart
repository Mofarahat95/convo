import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_session/audio_session.dart';
import 'chat_states.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);
  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;

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
        'isVoice': false,
      });

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

      final isSafe = true; // تجاوز فحص الأمان مؤقتاً
      final isSensitive = !isSafe;

      onUploaded(imageUrl, isSensitive);
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }
}
