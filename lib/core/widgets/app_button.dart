import 'package:flutter/material.dart';
import 'package:meme_review/app/theme/app_colors.dart';
import 'package:meme_review/app/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, ghost }

/// Reusable button with loading state and subtle press scale.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final child = AnimatedScale(
      scale: _pressed && _enabled ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _enabled ? 1 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: _buildButton(context),
      ),
    );

    return Listener(
      onPointerDown: (_) {
        if (_enabled) {
          setState(() => _pressed = true);
        }
      },
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: widget.isExpanded
          ? SizedBox(width: double.infinity, child: child)
          : child,
    );
  }

  Widget _buildButton(BuildContext context) {
    final label = widget.isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(widget.label),
            ],
          );

    return switch (widget.variant) {
      AppButtonVariant.primary => ElevatedButton(
        onPressed: _enabled ? widget.onPressed : null,
        child: label,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: _enabled ? widget.onPressed : null,
        child: label,
      ),
      AppButtonVariant.ghost => TextButton(
        onPressed: _enabled ? widget.onPressed : null,
        style: TextButton.styleFrom(foregroundColor: AppColors.textPrimary),
        child: label,
      ),
    };
  }
}
