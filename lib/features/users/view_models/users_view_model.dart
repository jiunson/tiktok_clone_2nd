import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/users/models/user_profile_model.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  //
  @override
  FutureOr<UserProfileModel> build() {
    // 로그인이면 사용자의 프로필을 반환한다.
    // 비로그인이면 빈프로필을 반환한다.
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    // state에 유저프로필 데이터를 생성한다. 프로필 화면에서 보여줄 수 있다.
    state = AsyncValue.data(
      UserProfileModel(
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? "Anon",
        email: credential.user!.email ?? "anon@anon.com",
        bio: "undefined",
        link: "undefined",
      ),
    );
  }
}

final usersProvider = AsyncNotifierProvider(
  () => UsersViewModel(),
);
