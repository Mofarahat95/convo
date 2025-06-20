abstract class ChatStates {}

// Initial
class ChatInitialState extends ChatStates {}

// Messages
class ChatMessagesUpdatedState extends ChatStates {}
class ChatMessageSentState extends ChatStates {}
class ChatEncryptedMessageSentState extends ChatStates {}
class ChatMessageDeletedState extends ChatStates {}
class ChatMessageEditedState extends ChatStates {}
class ChatMessageDecryptionFailedState extends ChatStates {
  final String error;
  ChatMessageDecryptionFailedState(this.error);
}

// Voice
class ChatRecordingStartedState extends ChatStates {}
class ChatRecordingStoppedState extends ChatStates {
  final String filePath;
  ChatRecordingStoppedState(this.filePath);
}
class ChatVoiceUploadingState extends ChatStates {}
class ChatVoiceUploadedState extends ChatStates {
  final String voiceUrl;
  ChatVoiceUploadedState(this.voiceUrl);
}

// Images
class ChatImageUploadingState extends ChatStates {}
class ChatImageUploadedState extends ChatStates {
  final String imageUrl;
  final bool isSensitive;
  ChatImageUploadedState(this.imageUrl, this.isSensitive);
}

// Sensitive Content
class ChatSensitiveContentFilteredState extends ChatStates {}

// Errors
class ChatErrorState extends ChatStates {
  final String error;
  ChatErrorState(this.error);
}
