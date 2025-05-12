abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatUpdated extends ChatState {
  final List<Map<String, String>> messages;
  final bool isTyping;

  ChatUpdated(this.messages, {this.isTyping = false});
}