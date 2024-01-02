import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone_2nd/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;
  //
  @override
  FutureOr<UserProfileModel> build() {
    // UserRepository 초기화
    _repository = ref.read(userRepo);

    // 로그인이면 사용자의 프로필을 반환한다.
    // 비로그인이면 빈프로필을 반환한다.
    return UserProfileModel.empty();
  }

  // 계정 생성 시 firestore에 프로필 저장한다.
  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    // 프로필 저장 전, state를 로딩상태로 변경한다.
    state = const AsyncValue.loading();

    // 최초 프로필 기본 정보
    final profile = UserProfileModel(
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? "Anon",
      email: credential.user!.email ?? "anon@anon.com",
      bio: "undefined",
      link: "undefined",
    );

    // 프로필을 firestore에 저장한다.
    await _repository.createProfile(profile);

    // state에 유저프로필 데이터를 설정한다. 프로필 화면에서 보여줄 수 있다.
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
