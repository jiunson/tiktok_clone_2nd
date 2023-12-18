import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone_2nd/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone_2nd/utils.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }

  // 로그인하기
  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = const AsyncValue.loading(); // 로딩상태 설정
    state = await AsyncValue.guard(
      () async => await _repository.signIn(email, password),
    );

    // 아래 에러 방지
    // Don't use 'BuildContext's across async gaps. Try rewriting the code to not reference the 'BuildContext'.
    if (!context.mounted) return;

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/home");
    }
  }
}

final loginProvider = AsyncNotifierProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);
