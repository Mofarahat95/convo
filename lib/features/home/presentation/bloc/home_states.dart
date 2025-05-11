import 'package:convo/features/auth/signup/user_model.dart';

class HomeStates{}
class HomeInitialState extends HomeStates{}
class HomeUserErrorState extends HomeStates{
  final String error ;
  HomeUserErrorState(this.error);
}
class HomeUserLoadedState extends HomeStates{
  UserModel userModel;
  HomeUserLoadedState(this.userModel);
}
class HomeChatsLoadedState extends HomeStates {
  final Map<String, UserModel> chatUsers;
  HomeChatsLoadedState(this.chatUsers);
}
