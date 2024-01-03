import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends ConsumerWidget {
  final String name;

  const Avatar({
    super.key,
    required this.name,
  });

  Future<void> _onAvatarTap() async {
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
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: _onAvatarTap,
      child: CircleAvatar(
        radius: 50,
        foregroundImage: const NetworkImage(
            "https://avatars.githubusercontent.com/u/3612017"),
        child: Text(name), // 데이터 출력
      ),
    );
  }
}
