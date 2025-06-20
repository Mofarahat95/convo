abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeUserLoadedState extends HomeStates {
  final dynamic user;
  HomeUserLoadedState(this.user);
}

class HomeUserUpdatedState extends HomeStates {}

class HomeChatsLoadedState extends HomeStates {
  final Map<String, dynamic> partners;
  HomeChatsLoadedState(this.partners);
}

class HomeChatsUpdatedWithLastMessagesState extends HomeStates {}

class HomeChatsFilteredState extends HomeStates {}

class UpdateChatsState extends HomeStates {}

class HomeUserErrorState extends HomeStates {
  final String error;
  HomeUserErrorState(this.error);
}
