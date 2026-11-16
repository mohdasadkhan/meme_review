import 'package:meme_review/core/utils/result.dart';
import 'package:meme_review/features/authentication/domain/entities/auth_user.dart';

/// Contract for authentication operations.
abstract interface class AuthRepository {
  /// Emits auth state changes (null when signed out).
  Stream<AuthUser?> get authStateChanges;

  AuthUser? get currentUser;

  Future<Result<AuthUser>> signInWithGoogle();

  Future<Result<bool>> signOut();
}
