import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone_2nd/features/users/view_models/avarar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final bool hasAvatar;
  final String uid;

  const Avatar({
    super.key,
    required this.uid,
    required this.name,
    required this.hasAvatar,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40, // Firebase비용 절감을 위해 품질을 낮춘다.
      maxHeight: 150,
      maxWidth: 150,
    );
    // 사용자가 이미지를 선택했다면
    if (xfile != null) {
      // Firebase storage에 업로드할 file을 만든다.
      final file = File(xfile.path);
      // 아바타 이미지를 업로드 후 정보 업데이트 한다.
      await ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 아바타가 로딩 중인지 확인한다.
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tiktok-jiun-zxc.appspot.com/o/avatar%2F$uid?alt=media")
                  : null,
              child: Text(name), // 데이터 출력
            ),
    );
  }
}
