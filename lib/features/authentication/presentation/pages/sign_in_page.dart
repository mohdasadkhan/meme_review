import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_review/app/theme/app_colors.dart';
import 'package:meme_review/app/theme/app_spacing.dart';
import 'package:meme_review/core/constants/app_constants.dart';
import 'package:meme_review/core/widgets/app_scaffold.dart';
import 'package:meme_review/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:meme_review/features/authentication/presentation/widgets/google_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.status != current.status,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<AuthCubit>().clearError();
        }

        if (state.isAuthenticated) {
          context.go(AppConstants.routeHome);
        }
      },
      builder: (context, state) {
        return AppScaffold(
          title: 'Sign in',
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  Color(0xFF12141A),
                  AppColors.background,
                ],
              ),
            ),
            child: AppContentConstraint(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  const ArenaMark(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(AppConstants.appName, style: textTheme.headlineLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sign in to create battles, join challenges, and cast your vote.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  GoogleSignInButton(
                    isLoading: state.isSubmitting,
                    onPressed: state.isSubmitting
                        ? null
                        : () => context.read<AuthCubit>().signInWithGoogle(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Browsing battles is free. Authentication is required to '
                    'like, create, or join.',
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go(AppConstants.routeHome),
                    child: const Text('Continue browsing'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
