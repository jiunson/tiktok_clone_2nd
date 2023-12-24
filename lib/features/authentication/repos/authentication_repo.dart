import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository 클래스를 Provdier로 앱내에서 접근할 수 있도록 제공한다.
class AuthenticationRepository {
  // FirebaseAuth 초기화
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null; // 로그인 유무
  User? get user => _firebaseAuth.currentUser;

  // 유저의 로그인 상태를 실시간으로 감지한다.
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  // 회원가입
  Future<UserCredential> emailSignUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 로그아웃
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // 로그인
  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Github 로그인
  Future<void> githubSignIn() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }
}

// 앱 전체에서 접근할 수 있도록 Provider로 Repository를 노출한다.
final authRepo = Provider((ref) => AuthenticationRepository());

// 실시간으로 앱 UI에 로그인상태를 전달할 수 있도록 StreamProvider를 노출한다.
final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
