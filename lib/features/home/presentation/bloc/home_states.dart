import 'package:convo/features/auth/signup/user_model.dart';

class HomeStates{}
class HomeInitialState extends HomeStates{}
class HomeUserLoadedState extends HomeStates{
  UserModel userModel;
  HomeUserLoadedState(this.userModel);
}