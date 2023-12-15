import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/authentication/repos/authentication_repo.dart';

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
    state = await AsyncValue.guard(
      () async => await _authRepo.emailSignUp(
        form["email"],
        form["password"],
      ),
    );
    if (state.hasError) {
    } else {}
  }
}

// 앱 전체에서 접근할 수 있는 회원가입계정 value를 expose한다.
final signUpForm = StateProvider((ref) => {});

// 앱 전체에서 SignUpViewModel을 접근할 수 있도록 Object를 expose한다.
final signUpPovider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
