import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';


enum SocialType { google, apple, facebook }

class SocialButton extends StatelessWidget {
  final SocialType type;
  final VoidCallback? onTap;

  const SocialButton({
    super.key,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.stroke, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: _buildIcon()),
      ),
    );
  }

  Widget _buildIcon() {
    switch (type) {
      case SocialType.google:
        return SvgPicture.asset('assets/material-icon-theme_google.svg', width: 24, height: 24);
      case SocialType.apple:
        return SvgPicture.asset('assets/ic_baseline-apple.svg', width: 24, height: 24);
      case SocialType.facebook:
        return SvgPicture.asset(
          'assets/ic_outline-facebook.svg',
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(Color(0xFF1877F2), BlendMode.srcIn),
        );
    }
  }
}

class SocialButtonRow extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onFacebookTap;
  final String dividerText;

  const SocialButtonRow({
    super.key,
    this.onGoogleTap,
    this.onAppleTap,
    this.onFacebookTap,
    this.dividerText = 'Or sign up with',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.stroke)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                dividerText,
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.stroke)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(type: SocialType.google, onTap: onGoogleTap),
            const SizedBox(width: 16),
            SocialButton(type: SocialType.apple, onTap: onAppleTap),
            const SizedBox(width: 16),
            SocialButton(type: SocialType.facebook, onTap: onFacebookTap),
          ],
        ),
      ],
    );
  }
}