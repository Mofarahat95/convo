import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:convo/features/calls/presentation/screens/voice_call.dart';
import 'package:convo/features/calls/presentation/screens/vedio_call.dart';
import 'package:convo/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';
import '../../../auth/signup/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_session/audio_session.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordedFilePath;
  final Set<String> _unblurredImages = {};

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    _recorder?.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (!await Permission.microphone.isGranted) {
        await Permission.microphone.request();
        if (!await Permission.microphone.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يجب منح صلاحية المايكروفون')),
          );
          return;
        }
      }

      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionMode: AVAudioSessionMode.voiceChat,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
      ));

      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();
      await _recorder!.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );

      setState(() {
        _isRecording = true;
        _recordedFilePath = path;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في بدء التسجيل: ${e.toString()}')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (_isRecording && _recorder != null) {
        await _recorder!.stopRecorder();
        await _recorder!.closeRecorder();
        setState(() => _isRecording = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إيقاف التسجيل: ${e.toString()}')),
      );
    }
  }

  void _playVoice(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء تشغيل الصوت')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    if (routerState.extra == null) {
      return const Scaffold(
        body: Center(child: Text('خطأ: لا توجد بيانات مستخدم')),
      );
    }

    final otherUser = routerState.extra as UserModel?;
    if (otherUser == null) {
      return const Scaffold(
        body: Center(child: Text('خطأ: بيانات المستخدم غير صحيحة')),
      );
    }

    final currentUser = HomeCubit.get(context).currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final chatCubit = ChatCubit.get(context);
    final chatId = chatCubit.generateChatId(currentUser.id, otherUser.id);
    String userToken = otherUser.token;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(otherUser.profilePic ?? ""),
              onBackgroundImageError: (_, __) {},
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(otherUser.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("Active now", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ZimVoiceCall(
                    callid: "1",
                    userid: currentUser.id,
                    otherUserId: otherUser.id,
                  ),
                ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ZegoVideoCall(
                    callid: "1",
                    userid: currentUser.id,
                    otherUserId: otherUser.id,
                  ),
                ));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatCubit.listenToMessages(chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('لا توجد رسائل'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final msg = messages[index];
                    final msgData = msg.data() as Map<String, dynamic>?;
                    if (msgData == null) return const SizedBox.shrink();

                    final isMe = msgData['senderId'] == currentUser.id;
                    final messageText = msgData['message'] ?? '';
                    final isImage = chatCubit.isImageMessage(messageText);
                    final isSensitive = msgData['sensitive'] == true;
                    final isVoice = msgData['isVoice'] == true;

                    if (isVoice) return _buildVoiceMessage(messageText, isMe);
                    if (isImage) return _buildImageMessage(msg, isMe, isSensitive);
                    return _buildTextMessage(messageText, isMe, msg);
                  },
                );
              },
            ),
          ),
          _buildBottomInput(chatId, currentUser.id, otherUser.id, userToken),
        ],
      ),
    );
  }

  Widget _buildTextMessage(String text, bool isMe, QueryDocumentSnapshot msg) {
    final msgData = msg.data() as Map<String, dynamic>?;
    final timestamp = msgData?['timestamp'] as Timestamp?;
    final isEncrypted = msgData?['isEncrypted'] == true;
    final displayedText = isEncrypted ? ChatCubit.get(context).decryptMessage(text) : text;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayedText.isEmpty ? 'رسالة فارغة' : displayedText,style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 4),
            if (timestamp != null)
              Text(
                timestamp.toDate().toString().substring(11, 16),
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceMessage(String url, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => _playVoice(url),
            ),
            const Text('---- Audio ----'),
          ],
        ),
      ),
    );
  }

  Widget _buildImageMessage(QueryDocumentSnapshot msg, bool isMe, bool isSensitive) {
    final msgData = msg.data() as Map<String, dynamic>?;
    final imageUrl = msgData?['message'] ?? '';
    if (imageUrl.isEmpty) return const SizedBox.shrink();

    final msgId = msg.id;
    final isUnblurred = _unblurredImages.contains(msgId) || !isSensitive;

    return GestureDetector(
      onTap: () => isSensitive ? setState(() => _unblurredImages.add(msgId)) : null,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
                if (!isUnblurred)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        alignment: Alignment.center,
                        child: const Text(
                          "Blurred\nTap to reveal",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInput(String chatId, String senderId, String receiverId, String token) {
    final chatCubit = ChatCubit.get(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => _openAttachmentOptions(chatId, senderId, receiverId, token),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Write your message",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: _isRecording ? Colors.red : Colors.green),
            onPressed: () async {
              if (_isRecording) {
                await _stopRecording();
                if (_recordedFilePath != null) {
                  await chatCubit.uploadAndSendVoiceNote(
                    chatId: chatId,
                    senderId: senderId,
                    receiverId: receiverId,
                    filePath: _recordedFilePath!,
                  );
                }
              } else {
                await _startRecording();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              chatCubit.sendMessage(
                fcmToken: token,
                chatId: chatId,
                senderId: senderId,
                receiverId: receiverId,
                messageText: text,
              );
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }

  void _openAttachmentOptions(String chatId, String senderId, String receiverId, String token) {
    final chatCubit = ChatCubit.get(context);
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              chatCubit.pickAndUploadImage(
                chatId: chatId,
                senderId: senderId,
                receiverId: receiverId,
                source: ImageSource.camera,
                onUploaded: (url, isSensitive) {
                  chatCubit.sendMessage(
                    fcmToken: token,
                    chatId: chatId,
                    senderId: senderId,
                    receiverId: receiverId,
                    messageText: url,
                    isSensitive: isSensitive,
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              chatCubit.pickAndUploadImage(
                chatId: chatId,
                senderId: senderId,
                receiverId: receiverId,
                source: ImageSource.gallery,
                onUploaded: (url, isSensitive) {
                  chatCubit.sendMessage(
                    fcmToken: token,
                    chatId: chatId,
                    senderId: senderId,
                    receiverId: receiverId,
                    messageText: url,
                    isSensitive: isSensitive,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
