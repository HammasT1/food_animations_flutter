// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widget/animated_count.dart';

class AnimatedInfoWidget extends StatelessWidget {
  final Map<String, num> nutrition;
  final Duration infoDelayTime;
  final Duration infoPlayTime;
  final BoxConstraints constraints;
  const AnimatedInfoWidget({
    super.key,
    required this.nutrition,
    required this.infoDelayTime,
    required this.infoPlayTime,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final start = infoDelayTime + 400.ms;
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 0.1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white30, width: 1.3),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _InfoViewer(
              name: 'Kcal', amount: nutrition["calories"]!, start: start),
          _divider(start + 120.ms),
          _InfoViewer(
              name: 'Protein',
              amount: nutrition["protein"]!,
              start: start + 140.ms),
          _divider(start + 260.ms),
          _InfoViewer(
              name: 'Prep Time',
              amount: nutrition["prepTime"]!,
              start: start + 280.ms),
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

  Widget _divider(Duration delay) => Container(width: 1.2, height: 24, color: Colors.white24)
      .animate()
      .scaleY(begin: 0, end: 1, delay: delay, duration: 300.ms, curve: Curves.easeOut);
}

class _InfoViewer extends StatelessWidget {
  final String name;
  final num amount;
  final Duration start;
  const _InfoViewer({
    required this.name,
    required this.amount,
    required this.start,
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
          style:
              Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 18),
        ),
        Text(name, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
