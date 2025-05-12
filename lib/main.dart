import 'package:convo/config/routes_manager/routes_manager.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_cubit.dart';
import 'package:convo/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:convo/features/chatbot/gen/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/chatbot/config.dart' show Config;
import 'features/home/presentation/bloc/home_cubit.dart' show HomeCubit;
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Config.init().then((_) => runApp(ProviderScope(
          child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => HomeCubit()..getCurrentUser(),), // ✅ أضف ده
          BlocProvider(create: (context) => ChatCubit(),)
        ],
        child:const Convo(),
      ))));
}

class Convo extends StatelessWidget {
  const Convo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: RoutesManager.Routes,
      localizationsDelegates: [
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
