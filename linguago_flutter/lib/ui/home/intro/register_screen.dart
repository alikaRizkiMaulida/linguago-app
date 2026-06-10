import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/bloc/auth/register/register_bloc.dart';
import 'package:linguago_flutter/ui/home/intro/login_screen.dart';
import 'package:linguago_flutter/ui/widgets/custom_button.dart';
import 'package:linguago_flutter/ui/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;

  bool get _passwordsMatch =>
      _passCtrl.text.isNotEmpty &&
      _confirmCtrl.text.isNotEmpty &&
      _passCtrl.text == _confirmCtrl.text;

  bool get _showPasswordMismatch =>
      _confirmCtrl.text.isNotEmpty && !_passwordsMatch;

  bool get _isFormValid =>
      _usernameCtrl.text.trim().length >= 3 &&
      _emailCtrl.text.contains('@') &&
      _passCtrl.text.length >= 6 &&
      _passwordsMatch;

  @override
  void initState() {
    super.initState();
    for (final c in [_usernameCtrl, _emailCtrl, _passCtrl, _confirmCtrl]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!_isFormValid) return;
    context.read<RegisterBloc>().add(
          RegisterEvent.registerSubmitted(
            name: _usernameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          state.maybeWhen(
            loading: () {
              setState(() => _isLoading = true);
            },
            success: () async {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful!'), backgroundColor: Colors.green),
              );
              await QuizProgress.loadProgress();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              }
            },
            error: (message) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            },
            orElse: () {
              setState(() => _isLoading = false);
            },
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 130),

              // ── Title ─────────────────────────────────────────────────
              Text(
                'Create an Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // ── Subtitle ──────────────────────────────────────────────
              Text(
                'Please fill in your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),

              // ── Username field ─────────────────────────────────────────
              CustomTextField(
                hintText: 'Username',
                controller: _usernameCtrl,
                onChanged: (_) => setState(() {}),
                fillColor: AppColors.white,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 6),
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
              ),
              const SizedBox(height: 18),

              // ── Email field ────────────────────────────────────────────
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
              const SizedBox(height: 18),

              // ── Password field ─────────────────────────────────────────
              CustomTextField(
                hintText: 'Password',
                controller: _passCtrl,
                isPassword: true,
                onChanged: (_) => setState(() {}),
                fillColor: AppColors.white,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 6),
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
              ),
              const SizedBox(height: 18),

              // ── Confirm Password field ─────────────────────────────────
              CustomTextField(
                hintText: 'Confirm Password',
                controller: _confirmCtrl,
                isPassword: true,
                onChanged: (_) => setState(() {}),
                fillColor: AppColors.white,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 6),
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
              ),

              // ── Password mismatch error ────────────────────────────────
              if (_showPasswordMismatch) ...[
                const SizedBox(height: 8),
                Text(
                  'Passwords do not match',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 64),

              // ── Sign Up button ─────────────────────────────────────────
              CustomButton(
                label: 'Sign Up',
                enabled: _isFormValid,
                isLoading: _isLoading,
                borderRadius: 28,
                onTap: _isFormValid ? _signUp : null,
              ),

              const SizedBox(height: 48),

              // ── Footer: Already have an account? ──────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
