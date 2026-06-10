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
                            // Memberi jarak ekstra di bawah teks agar sejajar tingginya dengan figma
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
    end: const Offset(0, -0.04), // Naik turun secara halus
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
          // Bintang-bintang diposisikan persis dengan layout Figma
          Positioned(
            left: 10,
            top: 40,
            child: SvgPicture.asset('assets/Group 36697.svg', width: 22, colorFilter: const ColorFilter.mode(Color(0xFFFFE031), BlendMode.srcIn)),
          ),
          Positioned(
            left: 36,
            top: 70,
            child: SvgPicture.asset('assets/Group 36697.svg', width: 14, colorFilter: const ColorFilter.mode(Color(0xFFFFE031), BlendMode.srcIn)),
          ),
          Positioned(
            right: 20,
            top: 50,
            child: SvgPicture.asset('assets/Group 36697.svg', width: 18, colorFilter: const ColorFilter.mode(Color(0xFFFFE031), BlendMode.srcIn)),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
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
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEDE7F8)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 12,
                    color: AppColors.secondaryText.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EEFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Lesson 1',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C55C5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Introduction to Hangul',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFE8DFF8), Color(0xFFC4B0E6)],
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          size: 40,
                          color: AppColors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Basic Hangul',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Learn how to greet and introduce yourself in Korean.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  color: AppColors.secondaryText.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 10),
              const Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  _LessonMeta(icon: Icons.schedule_rounded, label: '10m 15s'),
                  _LessonMeta(
                    icon: Icons.signal_cellular_alt_rounded,
                    label: 'Beginner',
                  ),
                  _LessonMeta(
                    icon: Icons.diamond_rounded,
                    label: '+20 XP',
                  ),
                ],
              ),
            ],
          ),
        ),
        // Maskot di posisikan pojok kanan bawah memotong kotak seperti di Figma
        Positioned(
          right: -20,
          bottom: -20,
          child: _FloatingMascot(
            child: SvgPicture.asset(
              'assets/Group_111.svg',
              width: 120,
              height: 120,
            ),
          ),
        ),
      ],
    );
  }
}

class _LessonMeta extends StatelessWidget {
  const _LessonMeta({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: iconColor ?? AppColors.secondaryText),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.secondaryText.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// LAYOUT KUIS (ONBOARDING 3) DIROMBAK TOTAL MENGIKUTI FIGMA
class _QuizIllustration extends StatelessWidget {
  const _QuizIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 280, // Mengunci tinggi area kuis agar konsisten
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Teks Pertanyaan di Paling Atas (Tengah)
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
          
          // 2. Papan Tulis di Tengah
          Positioned(
            top: 45,
            child: Container(
              width: 220,
              height: 140,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1135), // Hitam pekat papan tulis
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFC49A6C), // Bingkai kayu cokelat
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

          // 3. Maskot (Pakai Kacamata) di Kiri Bawah menimpa papan
          Positioned(
            left: 5, 
            bottom: 25,
            child: _FloatingMascot(
              child: SvgPicture.asset(
                'assets/Group_110.svg',
                width: 140, 
                height: 140,
              ),
            ),
          ),

          // 4. Tombol Pilihan Jawaban Kecil di Kanan Bawah
          Positioned(
            right: 25, // Diatur agak ke kanan
            bottom: 15,
            child: SizedBox(
              width: 140, // Lebar area tombol jawaban dibatasi agar kecil
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
    // Menyesuaikan warna berdasarkan screenshot Figma
    Color bg = const Color(0xFFF7F5FA); 
    Color fg = AppColors.primaryText;
    Border? border = Border.all(color: const Color(0xFFE5DDF0), width: 1);

    if (isCorrect) {
      bg = const Color(0xFF4ADE80); // Hijau
      fg = Colors.white;
      border = null;
    } else if (isWrong) {
      bg = const Color(0xFFFF6B6B); // Merah/Salmon
      fg = Colors.white;
      border = null;
    }

    return Container(
      height: 32, // Lebih pendek persis seperti desain
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