import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meme_review/core/error/failures.dart';
import 'package:meme_review/core/utils/result.dart';
import 'package:meme_review/features/authentication/domain/entities/auth_user.dart';
import 'package:meme_review/features/authentication/domain/repositories/auth_repository.dart';
import 'package:meme_review/features/authentication/presentation/cubit/auth_cubit.dart';

class _ControlledAuthRepository implements AuthRepository {
  final _controller = StreamController<AuthUser?>.broadcast();
  AuthUser? _current;
  Result<AuthUser>? signInResult;
  Result<bool>? signOutResult;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  AuthUser? get currentUser => _current;

  void emitUser(AuthUser? user) {
    _current = user;
    _controller.add(user);
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    return signInResult ?? const Error(AuthFailure('not configured'));
  }

  @override
  Future<Result<bool>> signOut() async {
    return signOutResult ?? const Success(true);
  }

  Future<void> dispose() => _controller.close();
}

void main() {
  late _ControlledAuthRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = _ControlledAuthRepository();
    cubit = AuthCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  test('starts as unknown until auth stream emits', () {
    expect(cubit.state.status, AuthStatus.unknown);
  });

  test('becomes unauthenticated when stream emits null', () async {
    await Future<void>.delayed(Duration.zero);
    repository.emitUser(null);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.isAuthenticated, isFalse);
  });

  test('becomes authenticated when stream emits a user', () async {
    await Future<void>.delayed(Duration.zero);
    const user = AuthUser(id: 'u1', email: 'a@b.com', displayName: 'Ace');
    repository.emitUser(user);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, AuthStatus.authenticated);
    expect(cubit.state.user, user);
  });

  test('signInWithGoogle surfaces configuration failures', () async {
    repository.signInResult = const Error(
      ConfigurationFailure('Google provider disabled'),
    );

    await cubit.signInWithGoogle();

    expect(cubit.state.isSubmitting, isFalse);
    expect(cubit.state.errorMessage, 'Google provider disabled');
    expect(cubit.state.status, AuthStatus.unauthenticated);
  });
}
