import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/home/intro/onboarding_watermark.dart';
import 'package:linguago_flutter/ui/home/intro/login_screen.dart';
import 'package:linguago_flutter/ui/widgets/custom_button.dart';

enum OnboardingIllustration { welcome, lesson, quiz }

class OnboardingData {
  final String title;
  final String subtitle;
  final OnboardingIllustration illustration;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.illustration,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    OnboardingData(
      title: 'Welcome To Linguago!',
      subtitle: 'Track your mood and understand yourself better',
      illustration: OnboardingIllustration.welcome,
    ),
    OnboardingData(
      title: 'Learn New Lessons',
      subtitle:
          'Explore fun and easy lessons designed to help you grow every day.',
      illustration: OnboardingIllustration.lesson,
    ),
    OnboardingData(
      title: 'Test Your Skills',
      subtitle:
          'Complete fun quizzes, collect rewards, and track your progress.',
      illustration: OnboardingIllustration.quiz,
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: AppColors.primaryText,
      height: 1.25,
    );
    final bodyStyle = TextStyle(
      fontSize: 14,
      height: 1.5,
      color: AppColors.secondaryText,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: LinguagoWatermark(
                key: ValueKey<int>(_currentPage),
                pageIndex: _currentPage,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: OnboardingLoadingBar(
                    step: _currentPage + 1,
                    totalSteps: _pages.length,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (_, index) {
                      final data = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: _OnboardingIllustration(
                                  type: data.illustration,
                                ),
                              ),
                            ),
                            Text(
                              data.title,
                              textAlign: TextAlign.center,
                              style: titleStyle,
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                data.subtitle,
                                textAlign: TextAlign.center,
                                style: bodyStyle,
                              ),
                            ),
                            const SizedBox(height: 48), 
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: CustomButton(
                    label: _currentPage == _pages.length - 1 ? 'Start' : 'Next',
                    borderRadius: 28,
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- ANIMASI MELAYANG (FLOATING) ---
class _FloatingMascot extends StatefulWidget {
  final Widget child;
  const _FloatingMascot({required this.child});

  @override
  State<_FloatingMascot> createState() => _FloatingMascotState();
}

class _FloatingMascotState extends State<_FloatingMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: const Offset(0, 0),
    end: const Offset(0, -0.04),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
// ------------------------------------

class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration({required this.type});

  final OnboardingIllustration type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      OnboardingIllustration.welcome => const _WelcomeIllustration(),
      OnboardingIllustration.lesson => const _LessonIllustration(),
      OnboardingIllustration.quiz => const _QuizIllustration(),
    };
  }
}

class _WelcomeIllustration extends StatelessWidget {
  const _WelcomeIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Bintang Kiri Atas (Diperbesar ke 34 & digeser sedikit biar presisi)
          Positioned(
            left: 2,
            top: 30,
            child: SvgPicture.asset('assets/Group 36697.svg', width: 34, colorFilter: const ColorFilter.mode(Color(0xFFFFE031), BlendMode.srcIn)),
          ),
          // Bintang Kiri Bawah (Diperbesar ke 22)
          Positioned(
            left: 30,
            top: 75,
            child: SvgPicture.asset('assets/Group 36697.svg', width: 22, colorFilter: const ColorFilter.mode(Color(0xFFFFE031), BlendMode.srcIn)),
          ),
          // Bintang Kanan Atas (Diperbesar ke 28)
          Positioned(
            right: 12,
            top: 40,
            child: SvgPicture.asset('assets/Group 36697.svg', width: 28, colorFilter: const ColorFilter.mode(Color(0xFFFFE031), BlendMode.srcIn)),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          _FloatingMascot(
            child: SvgPicture.asset(
              'assets/Group_108.svg',
              width: 180, 
              height: 180,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonIllustration extends StatelessWidget {
  const _LessonIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 1. Gambar utama SVG Onboarding 2
          SvgPicture.asset(
            'assets/onboarding 2.svg', 
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          
          // 2. Maskot ditaruh di posisi yang pas dan ukurannya disesuaikan 
          // supaya tidak menutupi teks penting atau ikon bookmark di card.
          Positioned(
            right: -10,
            bottom: 0,
            child: _FloatingMascot(
              child: SvgPicture.asset(
                'assets/Group 36741.svg',
                width: 100, // Disesuaikan sedikit agar proporsional dengan card
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizIllustration extends StatelessWidget {
  const _QuizIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 280, 
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: 0,
            child: Text(
              'What is the sound of ㄷ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
          ),
          Positioned(
            top: 45,
            child: Container(
              width: 220,
              height: 140,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1135), 
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFC49A6C), 
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  )
                ]
              ),
              child: const Text(
                'ㄷ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            left: 5, 
            bottom: 25,
            child: _FloatingMascot(
              child: SvgPicture.asset(
                'assets/Group 36726.svg',
                width: 140, 
                height: 140,
              ),
            ),
          ),
          Positioned(
            right: 25, 
            bottom: 15,
            child: SizedBox(
              width: 140, 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Expanded(child: _QuizOption(label: 'G', isNormal: true)),
                      SizedBox(width: 8),
                      Expanded(child: _QuizOption(label: 'N', isWrong: true)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(child: _QuizOption(label: 'D', isCorrect: true)),
                      SizedBox(width: 8),
                      Expanded(child: _QuizOption(label: 'S', isNormal: true)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  const _QuizOption({
    required this.label,
    this.isCorrect = false,
    this.isWrong = false,
    this.isNormal = false,
  });

  final String label;
  final bool isCorrect;
  final bool isWrong;
  final bool isNormal;

  @override
  Widget build(BuildContext context) {
    Color bg = const Color(0xFFF7F5FA); 
    Color fg = AppColors.primaryText;
    Border? border = Border.all(color: const Color(0xFFE5DDF0), width: 1);

    if (isCorrect) {
      bg = const Color(0xFF4ADE80); 
      fg = Colors.white;
      border = null;
    } else if (isWrong) {
      bg = const Color(0xFFFF6B6B); 
      fg = Colors.white;
      border = null;
    }

    return Container(
      height: 32, 
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: border,
        boxShadow: [
          BoxShadow(
            color: (isCorrect || isWrong) ? bg.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ]
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}