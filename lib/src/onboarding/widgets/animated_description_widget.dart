import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/strings.dart';

class AnimatedDescriptionWidget extends StatelessWidget {
  final Duration descriptionPlayDuration;
  final Duration descriptionDelayDuration;
  const AnimatedDescriptionWidget({
    super.key,
    required this.descriptionPlayDuration,
    required this.descriptionDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        Strings.onBoardingSlogan,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      )
          .animate()
          .fadeIn(
              delay: descriptionDelayDuration,
              duration: descriptionPlayDuration,
              curve: Curves.easeOut)
          .blurXY(begin: 6, end: 0)
          .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic)
          .scaleXY(begin: 0.92, end: 1, curve: Curves.easeOutBack),
    );
  }
}
