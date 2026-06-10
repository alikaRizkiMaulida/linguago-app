import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MascotPose { teaching, listening, success, fail, confused, reading, sleep }

class MascotWidget extends StatefulWidget {
  final MascotPose pose;
  final double size;

  const MascotWidget({
    super.key,
    required this.pose,
    this.size = 150,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget> with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  String get _assetPath {
    switch (widget.pose) {
      case MascotPose.teaching:
        return 'assets/ngajarkacamata.svg';
      case MascotPose.listening:
        return 'assets/Group 36726.svg';
      case MascotPose.success:
        return 'assets/Group 36730.svg';
      case MascotPose.fail:
        return 'assets/Group 36727.svg';
      case MascotPose.confused:
        return 'assets/tandatanyaberfikir.svg';
      case MascotPose.reading:
        return 'assets/Group 36740.svg';
      case MascotPose.sleep:
        return 'assets/sleep.svg';
    }
  }

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatOffset = math.sin(_floatController.value * math.pi) * 6.0;
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: child,
        );
      },
      child: SvgPicture.asset(
        _assetPath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
      ),
    );
  }
}
