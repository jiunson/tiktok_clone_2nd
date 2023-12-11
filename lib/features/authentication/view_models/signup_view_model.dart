import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/authentication/repos/authentication_repo.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  // repository 초기화
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp() async {
    state = const AsyncValue.loading(); // 로딩중 설정
    final form = ref.read(signUpForm);
    state = await AsyncValue.guard(
      () async => await _authRepo.signUp(
        form["email"],
        form["password"],
      ),
    );
  }
}

// 앱에서 수정할 수 있는 회원가입계정 value를 expose한다.
final signUpForm = StateProvider((ref) => {});

final signUpPovider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
