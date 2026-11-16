import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_review/app/theme/app_colors.dart';
import 'package:meme_review/app/theme/app_spacing.dart';
import 'package:meme_review/core/constants/app_constants.dart';
import 'package:meme_review/core/widgets/app_button.dart';
import 'package:meme_review/core/widgets/app_scaffold.dart';
import 'package:meme_review/features/authentication/presentation/cubit/auth_cubit.dart';

/// Public landing shell. Battle feed UI lands in a later phase.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AppScaffold(
          title: AppConstants.appName,
          actions: [
            IconButton(
              tooltip: state.isAuthenticated ? 'Profile' : 'Sign in',
              onPressed: () {
                if (state.isAuthenticated) {
                  context.go(AppConstants.routeProfile);
                } else {
                  context.go(AppConstants.routeSignIn);
                }
              },
              icon: Icon(
                state.isAuthenticated
                    ? Icons.person_outline_rounded
                    : Icons.login_rounded,
              ),
            ),
          ],
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.background,
                  Color(0xFF10131A),
                  AppColors.background,
                ],
              ),
            ),
            child: AppContentConstraint(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Text(AppConstants.appName, style: textTheme.displayMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppConstants.appTagline,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Browse public meme battles as a guest. Sign in when you '
                    'are ready to create, join, or like.',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Arena feed coming next',
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Open challenges, live voting windows, and completed '
                            'battles will appear here.',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!state.isAuthenticated)
                    AppButton(
                      label: 'Sign in to compete',
                      onPressed: () => context.go(AppConstants.routeSignIn),
                    )
                  else
                    AppButton(
                      label: 'View profile',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => context.go(AppConstants.routeProfile),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
