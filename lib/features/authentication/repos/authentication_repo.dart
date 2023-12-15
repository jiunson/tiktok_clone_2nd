import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository 클래스를 Provdier로 앱내에서 접근할 수 있도록 제공한다.
class AuthenticationRepository {
  // FirebaseAuth 초기화
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null; // 로그인 유무
  User? get user => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  // 회원가입
  Future<void> emailSignUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 로그아웃
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

// 앱 전체에서 접근할 수 있도록 Provider로 Repository를 노출한다.
final authRepo = Provider((ref) => AuthenticationRepository());

// 앱 전체에서 접근할 수 있도록 StreamProvider를 노출한다.
final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
