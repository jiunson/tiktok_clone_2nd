import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone_2nd/features/users/repos/user_repo.dart';
import 'package:tiktok_clone_2nd/features/users/view_models/users_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  // 아바타 이미지를 업로드한다.
  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();
    final fileName = ref.read(authRepo).user!.uid; // 사용자 ID로 파일명 설정한다.
    state = await AsyncValue.guard(() async {
      // Firebase Storage에 아바타 이미지 업로드
      await _repository.uploadAvatar(file, fileName);
      // Firebase Store에 아바타 정보 업데이트
      await ref.read(usersProvider.notifier).onAvatarUpload();
    });
    // 에러 처리 구문
    if (state.hasError) {
      // if (!context.mounted) return;
      // showFirebaseErrorSnack(context, state.error);
    }
  }
}

// 아바타 프로바이더 제공한다.
final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);
