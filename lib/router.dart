import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone_2nd/features/authentication/email_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/login_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/username_screen.dart';
import 'package:tiktok_clone_2nd/users/user_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: SignUpScreen.routeName,
      path: SignUpScreen.routeURL,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: LoginScreen.routeName,
      path: LoginScreen.routeURL,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: UsernameScreen.routeName,
      path: UsernameScreen.routeURL,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const UsernameScreen(), // 이동 화면 설정.
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
        );
      },
    ),
    GoRoute(
      name: EmailScreen.routeName,
      path: EmailScreen.routeURL,
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
