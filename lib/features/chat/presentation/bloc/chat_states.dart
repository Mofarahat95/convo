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
