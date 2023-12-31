import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone_2nd/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone_2nd/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  // 사용자 프로필을 초기화 한다.
  @override
  FutureOr<UserProfileModel> build() async {
    // Test용 딜레이 코드
    // await Future.delayed(const Duration(seconds: 10));

    // UserRepository 초기화
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    // 로그인이면 사용자의 프로필을 반환한다.
    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        // firebase에 받은 json을 객체로 반환한다.
        return UserProfileModel.fromJson(profile);
      }
    }

    // 비로그인이면 빈프로필을 반환한다.
    return UserProfileModel.empty();
  }

  // 계정 생성 시 firestore에 프로필 생성 후 저장한다.
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
      hasAvatar: false,
      email: credential.user!.email ?? "anon@anon.com",
      bio: "undefined",
      link: "undefined",
    );

    // 프로필을 firestore에 저장한다.
    await _usersRepository.createProfile(profile);

    // state에 유저프로필 데이터를 설정한다. 프로필 화면에서 보여줄 수 있다.
    state = AsyncValue.data(profile);
  }

  // 아바타 프로필 정보를 업데이트 한다.
  Future<void> onAvatarUpload() async {
    if (state.value == null) return;

    // 새로운 UserProfileModel로 state를 업데이트 한다.
    // state를 업데이트하면 화면이 새로고침된다.
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));

    // firestore 정보를 업데이트한다.
    // 업데이트하고 싶은 값만 보낸다.
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }
}

// 사용자 프로필 Notifier 프로바이더 제공한다.
final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
