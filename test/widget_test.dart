import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meme_review/app/pages/home_page.dart';
import 'package:meme_review/core/constants/app_constants.dart';
import 'package:meme_review/core/utils/result.dart';
import 'package:meme_review/features/authentication/domain/entities/auth_user.dart';
import 'package:meme_review/features/authentication/domain/repositories/auth_repository.dart';
import 'package:meme_review/features/authentication/presentation/cubit/auth_cubit.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Stream<AuthUser?> get authStateChanges async* {
    yield null;
  }

  @override
  AuthUser? get currentUser => null;

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    return const Success(
      AuthUser(id: '1', email: 'test@example.com', displayName: 'Tester'),
    );
  }

  @override
  Future<Result<bool>> signOut() async => const Success(true);
}

void main() {
  testWidgets('Home page shows Meme Arena branding for guests', (tester) async {
    final authCubit = AuthCubit(_FakeAuthRepository());
    addTearDown(authCubit.close);

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: const MaterialApp(home: HomePage()),
      ),
    );

    // Flush microtask-scheduled auth subscription + first event.
    await tester.pump();
    await tester.pump();

    expect(find.text(AppConstants.appName), findsWidgets);
    expect(find.text('Sign in to compete'), findsOneWidget);
  });
}
