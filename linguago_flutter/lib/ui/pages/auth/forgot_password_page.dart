import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/pages/auth/login_page.dart';
import 'package:linguago_flutter/ui/pages/auth/otp_page.dart';
import 'package:linguago_flutter/ui/pages/auth/register_page.dart';
import 'package:linguago_flutter/ui/widgets/custom_button.dart';
import 'package:linguago_flutter/ui/widgets/custom_textfield.dart';
import 'package:linguago_flutter/ui/widgets/social_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  bool get _isFormValid => _emailCtrl.text.contains('@');

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_isFormValid) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => OtpPage(email: _emailCtrl.text.trim()),
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
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Label: Enter Email Address ────────────────────────────
              Text(
                'Enter Email Address',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 10),

              // ── Email field ───────────────────────────────────────────
              CustomTextField(
                hintText: 'Email Address',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
                fillColor: AppColors.white,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 6),
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
              ),
              const SizedBox(height: 14),

              // ── Back to Sign In ───────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginPage(),
                    ),
                  ),
                  child: Text(
                    'Back to Sign In',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Send to Email button ──────────────────────────────────
              CustomButton(
                label: 'Send to Email',
                enabled: _isFormValid,
                isLoading: _isLoading,
                borderRadius: 28,
                onTap: _isFormValid ? _sendEmail : null,
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
