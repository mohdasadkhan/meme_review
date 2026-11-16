import 'package:flutter/material.dart';
import 'package:meme_review/app/theme/app_colors.dart';
import 'package:meme_review/app/theme/app_spacing.dart';
import 'package:meme_review/core/widgets/app_button.dart';

/// Google sign-in CTA used on the auth screen.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Continue with Google',
      onPressed: onPressed,
      isLoading: isLoading,
      icon: Icons.g_mobiledata_rounded,
      variant: AppButtonVariant.secondary,
    );
  }
}

/// Compact branding mark for the sign-in page.
class ArenaMark extends StatelessWidget {
  const ArenaMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        'MA',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
