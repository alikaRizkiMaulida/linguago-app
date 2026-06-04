import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/data/datasource/auth_local_datasource.dart';
import 'package:linguago_flutter/ui/home/home_screen.dart';
import 'package:linguago_flutter/ui/home/intro/onboarding_screen.dart';

/// Splash sequence: mascot idle → bubble burst → logo → onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color _lavender = Color(0xFFF3E8FF);

  static const List<String> _mascotFrames = [
    'assets/Group_107.svg',
    'assets/Group_108.svg',
    'assets/Group_109.svg',
    'assets/Group_110.svg',
    'assets/Group_111.svg',
  ];

  static const List<String> _bubbleAssets = [
    'assets/Ellipse209.svg',
    'assets/Ellipse210.svg',
    'assets/Ellipse213.svg',
    'assets/Ellipse214.svg',
    'assets/Ellipse216.svg',
    'assets/Ellipse217.svg',
    'assets/Ellipse219.svg',
    'assets/Ellipse220.svg',
    'assets/Ellipse221.svg',
  ];

  late final List<BubbleData> _bubbles;
  late final AnimationController _mascotEntryController;
  late final Animation<double> _mascotSlideAnimation;
  late final AnimationController _mascotBlinkController;
  late final AnimationController _bubbleController;
  late final AnimationController _logoController;

  int _mascotFrameIndex = 0;
  bool _showMascot = true;
  bool _showBubbles = false;
  bool _fadeBubbles = false;
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();
    _bubbles = _generateBubbleLayout();

    _mascotEntryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _mascotSlideAnimation = Tween<double>(begin: 350.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mascotEntryController,
        curve: Curves.easeOutBack,
      ),
    );

    _mascotBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(() {
        if (!_showMascot || !mounted) return;
        final frame = _mascotBlinkController.value * _mascotFrames.length;
        final next = frame.floor() % _mascotFrames.length;
        if (next != _mascotFrameIndex) {
          setState(() => _mascotFrameIndex = next);
        }
      });

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    unawaited(_runSequence());
  }

  Future<void> _runSequence() async {
    // 1. Maskot masuk dari bawah (slide up)
    unawaited(_mascotEntryController.forward());
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    // 2. Kedap-kedip / animasi ekspresi (2.5 s)
    _mascotBlinkController.repeat();
    await Future<void>.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;
    _mascotBlinkController.stop();
    setState(() {
      _showMascot = false;
      _showBubbles = true;
    });

    // Gelembung ungu tumbuh/muncul (1.4s)
    await _bubbleController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() {
      _showLogo = true;
    });
    
    // Animasi logo muncul (0.7s)
    await _logoController.forward();
    
    // Tunggu sebentar, lalu mudarkan gelembung secara halus
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    
    setState(() {
      _fadeBubbles = true;
    });
    
    // Tunggu efek memudar selesai
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    
    setState(() {
      _showBubbles = false;
    });
    
    // Tampilkan logo selama 1.2s sebelum beralih halaman
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    final isLoggedIn = await AuthLocalDatasource().isLogin();
    if (!mounted) return;
    if (isLoggedIn) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    } else {
      await Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => const OnboardingScreen(),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mascotEntryController.dispose();
    _mascotBlinkController.dispose();
    _bubbleController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lavender, // background lavender lembut yang konsisten
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_showBubbles)
            AnimatedOpacity(
              opacity: _fadeBubbles ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: AnimatedBuilder(
                animation: _bubbleController,
                builder: (context, _) => _BubbleBurstLayer(
                  progress: _bubbleController.value,
                  bubbles: _bubbles,
                ),
              ),
            ),
          AnimatedOpacity(
            opacity: _showMascot ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 48,
                ),
                child: AnimatedBuilder(
                  animation: _mascotEntryController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0.0, _mascotSlideAnimation.value),
                      child: child,
                    );
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: SvgPicture.asset(
                      _mascotFrames[_mascotFrameIndex],
                      key: ValueKey<int>(_mascotFrameIndex),
                      width: 260,
                      height: 260,
                    ),
                  ),
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _logoController,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1).animate(
                CurvedAnimation(
                  parent: _logoController,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: IgnorePointer(
                ignoring: !_showLogo,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/logo.svg',
                    width: 213,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BubbleData> _generateBubbleLayout() {
    return const [
      BubbleData(assetPath: 'assets/Ellipse209.svg', centerX: 0.15, centerY: 0.15, baseSize: 260, stagger: 0.0),
      BubbleData(assetPath: 'assets/Ellipse210.svg', centerX: 0.85, centerY: 0.85, baseSize: 280, stagger: 0.05),
      BubbleData(assetPath: 'assets/Ellipse212.svg', centerX: 0.4, centerY: 0.25, baseSize: 240, stagger: 0.02),
      BubbleData(assetPath: 'assets/Ellipse213.svg', centerX: 0.9, centerY: 0.2, baseSize: 220, stagger: 0.08),
      BubbleData(assetPath: 'assets/Ellipse214.svg', centerX: 0.15, centerY: 0.55, baseSize: 320, stagger: 0.12),
      BubbleData(assetPath: 'assets/Ellipse216.svg', centerX: 0.5, centerY: 0.9, baseSize: 280, stagger: 0.06),
      BubbleData(assetPath: 'assets/Ellipse217.svg', centerX: 0.7, centerY: 0.5, baseSize: 340, stagger: 0.15),
      BubbleData(assetPath: 'assets/Ellipse218.svg', centerX: 0.2, centerY: 0.85, baseSize: 250, stagger: 0.1),
      BubbleData(assetPath: 'assets/Ellipse219.svg', centerX: 0.85, centerY: 0.6, baseSize: 270, stagger: 0.14),
      BubbleData(assetPath: 'assets/Ellipse220.svg', centerX: 0.45, centerY: 0.1, baseSize: 230, stagger: 0.04),
      BubbleData(assetPath: 'assets/Ellipse221.svg', centerX: 0.55, centerY: 0.4, baseSize: 290, stagger: 0.18),
    ];
  }
}

class BubbleData {
  const BubbleData({
    required this.assetPath,
    required this.centerX,
    required this.centerY,
    required this.baseSize,
    required this.stagger,
  });

  final String assetPath;
  final double centerX;
  final double centerY;
  final double baseSize;
  final double stagger;
}

class _BubbleBurstLayer extends StatelessWidget {
  const _BubbleBurstLayer({
    required this.progress,
    required this.bubbles,
  });

  final double progress;
  final List<BubbleData> bubbles;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return IgnorePointer(
      child: Stack(
          fit: StackFit.expand,
          children: [
            for (final bubble in bubbles)
              _SingleBubble(
                data: bubble,
                progress: progress,
                screenWidth: size.width,
                screenHeight: size.height,
              ),
          ],
        ),
    );
  }
}

class _SingleBubble extends StatelessWidget {
  const _SingleBubble({
    required this.data,
    required this.progress,
    required this.screenWidth,
    required this.screenHeight,
  });

  final BubbleData data;
  final double progress;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    final local = ((progress - data.stagger) / (1 - data.stagger)).clamp(0.0, 1.0);
    final eased = Curves.easeOutCubic.transform(local);
    final scale = Tween<double>(begin: 0.0, end: 1.4).transform(eased);

    final left = screenWidth * data.centerX - data.baseSize / 2;
    final top = screenHeight * data.centerY - data.baseSize / 2;

    return Positioned(
      left: left,
      top: top,
      child: Transform.scale(
        scale: scale,
        child: SvgPicture.asset(
          data.assetPath,
          width: data.baseSize,
          height: data.baseSize,
        ),
      ),
    );
  }
}
