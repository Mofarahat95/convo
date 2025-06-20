import 'package:convo/features/auth/signup/user_model.dart';

class HomeStates {}
class HomeInitialState extends HomeStates {}
class HomeUserErrorState extends HomeStates {
  final String error;
  HomeUserErrorState(this.error);
}
class HomeUserLoadedState extends HomeStates {
  UserModel userModel;
  HomeUserLoadedState(this.userModel);
}
class HomeChatsLoadedState extends HomeStates {
  final Map<String, UserModel> chatUsers;
  HomeChatsLoadedState(this.chatUsers);
}
class StoryUploadedState extends HomeStates {}
class HomeChatsFilteredState extends HomeStates {}
class HomeErrorState extends HomeStates {}
class HomeSuccessState extends HomeStates {}
class HomeLoadingState extends HomeStates {}
class UpdateChatsState extends HomeStates {}
class HomeChatsUpdatedWithLastMessagesState extends HomeStates {}