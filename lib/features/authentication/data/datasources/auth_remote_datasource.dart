import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meme_review/core/error/exceptions.dart';
import 'package:meme_review/features/authentication/domain/entities/auth_user.dart';

/// Remote auth operations against Firebase Auth + Google Sign-In.
class AuthRemoteDataSource {
  AuthRemoteDataSource({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _googleInitialized = false;

  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  AuthUser? get currentUser => _mapUser(_firebaseAuth.currentUser);

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) {
      return;
    }
    await _googleSignIn.initialize();
    _googleInitialized = true;
  }

  Future<AuthUser> signInWithGoogle() async {
    try {
      await _ensureGoogleInitialized();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        throw const AuthException(
          'Google Sign-In did not return an ID token. '
          'Ensure the SHA-1 fingerprint and OAuth client are configured.',
          code: 'missing-id-token',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw const AuthException(
          'Firebase returned no user after Google sign-in.',
          code: 'null-user',
        );
      }

      return _mapUser(user)!;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException(
          'Google sign-in was cancelled.',
          code: 'cancelled',
        );
      }
      throw AuthException(
        error.description ?? 'Google sign-in failed.',
        code: error.code.name,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'operation-not-allowed') {
        throw const ConfigurationException(
          'Google sign-in is not enabled in the Firebase Console. '
          'Enable the Google provider under Authentication → Sign-in method.',
        );
      }
      throw AuthException(
        error.message ?? 'Firebase authentication failed.',
        code: error.code,
      );
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      () async {
        await _ensureGoogleInitialized();
        await _googleSignIn.signOut();
      }(),
    ]);
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    return AuthUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
    );
  }
}
