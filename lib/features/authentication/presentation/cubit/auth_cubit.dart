import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_review/features/authentication/domain/entities/auth_user.dart';
import 'package:meme_review/features/authentication/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState()) {
    // Schedule after the constructor finishes so the first auth event
    // cannot call emit during Cubit initialization.
    scheduleMicrotask(_startListening);
  }

  final AuthRepository _authRepository;
  StreamSubscription<AuthUser?>? _subscription;

  void _startListening() {
    if (isClosed) {
      return;
    }
    _subscription = _authRepository.authStateChanges.listen(
      _onAuthUserChanged,
      onError: (Object error) {
        if (isClosed) {
          return;
        }
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            user: AuthUser.empty,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  void _onAuthUserChanged(AuthUser? user) {
    if (isClosed) {
      return;
    }
    if (user == null || !user.isAuthenticated) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          user: AuthUser.empty,
          isSubmitting: false,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isSubmitting: false,
        clearError: true,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isSubmitting: true, clearError: true));

    final result = await _authRepository.signInWithGoogle();

    result.fold(
      onSuccess: (_) {
        // Auth stream will emit the authenticated user.
        emit(state.copyWith(isSubmitting: false, clearError: true));
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            status: AuthStatus.unauthenticated,
            errorMessage: failure.message,
          ),
        );
      },
    );
  }

  Future<void> signOut() async {
    emit(state.copyWith(isSubmitting: true, clearError: true));

    final result = await _authRepository.signOut();

    result.fold(
      onSuccess: (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            status: AuthStatus.unauthenticated,
            user: AuthUser.empty,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
      },
    );
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  @override
  Future<void> close() {
    final subscription = _subscription;
    _subscription = null;
    unawaited(subscription?.cancel());
    return super.close();
  }
}
