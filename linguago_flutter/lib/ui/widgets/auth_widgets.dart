import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/widgets/custom_button.dart';
import 'package:linguago_flutter/ui/widgets/custom_textfield.dart';
import 'package:linguago_flutter/ui/widgets/social_button.dart';

/// White auth layout (no watermark — watermark is onboarding-only).
class AuthWatermarkLayout extends StatelessWidget {
  const AuthWatermarkLayout({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.overlay,
    this.padding = const EdgeInsets.fromLTRB(24, 8, 24, 28),
  });

  final Widget child;
  final bool showBackButton;
  final Widget? overlay;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showBackButton)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AuthBackButton(
                        onTap: () => Navigator.maybePop(context),
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: padding,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
          ?overlay,
        ],
      ),
    );
  }
}

/// Alias kept for login/register files.
typedef AuthCardLayout = AuthWatermarkLayout;

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.showBackButton = false,
  });

  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AuthWatermarkLayout(
      showBackButton: showBackButton,
      child: child,
    );
  }
}

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap ?? () => Navigator.maybePop(context),
      icon: SvgPicture.asset(
        'assets/weui_back-filled.svg',
        width: 22,
        height: 22,
        colorFilter: const ColorFilter.mode(
          AppColors.primaryText,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class AuthLogoHeader extends StatelessWidget {
  const AuthLogoHeader({
    super.key,
    this.subtitle,
    this.showMascot = false,
    this.title,
    this.titleAlign = TextAlign.center,
  });

  final String? subtitle;
  final bool showMascot;
  final String? title;
  final TextAlign titleAlign;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Center(
          child: SvgPicture.asset('assets/logo.svg', width: 160),
        ),
        if (title != null) ...[
          const SizedBox(height: 28),
          Text(
            title!,
            textAlign: titleAlign,
            style: style.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
              height: 1.2,
            ),
          ),
        ],
        if (subtitle != null) ...[
          SizedBox(height: title != null ? 8 : 20),
          showMascot
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle!,
                        style: style.copyWith(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/Group_111.svg',
                      width: 72,
                      height: 72,
                    ),
                  ],
                )
              : Text(
                  subtitle!,
                  textAlign: titleAlign,
                  style: style.copyWith(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.secondaryText,
                  ),
                ),
        ],
        const SizedBox(height: 28),
      ],
    );
  }
}

/// Header for auth forms without logo (register, forgot password, etc.).
class AuthLoginHeader extends StatelessWidget {
  const AuthLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle();

    return Column(
      children: [
        const SizedBox(height: 8),
        SvgPicture.asset('assets/logo.svg', width: 168),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Log in to explore fun lessons every day.',
                textAlign: TextAlign.center,
                style: style.copyWith(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

@Deprecated('Use AuthLoginHeader')
typedef AuthLoginLavenderHeader = AuthLoginHeader;

class AuthFormHeader extends StatelessWidget {
  const AuthFormHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: style.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryText,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: style.copyWith(
            fontSize: 14,
            height: 1.5,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Email Address',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      fillColor: const Color(0xFFFAF8FC),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: SvgPicture.asset(
          'assets/email.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryPurple,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class AuthUsernameField extends StatelessWidget {
  const AuthUsernameField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Username',
      controller: controller,
      onChanged: onChanged,
      fillColor: const Color(0xFFFAF8FC),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: SvgPicture.asset(
          'assets/bi_person-fill.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryPurple,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: hintText,
      controller: controller,
      isPassword: true,
      onChanged: onChanged,
      fillColor: const Color(0xFFFAF8FC),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: SvgPicture.asset(
          'assets/majesticons_lock.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryPurple,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.prefix,
    required this.action,
    required this.onTap,
  });

  final String prefix;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            text: prefix,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: action,
                style: const TextStyle(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthSocialSection extends StatelessWidget {
  const AuthSocialSection({
    super.key,
    this.dividerText = 'Or sign up with',
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return SocialButtonRow(
      dividerText: dividerText,
      onGoogleTap: () {},
      onAppleTap: () {},
      onFacebookTap: () {},
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.enabled,
    this.onTap,
    this.isLoading = false,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      enabled: enabled,
      isLoading: isLoading,
      borderRadius: 28,
      onTap: enabled ? onTap : null,
    );
  }
}

/// Star-shaped OTP digit box (Figma verification screen).
class AuthStarOtpField extends StatefulWidget {
  const AuthStarOtpField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  State<AuthStarOtpField> createState() => _AuthStarOtpFieldState();
}

class _AuthStarOtpFieldState extends State<AuthStarOtpField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocus);
    super.dispose();
  }

  void _onFocus() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final starColor = widget.focusNode.hasFocus
        ? AppColors.primaryPurple
        : const Color(0xFFE4D9F6);

    return SizedBox(
      width: 62,
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/ic_round-star.svg',
            width: 62,
            height: 62,
            colorFilter: ColorFilter.mode(starColor, BlendMode.srcIn),
          ),
          SizedBox(
            width: 36,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthTextLink extends StatelessWidget {
  const AuthTextLink({
    super.key,
    required this.label,
    required this.onTap,
    this.align = Alignment.centerRight,
  });

  final String label;
  final VoidCallback onTap;
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primaryPurple,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
