import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_review/app/theme/app_colors.dart';
import 'package:meme_review/app/theme/app_spacing.dart';
import 'package:meme_review/core/constants/app_constants.dart';
import 'package:meme_review/core/widgets/app_button.dart';
import 'package:meme_review/core/widgets/app_scaffold.dart';
import 'package:meme_review/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:meme_review/features/profile/domain/entities/user_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (!state.isAuthenticated) {
          return AppScaffold(
            title: 'Profile',
            body: AppContentConstraint(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign in to view your profile',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Your wins, battles, and identity live here once you join the arena.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Sign in',
                    onPressed: () => context.go(AppConstants.routeSignIn),
                  ),
                ],
              ),
            ),
          );
        }

        final profile = UserProfile.fromAuth(
          id: state.user.id,
          email: state.user.email,
          displayName: state.user.displayName,
          photoUrl: state.user.photoUrl,
        );

        return AppScaffold(
          title: 'Profile',
          body: AppContentConstraint(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                _ProfileHeader(profile: profile),
                const SizedBox(height: AppSpacing.xl),
                _StatRow(
                  battlesPlayed: profile.battlesPlayed,
                  battlesWon: profile.battlesWon,
                ),
                const Spacer(),
                AppButton(
                  label: 'Sign out',
                  variant: AppButtonVariant.secondary,
                  isLoading: state.isSubmitting,
                  onPressed: state.isSubmitting
                      ? null
                      : () => context.read<AuthCubit>().signOut(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.surfaceElevated,
          backgroundImage: profile.photoUrl != null
              ? NetworkImage(profile.photoUrl!)
              : null,
          child: profile.photoUrl == null
              ? Text(
                  profile.displayName.isNotEmpty
                      ? profile.displayName[0].toUpperCase()
                      : '?',
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.accent,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.displayName, style: textTheme.headlineSmall),
              if (profile.email != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(profile.email!, style: textTheme.bodyMedium),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.battlesPlayed, required this.battlesWon});

  final int battlesPlayed;
  final int battlesWon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'Battles',
                value: '$battlesPlayed',
                style: textTheme,
              ),
            ),
            Container(width: 1, height: 36, color: AppColors.border),
            Expanded(
              child: _StatCell(
                label: 'Wins',
                value: '$battlesWon',
                style: textTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final String value;
  final TextTheme style;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: style.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: style.labelMedium),
      ],
    );
  }
}
