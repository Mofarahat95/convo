
import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/login/presentation/screens/login_screen.dart';
import 'package:go_router/go_router.dart';

abstract class RoutesManager {
  static final GoRouter Routes = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.loginRoute,
        builder: (context, state) =>LoginScreen() ,
      ),
      GoRoute(
        path: AppRoutes.Home,
        builder: (context, state) =>LoginScreen() ,
      ),
    ],
  );
}
