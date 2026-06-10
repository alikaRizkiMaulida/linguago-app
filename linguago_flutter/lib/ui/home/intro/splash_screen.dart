import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// TODO: Sesuaikan import package di bawah ini dengan struktur project kamu
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/data/datasource/auth_local_datasource.dart';
import 'package:linguago_flutter/ui/home/home_screen.dart';
import 'package:linguago_flutter/ui/home/intro/onboarding_screen.dart';

/// Splash sequence: mascot centered & blinking -> mascot shrinks -> bubble cards burst -> logo centered -> home/onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  static const List<String> _mascotFrames = [
    'assets/Group 106.svg',
    'assets/blink.svg',
  ];

  late final List<BubbleData> _bubbles;
  
  // Menggunakan Scale untuk efek maskot mengecil (menghilang)
  late final AnimationController _mascotScaleController;
  late final Animation<double> _mascotScaleAnimation;
  
  late final AnimationController _bubbleController;
  late final AnimationController _logoController;
  late final Animation<double> _logoFadeAnimation;

  int _mascotFrameIndex = 0;
  bool _showBubbles = false;
  bool _fadeBubbles = false;
  bool _showLogo = false;
  bool _showLogoText = false;

  @override
  void initState() {
    super.initState();
    // Generate layout berbentuk grid untuk menyesuaikan dengan prototype
    _bubbles = _generateBubbleLayout();

    // Animasi maskot mengecil sebelum menghilang
    _mascotScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0, // Mulai dari ukuran penuh
    );

    _mascotScaleAnimation = CurvedAnimation(
      parent: _mascotScaleController,
      curve: Curves.easeInBack, // Efek mengecil dengan sedikit tarikan ke belakang
    );

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoFadeAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    unawaited(_runSequence());
  }

  Future<void> _runSequence() async {
    // 1. Jeda awal maskot di tengah
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    
    // 2. Animasi berkedip (blink loop)
    // Kedip 1: tutup mata
    setState(() => _mascotFrameIndex = 1);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    // Kedip 1: buka mata
    setState(() => _mascotFrameIndex = 0);
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    // Kedip 2: tutup mata
    setState(() => _mascotFrameIndex = 1);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    // Kedip 2: buka mata
    setState(() => _mascotFrameIndex = 0);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // 3. Maskot mengecil (shrink to 0) dan gelembung bersiap
    setState(() {
      _showBubbles = true;
    });
    
    _mascotScaleController.reverse(); // Menjalankan animasi mengecil (1.0 -> 0.0)
    await Future<void>.delayed(const Duration(milliseconds: 200)); // Overlap sedikit
    
    // 4. Gelembung/Cards muncul (Burst)
    if (!mounted) return;
    await _bubbleController.forward();
    
    // Mulai memudarkan gelembung
    if (!mounted) return;
    setState(() {
      _fadeBubbles = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Sembunyikan gelembung sepenuhnya
    if (!mounted) return;
    setState(() {
      _showBubbles = false;
    });
    
    // 5. Tampilkan logo tile
    setState(() {
      _showLogo = true;
    });
    
    // Animasi logo muncul
    await _logoController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // 6. Tampilkan tulisan Linguago bergeser
    if (!mounted) return;
    setState(() {
      _showLogoText = true;
    });
    
    // Tahan layar sejenak untuk membiarkan user melihat logo lengkap
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    
    // 7. Cek status login & Navigasi halaman
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
    _mascotScaleController.dispose();
    _bubbleController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft, 
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- 1. BUBBLES / CARDS BURST LAYER ---
          if (_showBubbles)
            AnimatedOpacity(
              opacity: _fadeBubbles ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: AnimatedBuilder(
                animation: _bubbleController,
                builder: (context, _) => _BubbleBurstLayer(
                  progress: _bubbleController.value,
                  bubbles: _bubbles,
                ),
              ),
            ),
          
          // --- 2. CENTERED & SHRINKING MASCOT ---
          Center(
            child: ScaleTransition(
              scale: _mascotScaleAnimation,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: SvgPicture.asset(
                  _mascotFrames[_mascotFrameIndex],
                  key: ValueKey<int>(_mascotFrameIndex),
                  width: 270,
                ),
              ),
            ),
          ),
          
          // --- 3. CENTERING LOGO ---
          FadeTransition(
            opacity: _logoFadeAnimation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                CurvedAnimation(
                  parent: _logoController,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: IgnorePointer(
                ignoring: !_showLogo,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeInOutCubic,
                    width: _showLogoText ? 213 : 53, // Efek melebar memunculkan text
                    height: 53,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(
                          'assets/logo.svg',
                          height: 53,
                          width: 213,
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mengubah layout agar mirip dengan grid layout di Figma
  List<BubbleData> _generateBubbleLayout() {
    return const [
      // Top Row
      BubbleData(assetPath: 'assets/Frame 1000002826.svg', centerX: 0.2, centerY: 0.2, baseSize: 110, stagger: 0.0),
      BubbleData(assetPath: 'assets/Frame 1000002826-1.svg', centerX: 0.5, centerY: 0.15, baseSize: 130, stagger: 0.05),
      BubbleData(assetPath: 'assets/Frame 1000002826-2.svg', centerX: 0.8, centerY: 0.2, baseSize: 100, stagger: 0.02),
      
      // Middle Row
      BubbleData(assetPath: 'assets/Frame 1000002826-3.svg', centerX: 0.15, centerY: 0.5, baseSize: 90, stagger: 0.08),
      BubbleData(assetPath: 'assets/Frame 1000002826.svg', centerX: 0.85, centerY: 0.5, baseSize: 120, stagger: 0.12),
      
      // Bottom Row
      BubbleData(assetPath: 'assets/Frame 1000002826-1.svg', centerX: 0.2, centerY: 0.8, baseSize: 110, stagger: 0.06),
      BubbleData(assetPath: 'assets/Frame 1000002826-2.svg', centerX: 0.5, centerY: 0.85, baseSize: 140, stagger: 0.15),
      BubbleData(assetPath: 'assets/Frame 1000002826-3.svg', centerX: 0.8, centerY: 0.8, baseSize: 105, stagger: 0.1),
    ];
  }
}

// ... Kelas BubbleData, _BubbleBurstLayer, dan _SingleBubble tetap sama ...
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
    final eased = Curves.easeOutBack.transform(local); // Menggunakan easeOutBack agar terkesan "pop"
    final scale = Tween<double>(begin: 0.0, end: 1.2).transform(eased);

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