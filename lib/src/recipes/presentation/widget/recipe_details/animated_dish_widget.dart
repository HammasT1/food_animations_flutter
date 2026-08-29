// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widget/glow_backdrop.dart';
import '../../../../core/widget/rising_particles.dart';

class AnimatedDishWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final String imageUrl;
  final Duration dishPlayTime;
  final String heroTag;
  const AnimatedDishWidget({
    super.key,
    required this.constraints,
    required this.imageUrl,
    required this.dishPlayTime,
    this.heroTag = '',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: constraints.maxHeight * 0.31,
      width: constraints.maxWidth * 0.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const GlowBackdrop(size: 300, maxOpacity: 0.4, delay: Duration(milliseconds: 300)),
          const Positioned.fill(
            child: RisingParticles(count: 10, maxRadius: 26),
          ),
          Hero(
            tag: heroTag.isEmpty ? 'dish-$imageUrl' : heroTag,
            flightShuttleBuilder: (_, __, ___, ____, toHeroContext) =>
                toHeroContext.widget,
            child: Image.asset(imageUrl, fit: BoxFit.contain)
                // arrives via Hero, then settles with a spin + light sweep
                .animate()
                .rotate(
                    begin: -0.12,
                    end: 0,
                    duration: dishPlayTime,
                    curve: Curves.easeOutBack)
                .scaleXY(
                    begin: 0.86,
                    end: 1,
                    duration: dishPlayTime,
                    curve: Curves.easeOutBack)
                .shimmer(
                    delay: dishPlayTime,
                    duration: 1000.ms,
                    color: Colors.white.withValues(alpha: 0.5))
                // slow rotisserie spin + hover, forever
                .animate(
                  delay: dishPlayTime + 200.ms,
                  onPlay: (c) => c.repeat(reverse: true),
                )
                .moveY(
                    begin: -6,
                    end: 10,
                    duration: 3.seconds,
                    curve: Curves.easeInOut)
                .rotate(
                    begin: -0.012,
                    end: 0.012,
                    duration: 3.seconds,
                    curve: Curves.easeInOut),
          ),
        ],
      ),
    );
  }
}
