import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Primary action button with loading state.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label, style: AppTextStyles.labelLarge),
            ],
          );

    final effectiveOnPressed = isLoading ? null : onPressed;

    if (isOutlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
    );
  }
}

/// Full-width primary action button.
class AppFullWidthButton extends StatelessWidget {
  const AppFullWidthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      isOutlined: isOutlined,
      icon: icon,
      width: double.infinity,
    );
  }
}

/// Destructive/danger action button.
class AppDangerButton extends StatelessWidget {
  const AppDangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(label),
      ),
    );
  }
}
