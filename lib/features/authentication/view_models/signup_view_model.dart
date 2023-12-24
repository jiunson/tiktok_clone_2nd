import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone_2nd/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone_2nd/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone_2nd/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone_2nd/utils.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  // repository 초기화
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  // 회원가입
  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading(); // 로딩중 설정
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);
    state = await AsyncValue.guard(() async {
      // 계정을 Authentication 데이터베이스에 생성한다.
      final userCredential = await _authRepo.emailSignUp(
        form["email"],
        form["password"],
      );
      // 유저 계정이 생성되면 프로필을 Firestore에 생성한다.
      if (userCredential.user != null) {
        await users.createAccount(userCredential);
      }
    });

    // 아래 에러 방지
    // Don't use 'BuildContext's across async gaps. Try rewriting the code to not reference the 'BuildContext'.
    if (!context.mounted) return;

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

// 앱 전체에서 접근할 수 있는 회원가입계정 value를 expose한다.
final signUpForm = StateProvider((ref) => {});

// 앱 전체에서 SignUpViewModel을 접근할 수 있도록 Object를 expose한다.
final signUpPovider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
