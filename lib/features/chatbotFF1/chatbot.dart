// import 'dart:convert';
// import 'package:convo/features/chatbot/chatbottt/ChatState.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
//
//
// class ChatCubit extends Cubit<ChatState> {
//   ChatCubit() : super(ChatInitial());
//
//   final List<Map<String, String>> messages = [];
//   bool isTyping = false;
//
//   final String apiKey = 'YOUR_API_KEY'; // ضع مفتاح API هنا
//   final String geminiUrl =
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=';
//
//   void sendMessage(String userMessage) async {
//     // 1. أضف رسالة المستخدم
//     messages.add({'sender': 'You', 'text': userMessage});
//     emit(ChatUpdated(List.from(messages), isTyping: false));
//
//     // 2. عرض حالة الكتابة
//     isTyping = true;
//     emit(ChatUpdated(List.from(messages), isTyping: true));
//
//     try {
//       // 3. تجهيز الطلب لـ Gemini
//       final payload = {
//         "contents": [
//           {
//             "parts": [
//               {"text": userMessage}
//             ]
//           }
//         ]
//       };
//
//       final response = await http.post(
//         Uri.parse('$geminiUrl$apiKey'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(payload),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         final botReply = data["candidates"][0]["content"]["parts"][0]["text"];
//
//         messages.add({'sender': 'Bot', 'text': botReply});
//       } else {
//         messages.add({'sender': 'Bot', 'text': 'Error: Server error'});
//       }
//     } catch (e) {
//       messages.add({'sender': 'Bot', 'text': 'Error: $e'});
//     }
//
//     // 4. إنهاء الكتابة وتحديث الحالة
//     isTyping = false;
//     emit(ChatUpdated(List.from(messages), isTyping: false));
//   }
// }