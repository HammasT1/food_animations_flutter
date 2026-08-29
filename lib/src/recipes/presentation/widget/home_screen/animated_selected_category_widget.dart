// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedSelectedCategoryWidget extends StatelessWidget {
  final Duration selectedCategoryPlayDuration;
  final Duration selectedCategoryDelayDuration;
  const AnimatedSelectedCategoryWidget({
    super.key,
    required this.selectedCategoryPlayDuration,
    required this.selectedCategoryDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        "10 Recipes",
        style: Theme.of(context).textTheme.titleLarge,
      )
          .animate()
          .fadeIn(
              delay: selectedCategoryDelayDuration,
              duration: selectedCategoryPlayDuration,
              curve: Curves.easeOut)
          .slideX(begin: 0.3, end: 0, curve: Curves.easeOutBack)
          .scaleXY(begin: 0.8, end: 1, curve: Curves.easeOutBack)
          .blurX(begin: 8, end: 0)
          .shimmer(
              delay: selectedCategoryDelayDuration + 300.ms,
              duration: 900.ms,
              color: Colors.amberAccent.withValues(alpha: 0.6)),
    );
  }
}
