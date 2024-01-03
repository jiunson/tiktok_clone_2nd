import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/users/models/user_profile_model.dart';

class UserRepository {
  // Firebase 초기화
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 사용자 프로필 생성
  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  // 사용자 프로필 조회
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    // firestore에서 json data를 가져온다.
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }
}

// repository 클래스를 Provider로 제공한다.
final userRepo = Provider((ref) => UserRepository());
