import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/bloc/auth/login/login_bloc.dart';
import 'package:linguago_flutter/ui/home/home_screen.dart';
import 'package:linguago_flutter/ui/home/intro/forgot_password_screen.dart';
import 'package:linguago_flutter/ui/home/intro/register_screen.dart';
import 'package:linguago_flutter/ui/widgets/animated_mascot.dart';
import 'package:linguago_flutter/ui/widgets/custom_button.dart';
import 'package:linguago_flutter/ui/widgets/custom_textfield.dart';
import 'package:linguago_flutter/ui/widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  bool get _isFormValid =>
      _emailCtrl.text.contains('@') && _passCtrl.text.length >= 6;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(_onFieldChanged);
    _passCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_isFormValid) return;
    context.read<LoginBloc>().add(
          LoginEvent.loginSubmitted(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    const double mascotOverlap = 68.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          state.maybeWhen(
            loading: () {
              setState(() => _isLoading = true);
            },
            success: () async {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful!'), backgroundColor: Colors.green),
              );
              await QuizProgress.loadProgress();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                  (_) => false,
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
          bottom: false,
          child: CustomScrollView(
            slivers: [
              // ── Top White Section ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 90, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/logo.svg', width: 160),
                      const SizedBox(height: 10),
                      Text(
                        'Log in to explore fun lessons every day.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom Purple Section ─────────────────────────────────────
              SliverFillRemaining(
                hasScrollBody: false,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Purple background stretching to the bottom
                    Positioned(
                      top: mascotOverlap,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.backgroundSoft,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                      ),
                    ),

                    // Content Container
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: mascotOverlap),
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email field
                          CustomTextField(
                            hintText: 'Email Address',
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            fillColor: AppColors.white,
                            onChanged: (_) => setState(() {}),
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

                          // Password field
                          CustomTextField(
                            hintText: 'Password',
                            controller: _passCtrl,
                            isPassword: true,
                            fillColor: AppColors.white,
                            onChanged: (_) => setState(() {}),
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
                           const SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Log In button
                          CustomButton(
                            label: 'Log In',
                            enabled: _isFormValid,
                            isLoading: _isLoading,
                            borderRadius: 28,
                            onTap: _isFormValid ? _login : null,
                          ),
                          const SizedBox(height: 22),

                          // Or Login with divider
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: AppColors.disableBorder, thickness: 1),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'Or Login with',
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: AppColors.disableBorder, thickness: 1),
                              ),
                            ],
                          ),
                           const SizedBox(height: 24),

                          // Social login buttons
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

                           const SizedBox(height: 56),

                          // ── Footer: Don't have an account? Sign Up ──────────────────
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign Up',
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
                        ],
                      ),
                    ),

                    // ── Mascot (overlapping the card top edge) ──────────────
                    Positioned(
                      top: 0,
                      right: 32, // Align to the right
                      child: IgnorePointer(
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            AnimatedMascot(
                              width: 136.52,
                              height: 87.86,
                              assetPath: 'assets/Group 61.svg',
                              isHolding: true,
                            ),
                            Positioned(
                              bottom: -6, // Slightly overlapping the bottom edge
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildPaw(),
                                  const SizedBox(width: 28),
                                  _buildPaw(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaw() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple, // Match mascot purple
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryText, width: 1.5), // Match mascot outline
      ),
    );
  }
}
