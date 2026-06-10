import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/widgets/dot_loading_indicator.dart';

enum ButtonVariant { primary, outline, cancel, social }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? prefixIcon;

  const CustomButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == ButtonVariant.primary;
    final bool isOutline = variant == ButtonVariant.outline;
    final bool isCancel = variant == ButtonVariant.cancel;

    Color bgColor;
    Color textColor;
    Border? border;

    final bool isDisabled = !enabled || isLoading;

    if (isPrimary) {
      bgColor = enabled ? AppColors.primaryPurple : const Color(0xFFD8D0E8);
      textColor = enabled ? AppColors.white : const Color(0xFF9B8FB5);
    } else if (isOutline) {
      bgColor = AppColors.white;
      textColor = AppColors.primaryPurple;
      border = Border.all(color: AppColors.primaryPurple, width: 1.5);
    } else if (isCancel) {
      bgColor = AppColors.buttonCancel;
      textColor = AppColors.grey;
    } else {
      bgColor = AppColors.white;
      textColor = AppColors.primaryText;
      border = Border.all(color: AppColors.stroke, width: 1);
    }

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          boxShadow: isPrimary && enabled
              ? [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? DotLoadingIndicator(
                  size: 24,
                  dotCount: 8,
                  color: textColor,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}