import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Animated floating + wiggle mascot widget.
/// Uses the bat mascot image from assets.
class AnimatedMascot extends StatefulWidget {
  const AnimatedMascot({
    super.key,
    this.width = 120,
    this.height = 120,
    this.assetPath = 'assets/Mascot Mascot.png',
    this.isHolding = false,
  });

  final double width;
  final double height;
  final String assetPath;
  final bool isHolding;

  @override
  State<AnimatedMascot> createState() => _AnimatedMascotState();
}

class _AnimatedMascotState extends State<AnimatedMascot>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _wiggleController;
  late final AnimationController _scaleController;

  late final Animation<double> _floatAnim;
  late final Animation<double> _wiggleAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Floating up-down animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Wiggle / tilt animation
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _wiggleAnim = Tween<double>(begin: -0.08, end: 0.08).animate(
      CurvedAnimation(parent: _wiggleController, curve: Curves.easeInOut),
    );

    // Subtle scale pulse
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _wiggleController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatController,
        _wiggleController,
        _scaleController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.isHolding ? 0 : _floatAnim.value),
          child: Transform.rotate(
            angle: widget.isHolding ? _wiggleAnim.value * 0.2 : _wiggleAnim.value,
            alignment: widget.isHolding ? Alignment.bottomCenter : Alignment.center,
            child: Transform.scale(
              scale: widget.isHolding ? 1.0 + (_scaleAnim.value - 1.0) * 0.5 : _scaleAnim.value,
              alignment: widget.isHolding ? Alignment.bottomCenter : Alignment.center,
              child: child,
            ),
          ),
        );
      },
      child: widget.assetPath.endsWith('.svg')
          ? SvgPicture.asset(
              widget.assetPath,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.contain,
            )
          : Image.asset(
              widget.assetPath,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.contain,
            ),
    );
  }
}

/// Wing-flap mascot variant — alternates between two frames using opacity.
class AnimatedMascotWingFlap extends StatefulWidget {
  const AnimatedMascotWingFlap({
    super.key,
    this.size = 120,
  });

  final double size;

  @override
  State<AnimatedMascotWingFlap> createState() =>
      _AnimatedMascotWingFlapState();
}

class _AnimatedMascotWingFlapState extends State<AnimatedMascotWingFlap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnim;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotateAnim = Tween<double>(
      begin: -math.pi / 18,
      end: math.pi / 18,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: Transform.rotate(
            angle: _rotateAnim.value,
            child: child,
          ),
        );
      },
      child: Image.asset(
        'assets/Mascot Mascot.png',
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
      ),
    );
  }
}
