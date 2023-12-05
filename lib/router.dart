import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone_2nd/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/login_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone_2nd/features/inbox/activity_screen.dart';
import 'package:tiktok_clone_2nd/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone_2nd/features/inbox/chats_screen.dart';
import 'package:tiktok_clone_2nd/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone_2nd/features/videos/video_recording_screen.dart';

final router = GoRouter(
  initialLocation: "/inbox", // 지정된 경로로 초기화.
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
      name: InterestsScreen.routeName,
      path: InterestsScreen.routeURL,
      builder: (context, state) => const InterestsScreen(),
    ),
    GoRoute(
      path: "/:tab(home|discover|inbox|profile)", // tab변수 매칭값 설정
      name: MainNavgationScreen.routeName,
      builder: (context, state) {
        final tab = state.params["tab"]!;
        return MainNavgationScreen(tab: tab);
      },
    ),
    GoRoute(
      name: ActivityScreen.routeName,
      path: ActivityScreen.routeURL,
      builder: (context, state) => const ActivityScreen(),
    ),
    // chats/:chatId
    GoRoute(
      name: ChatsScreen.routeName,
      path: ChatsScreen.routeURL,
      builder: (context, state) => const ChatsScreen(),
      routes: [
        GoRoute(
          name: ChatDetailScreen.routeName,
          path: ChatDetailScreen.routeURL,
          builder: (context, state) {
            final chatId = state.params["chatId"]!;
            return ChatDetailScreen(chatId: chatId);
          },
        ),
      ],
    ),
    GoRoute(
      path: VideoRecordingScreen.routeURL,
      name: VideoRecordingScreen.routeName,
      // builder: (context, state) => const VideoRecordingScreen(),

      // 화면전환 애니메이션 적용
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const VideoRecordingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final position = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(
            position: position,
            child: child,
          );
        },
      ),
    ),
  ],
);
