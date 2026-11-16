import 'package:meme_review/core/error/exceptions.dart';
import 'package:meme_review/core/error/failures.dart';
import 'package:meme_review/core/utils/result.dart';
import 'package:meme_review/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:meme_review/features/authentication/domain/entities/auth_user.dart';
import 'package:meme_review/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AuthUser?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  AuthUser? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Success(user);
    } on ConfigurationException catch (error) {
      return Error(ConfigurationFailure(error.message));
    } on AuthException catch (error) {
      return Error(AuthFailure(error.message));
    } catch (error) {
      return Error(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<Result<bool>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Success(true);
    } on AuthException catch (error) {
      return Error(AuthFailure(error.message));
    } catch (error) {
      return Error(UnexpectedFailure(error.toString()));
    }
  }
}
