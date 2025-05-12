abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class ChatMessagesUpdatedState extends ChatStates {}

class ChatMessageSentState extends ChatStates {}

class ChatMessageDeletedState extends ChatStates {}

class ChatMessageEditedState extends ChatStates {}

class ChatErrorState extends ChatStates {
  final String error;
  ChatErrorState(this.error);
}
