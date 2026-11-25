import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Soft, slowly drifting orbs of coloured light behind the whole screen.
/// Gives glass surfaces something to refract so they read as frosted glass
/// rather than flat grey cards.
class AmbientBackground extends StatelessWidget {
  /// Colour of the lead orb — e.g. the accent of the dish on screen.
  final Color accent;
  const AmbientBackground({super.key, this.accent = const Color(0xffFFC107)});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          _Orb(
            alignment: const Alignment(-1.3, -1.05),
            color: accent,
            size: 380,
            drift: const Offset(40, 30),
            period: const Duration(seconds: 9),
          ),
          const _Orb(
            alignment: Alignment(1.45, -0.05),
            color: Color(0xffFF7043),
            size: 340,
            drift: Offset(-30, 50),
            period: Duration(seconds: 11),
          ),
          const _Orb(
            alignment: Alignment(-0.9, 1.3),
            color: Color(0xff7C4DFF),
            size: 420,
            drift: Offset(50, -35),
            period: Duration(seconds: 13),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 1200.ms, curve: Curves.easeOut);
  }
}

class _Orb extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final double size;
  final Offset drift;
  final Duration period;

  const _Orb({
    required this.alignment,
    required this.color,
    required this.size,
    required this.drift,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: RepaintBoundary(
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: color),
          duration: const Duration(milliseconds: 900),
          builder: (context, c, _) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  c!.withValues(alpha: 0.30),
                  c.withValues(alpha: 0.10),
                  c.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .move(
                begin: Offset.zero,
                end: drift,
                duration: period,
                curve: Curves.easeInOutSine)
            .scaleXY(
                begin: 1,
                end: 1.12,
                duration: period,
                curve: Curves.easeInOutSine),
      ),
    );
  }
}
