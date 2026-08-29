import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A soft radial "spotlight" that blooms in and then breathes forever.
/// Sits behind hero imagery to give the screen depth and a premium feel.
class GlowBackdrop extends StatelessWidget {
  final Color color;
  final double size;
  final Duration delay;
  final double maxOpacity;

  const GlowBackdrop({
    super.key,
    this.color = const Color(0xffFFD54F),
    this.size = 340,
    this.delay = Duration.zero,
    this.maxOpacity = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: maxOpacity),
              color.withValues(alpha: maxOpacity * 0.35),
              color.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
      )
          .animate(delay: delay)
          .fadeIn(duration: 900.ms, curve: Curves.easeOut)
          .scaleXY(
              begin: 0.55,
              end: 1,
              duration: 1200.ms,
              curve: Curves.easeOutBack)
          // hand off to an endless breathing loop
          .animate(
            onPlay: (c) => c.repeat(reverse: true),
          )
          .scaleXY(
              begin: 1,
              end: 1.14,
              duration: 2800.ms,
              curve: Curves.easeInOut)
          .fade(
              begin: 1, end: 0.65, duration: 2800.ms, curve: Curves.easeInOut),
    );
  }
}
