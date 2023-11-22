import 'package:go_router/go_router.dart';
import 'package:tiktok_clone_2nd/features/authentication/email_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/login_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/username_screen.dart';
import 'package:tiktok_clone_2nd/users/user_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: UsernameScreen.routeName,
      builder: (context, state) => const UsernameScreen(),
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: (context, state) {
        final args = state.extra as EmailScreenArgs; // Object로 매개변수 설정
        return EmailScreen(username: args.username);
      },
    ),
    GoRoute(
      path: "/users/:username", // path에 :변수 설정
      builder: (context, state) {
        final username = state.params['username'];
        final tab = state.queryParams["show"]; // queryParam값(?show=likes) 설정
        return UserProfileScreen(
          username: username!,
          tab: tab!,
        );
      },
    ),
  ],
);
