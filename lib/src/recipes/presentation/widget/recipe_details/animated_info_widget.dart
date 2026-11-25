// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widget/animated_count.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widget/glass_container.dart';

class AnimatedInfoWidget extends StatelessWidget {
  final Map<String, num> nutrition;
  final Duration infoDelayTime;
  final Duration infoPlayTime;
  final BoxConstraints constraints;
  final Color accent;
  const AnimatedInfoWidget({
    super.key,
    required this.nutrition,
    required this.infoDelayTime,
    required this.infoPlayTime,
    required this.constraints,
    this.accent = const Color(0xffFFECB3),
  });

  @override
  Widget build(BuildContext context) {
    final start = infoDelayTime + 400.ms;
    return GlassContainer(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 0.1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      borderRadius: BorderRadius.circular(20),
      opacity: 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _InfoViewer(
              name: 'Kcal',
              amount: nutrition["calories"]!,
              start: start,
              color: accent),
          _divider(start + 120.ms),
          _InfoViewer(
              name: 'Protein',
              amount: nutrition["protein"]!,
              start: start + 140.ms,
              color: accent),
          _divider(start + 260.ms),
          _InfoViewer(
              name: 'Prep Time',
              amount: nutrition["prepTime"]!,
              start: start + 280.ms,
              color: accent),
        ]
            .animate(interval: 140.ms, delay: start)
            .fadeIn(duration: infoPlayTime, curve: Curves.easeOut)
            .slideY(begin: 0.6, end: 0, curve: Curves.easeOutBack)
            .scaleXY(begin: 0.6, end: 1, curve: Curves.easeOutBack),
      ),
    )
        .animate(delay: infoDelayTime)
        .fadeIn(curve: Curves.easeOut)
        .scaleXY(begin: 0.94, end: 1, curve: Curves.easeOutCubic)
        .shimmer(
            delay: infoDelayTime + 500.ms,
            duration: 1200.ms,
            color: Colors.white.withValues(alpha: 0.18));
  }

  Widget _divider(Duration delay) =>
      Container(width: 1.2, height: 24, color: Colors.white24).animate().scaleY(
          begin: 0,
          end: 1,
          delay: delay,
          duration: 300.ms,
          curve: Curves.easeOut);
}

class _InfoViewer extends StatelessWidget {
  final String name;
  final num amount;
  final Duration start;
  final Color color;
  const _InfoViewer({
    required this.name,
    required this.amount,
    required this.start,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedCount(
          value: amount,
          delay: start,
          duration: 1100.ms,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontFamily: AppFonts.display,
              color: color,
              fontWeight: FontWeight.w400,
              fontSize: 24,
              height: 1.1,
              letterSpacing: 0),
        ),
        Text(name, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
