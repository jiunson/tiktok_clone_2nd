import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone_2nd/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone_2nd/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone_2nd/features/videos/models/video_model.dart';
import 'package:tiktok_clone_2nd/features/videos/repos/videos_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    // 비디오 repository 초기화
    _repository = ref.read(videoRepo);
  }

  // 비디오 파일을 업로드한다.
  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authRepo).user; // 인증된 사용자
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        // 영상 업로드
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );
        // 성공적으로 업로드되면
        if (task.metadata != null) {
          // database에 doc을 등록한다.
          await _repository.saveVideo(
            VideoModel(
              title: "From Flutter!",
              description: "Hell yeah!",
              fileUrl: await task.ref.getDownloadURL(), // 영상 주소
              thumbnailUrl: "",
              creatorUid: user.uid,
              likes: 0,
              comments: 0,
              createAt: DateTime.now().millisecondsSinceEpoch,
              creator: userProfile.name,
            ),
          );
          if (!context.mounted) return;
          context.pushReplacement("/home");
        }
      });
    }
  }
}

// 업로드비디오 프로바이더 제공한다.
final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
