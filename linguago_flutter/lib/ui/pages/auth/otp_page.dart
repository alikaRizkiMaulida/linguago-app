import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/pages/auth/new_password_page.dart';
import 'package:linguago_flutter/ui/pages/auth/register_page.dart';
import 'package:linguago_flutter/ui/widgets/custom_button.dart';
import 'package:linguago_flutter/ui/widgets/social_button.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, this.email});

  final String? email;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;

  bool get _isCodeComplete =>
      _controllers.every((controller) => controller.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    for (final fn in _focusNodes) {
      fn.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  Future<void> _next() async {
    if (!_isCodeComplete) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => NewPasswordPage(email: widget.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // ── Back + Title row ──────────────────────────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 28,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Label: Enter Verification Code ────────────────────────
              Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 28),

              // ── OTP star boxes ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _StarOtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (value) => _onDigitChanged(index, value),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Resend link ───────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: RichText(
                    text: TextSpan(
                      text: "If you didn't receive a code, ",
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Next button ───────────────────────────────────────────
              CustomButton(
                label: 'Next',
                enabled: _isCodeComplete,
                isLoading: _isLoading,
                borderRadius: 28,
                onTap: _isCodeComplete ? _next : null,
              ),
              const SizedBox(height: 28),

              // ── Or Login with divider ─────────────────────────────────
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.stroke, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Or Login with',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppColors.stroke, thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Social buttons ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(type: SocialType.google, onTap: () {}),
                  const SizedBox(width: 16),
                  SocialButton(type: SocialType.apple, onTap: () {}),
                  const SizedBox(width: 16),
                  SocialButton(type: SocialType.facebook, onTap: () {}),
                ],
              ),
              const SizedBox(height: 28),

              // ── Don't have an account? ────────────────────────────────
              Center(
                child: Text(
                  "Don't have an account ?",
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Continue outlined button ──────────────────────────────
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const RegisterPage(),
                  ),
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.primaryPurple,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Star-shaped OTP digit box matching the Figma design.
class _StarOtpBox extends StatefulWidget {
  const _StarOtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  State<_StarOtpBox> createState() => _StarOtpBoxState();
}

class _StarOtpBoxState extends State<_StarOtpBox> {
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
    final bool hasFocus = widget.focusNode.hasFocus;
    final bool hasValue = widget.controller.text.isNotEmpty;

    final Color starColor = hasFocus || hasValue
        ? AppColors.primaryPurple
        : const Color(0xFFE4D9F6);

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Star background
          SvgPicture.asset(
            'assets/ic_round-star.svg',
            width: 64,
            height: 64,
            colorFilter: ColorFilter.mode(starColor, BlendMode.srcIn),
          ),
          // Text input centered inside star
          SizedBox(
            width: 38,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: hasFocus || hasValue
                    ? AppColors.white
                    : AppColors.primaryText,
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
