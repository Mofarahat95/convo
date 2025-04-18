import 'package:convo/features/home/presentation/bloc/home_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);
  final User? user = FirebaseAuth.instance.currentUser;

  void getUser() async {}
}