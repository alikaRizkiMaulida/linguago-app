import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/widgets/auth_widgets.dart';
import 'package:linguago_flutter/ui/pages/auth/login_page.dart';
import 'package:linguago_flutter/ui/widgets/custom_button.dart';

class VerificationEmailPage extends StatelessWidget {
  const VerificationEmailPage({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final displayEmail = email ?? 'your email';

    return AuthWatermarkLayout(
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Center(
            child: SvgPicture.asset(
              'assets/Group_108.svg',
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Verify Your Email',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We sent a verification link to $displayEmail. Check your inbox to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 36),
          CustomButton(
            label: 'Open Email App',
            borderRadius: 28,
            onTap: () {},
          ),
          const SizedBox(height: 14),
          CustomButton(
            label: 'Resend Email',
            borderRadius: 28,
            onTap: () {},
            variant: ButtonVariant.outline,
          ),
          const SizedBox(height: 32),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                (_) => false,
              ),
              child: Text(
                'Back to Login',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
