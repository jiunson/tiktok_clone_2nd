import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 비디오 파일을 업로드 후, UploadTask를 반환한다.
  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
          "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(video);
  }

  // 데이터베이스에 Video문서 저장한다.
  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }
}

// 비디오 프로바이더를 제공한다.
final videoRepo = Provider((ref) => VideosRepository());
