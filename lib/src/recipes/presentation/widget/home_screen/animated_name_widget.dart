import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedNameWidget extends StatelessWidget {
  final Duration namePlayDuration;
  final Duration nameDelayDuration;
  const AnimatedNameWidget({
    super.key,
    required this.namePlayDuration,
    required this.nameDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Hello,", style: style)
            .animate()
            .fadeIn(delay: nameDelayDuration, duration: 400.ms)
            .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
            .blurX(begin: 8, end: 0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Fellas ", style: style)
                .animate()
                .fadeIn(delay: nameDelayDuration + 120.ms, duration: 400.ms)
                .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
                .blurX(begin: 8, end: 0),
            const Text("👋")
                .animate(
                  delay: nameDelayDuration + 350.ms,
                )
                .fadeIn(duration: 300.ms)
                .scaleXY(begin: 0, end: 1, curve: Curves.easeOutBack)
                .then()
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .rotate(
                    begin: -0.08,
                    end: 0.08,
                    duration: 500.ms,
                    curve: Curves.easeInOut),
          ],
        ),
      ],
    );
  }
}
