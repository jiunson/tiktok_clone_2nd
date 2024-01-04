import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone_2nd/features/videos/repos/videos_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    // repository 초기화
    _repository = ref.read(videoRepo);
  }

  Future<void> uploadVideo(File video) async {
    final user = ref.read(authRepo).user; // 인증된 사용자
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.uploadVideoFile(
        video,
        user!.uid,
      );
    });
  }
}
