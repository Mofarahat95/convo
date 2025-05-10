import 'package:convo/features/auth/signup/user_model.dart';
import 'package:convo/features/home/presentation/bloc/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  late UserModel currentUser;

  void setUser(UserModel userModel) {
    currentUser = userModel;
    emit(HomeUserLoadedState(userModel));
  }
}
