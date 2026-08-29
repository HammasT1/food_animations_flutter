import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/assets.dart';
import '../../core/widget/glow_backdrop.dart';
import '../../core/widget/rising_particles.dart';

class AnimatedDishWidget extends StatelessWidget {
  final Duration dishPlayDuration;
  final Duration leavesDelayDuration;
  const AnimatedDishWidget({
    super.key,
    required this.dishPlayDuration,
    required this.leavesDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ---- ambient light bloom behind everything ----
        const Align(
          alignment: Alignment(0, -0.1),
          child: GlowBackdrop(size: 360, maxOpacity: 0.5),
        ),

        // ---- soft steam drifting up off the plate ----
        const Align(
          alignment: Alignment(0, 0.15),
          child: SizedBox(
            width: 240,
            height: 320,
            child: RisingParticles(count: 12, maxRadius: 30),
          ),
        )
            .animate()
            .fadeIn(delay: 900.ms, duration: 1200.ms),

        // ---- top-left leaves: fly in, spin to rest, then sway forever ----
        _Garnish(
          left: 24,
          top: 6,
          asset: Assets.leaves,
          height: 200,
          restAngle: 2 * pi * 0.85,
          spinFrom: 2 * pi * 0.85 - 0.9,
          slideFrom: const Offset(0.8, -0.5),
          delay: leavesDelayDuration,
          play: dishPlayDuration,
          swayHz: 0.18,
        ),

        // ---- black pepper: shoots in from the right and shakes ----
        Positioned(
          right: -90,
          top: 26,
          child: Image.asset(Assets.blackPepper, height: 150)
              .animate()
              .slide(
                  begin: const Offset(1.2, -0.5),
                  end: Offset.zero,
                  delay: leavesDelayDuration - 200.ms,
                  duration: dishPlayDuration - 250.ms,
                  curve: Curves.easeOutBack)
              .scaleXY(begin: 0.4, end: 1, curve: Curves.easeOutBack)
              .fadeIn()
              .shake(
                  delay: leavesDelayDuration + dishPlayDuration - 350.ms,
                  hz: 6,
                  offset: const Offset(2, 0),
                  rotation: 0.02)
              .animate(
                delay: leavesDelayDuration + dishPlayDuration,
                onPlay: (c) => c.repeat(reverse: true),
              )
              .rotate(
                  begin: -0.015, end: 0.015, duration: 3.seconds, curve: Curves.easeInOut),
        ),

        // ---- bottom-left leaves ----
        _Garnish(
          left: -34,
          bottom: -18,
          asset: Assets.leaves,
          height: 150,
          restAngle: 2 * pi * 0.85,
          spinFrom: 2 * pi * 0.85 + 0.8,
          slideFrom: const Offset(-0.6, 0.9),
          delay: leavesDelayDuration + 80.ms,
          play: dishPlayDuration,
          swayHz: 0.22,
        ),

        // ---- right leaves ----
        _Garnish(
          right: 0,
          top: 0,
          asset: Assets.leaves,
          height: 150,
          restAngle: 2 * pi * 0.45,
          spinFrom: 2 * pi * 0.45 - 0.7,
          slideFrom: const Offset(0.7, 0.9),
          delay: leavesDelayDuration + 40.ms,
          play: dishPlayDuration,
          swayHz: 0.2,
        ),

        // ---- the dish: elastic pop + spin-in, light sweep, endless hover ----
        Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            Assets.dish,
            fit: BoxFit.contain,
            height: 340,
          )
              .animate()
              .scale(
                  begin: const Offset(0.1, 0.1),
                  end: const Offset(1, 1),
                  duration: dishPlayDuration,
                  curve: Curves.elasticOut)
              .rotate(
                  begin: -0.5,
                  end: 0,
                  duration: dishPlayDuration,
                  curve: Curves.easeOutCubic)
              .fadeIn(duration: 350.ms)
              .shimmer(
                  delay: dishPlayDuration - 150.ms,
                  duration: 900.ms,
                  color: Colors.white.withValues(alpha: 0.55))
              .animate(
                delay: dishPlayDuration + 150.ms,
                onPlay: (c) => c.repeat(reverse: true),
              )
              .moveY(
                  begin: 0, end: -14, duration: 2600.ms, curve: Curves.easeInOut)
              .rotate(
                  begin: -0.006,
                  end: 0.006,
                  duration: 2600.ms,
                  curve: Curves.easeInOut),
        ),
      ],
    );
  }
}

/// A garnish image that slides + spins into a resting angle, then sways gently.
class _Garnish extends StatelessWidget {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final String asset;
  final double height;
  final double restAngle;
  final double spinFrom;
  final Offset slideFrom;
  final Duration delay;
  final Duration play;
  final double swayHz;

  const _Garnish({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.asset,
    required this.height,
    required this.restAngle,
    required this.spinFrom,
    required this.slideFrom,
    required this.delay,
    required this.play,
    required this.swayHz,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Transform.rotate(
        angle: restAngle,
        child: Image.asset(asset, height: height),
      )
          .animate()
          .slide(
              begin: slideFrom,
              end: Offset.zero,
              delay: delay,
              duration: play,
              curve: Curves.easeOutCubic)
          .scaleXY(
              begin: 0,
              end: 1,
              delay: delay,
              duration: play,
              curve: Curves.easeOutBack)
          .fadeIn(delay: delay, duration: 400.ms)
          .animate(
            delay: delay + play,
            onPlay: (c) => c.repeat(reverse: true),
          )
          .rotate(
              begin: -0.02,
              end: 0.02,
              duration: (1000 / swayHz).ms,
              curve: Curves.easeInOut),
    );
  }
}
