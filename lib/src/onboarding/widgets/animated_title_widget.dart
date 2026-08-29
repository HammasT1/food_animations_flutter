import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/strings.dart';
import '../../core/theme/app_colors.dart';

class AnimatedTitleWidget extends StatelessWidget {
  final Duration titleDelayDuration;
  final Duration mainPlayDuration;

  const AnimatedTitleWidget({
    super.key,
    required this.titleDelayDuration,
    required this.mainPlayDuration,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.displaySmall;
    final words = Strings.onBoardingTitle.trim().split(' ');

    // Each word rises + unblurs on its own beat for a kinetic headline.
    Widget wordChip(String text, int i, {Color? color}) {
      return Text(text, style: baseStyle?.copyWith(color: color))
          .animate()
          .fadeIn(
              delay: titleDelayDuration + (90 * i).ms,
              duration: 420.ms,
              curve: Curves.easeOut)
          .slideY(begin: 0.6, end: 0, curve: Curves.easeOutCubic)
          .blurX(begin: 8, end: 0)
          .scaleXY(begin: 0.85, end: 1, curve: Curves.easeOutBack);
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 2,
          children: [
            for (var i = 0; i < words.length; i++) wordChip(words[i], i),
            wordChip('everyday', words.length, color: AppColors.timeLineColor),
          ],
        ),
      ),
    )
        .animate()
        .slideY(
            begin: -0.15,
            end: 0,
            delay: titleDelayDuration,
            duration: mainPlayDuration,
            curve: Curves.easeOutCubic);
  }
}
