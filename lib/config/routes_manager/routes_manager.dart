import 'package:convo/chatbot/chat/chat.dart';
import 'package:convo/chatbot/image/image.dart';
import 'package:convo/chatbot/settings/settings.dart';
import 'package:convo/chatbot/workspace/workspace.dart';
import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/login/presentation/screens/resetPass_screen.dart';
import 'package:convo/features/auth/login/presentation/screens/login_screen.dart';
import 'package:convo/features/auth/login/presentation/screens/success_screen.dart';
import 'package:convo/features/auth/signup/presentation/screens/register_screen.dart';
import 'package:convo/features/chat/presentation/screens/chat_screens.dart';
import 'package:convo/features/chat_bot/presentation/screens/chat_bot.dart';
import 'package:convo/features/contacts/presentation/contact_screen.dart';
import 'package:convo/features/home/presentation/screens/home_screen.dart';
import 'package:convo/features/splash/presentation/screens/welcome_screen.dart';
import 'package:convo/features/splash/presentation/screens/splash_screen.dart';
import 'package:convo/features/user_profile/screens/user_profile.dart';
import 'package:go_router/go_router.dart';

abstract class RoutesManager {
  static final GoRouter Routes = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.loginRoute,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.passwordResetRoute,
        builder: (context, state) => ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.successResetRoute,
        builder: (context, state) => SuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeRoute,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUpRoute,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.splashRoute,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatRoute,
        builder: (context, state) => ChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatBotRoute,
        builder: (context, state) => ChatBotScreen(),
      ),
      GoRoute(
        path: AppRoutes.contactsScreen,
        builder: (context, state) => ContactsScreen(),
      ),
      GoRoute(
        path: AppRoutes.onBoardingRoute,
        builder: (context, state) => onBoardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileRoute,
        builder: (context, state) => UserProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.imageRoute,
        builder: (context, state) => ImagePage(),
      ),
      GoRoute(
        path: AppRoutes.workSpaceRoute,
        builder: (context, state) => WorkspacePage(),
      ),
      GoRoute(
        path: AppRoutes.chatbotSettingsRoute,
        builder: (context, state) => SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.insidechatRoute,
        builder: (context, state) => ChatPage(),
      ),
    ],
  );
}
