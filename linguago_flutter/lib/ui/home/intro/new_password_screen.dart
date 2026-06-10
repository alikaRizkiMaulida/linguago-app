import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/home/intro/login_screen.dart';
import 'package:linguago_flutter/ui/widgets/custom_button.dart';
import 'package:linguago_flutter/ui/widgets/custom_textfield.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, this.email});

  final String? email;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;

  bool get _isFormValid =>
      _passCtrl.text.length >= 6 && _passCtrl.text == _confirmCtrl.text;

  @override
  void initState() {
    super.initState();
    _passCtrl.addListener(() => setState(() {}));
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_isFormValid) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
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

              // ── Label: Enter New Password ─────────────────────────────
              Text(
                'Enter New Password',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 10),

              // ── New Password field ────────────────────────────────────
              CustomTextField(
                hintText: 'Confirm Password',
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
              const SizedBox(height: 20),

              // ── Label: Confirm New Password ───────────────────────────
              Text(
                'Confirm New Password',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 10),

              // ── Confirm Password field ────────────────────────────────
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

              // ── Password mismatch error ───────────────────────────────
              if (_confirmCtrl.text.isNotEmpty && !_isFormValid) ...[
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
              const SizedBox(height: 36),

              // ── Save Password button ──────────────────────────────────
              CustomButton(
                label: 'Save Password',
                enabled: _isFormValid,
                isLoading: _isLoading,
                borderRadius: 28,
                onTap: _isFormValid ? _save : null,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
