import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository 클래스를 Provdier로 앱내에서 접근할 수 있도록 제공한다.
class AuthenticationRepository {
  // FirebaseAuth 초기화
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null; // 로그인 유무
  User? get user => _firebaseAuth.currentUser;

  // 회원가입
  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
