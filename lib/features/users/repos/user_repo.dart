import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/users/models/user_profile_model.dart';

class UserRepository {
  // Firebase 초기화
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 사용자 프로필을 firestore에 저장한다.
  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  // firestore에서 사용자 프로필 가져온다.
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    // firestore에서 json data를 가져온다.
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  // firebase storage에 사용자 아바타를 업로드한다.
  Future<void> uploadAvatar(File file, String fileName) async {
    // storage buket에 link된 reference를 받아 파일 위치와 이름을 설정한다.
    final fileRef = _storage.ref().child("avatar/$fileName");
    await fileRef.putFile(file);
  }

  // 프로필을 업데이트한다.
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }
}

// repository 클래스를 Provider로 제공한다.
final userRepo = Provider((ref) => UserRepository());
