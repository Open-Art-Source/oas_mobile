import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Auth {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<UserCredential> signInAnonymously();
  Future<UserCredential> signInWithGoogle();
  Future<User?> signInWithEmailAndPassword(String email, String pwd);
  Future<User?> createUserWithEmailAndPassword(String email, String pwd);
  Future<void> signOut();
}

class OasFirebaseAuth implements Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<UserCredential> signInAnonymously() async {
    return _firebaseAuth.signInAnonymously();
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String pwd) async {
    return _firebaseAuth
        .signInWithCredential(
            EmailAuthProvider.credential(email: email, password: pwd))
        .then((uc) => uc.user);
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String pwd) async {
    return _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pwd)
        .then((uc) => uc.user);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    googleSignIn.signOut(); // this may not be necessary
    _firebaseAuth.signOut();
  }
}
