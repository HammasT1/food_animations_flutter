import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/strings.dart';
import '../../core/theme/app_colors.dart';

class AnimatedButtonWidget extends StatelessWidget {
  final Duration buttonDelayDuration;
  final Duration buttonPlayDuration;
  const AnimatedButtonWidget({
    super.key,
    required this.buttonDelayDuration,
    required this.buttonPlayDuration,
  });

  @override
  Widget build(BuildContext context) {
    final settleDelay = buttonDelayDuration + buttonPlayDuration;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: 70,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: AppColors.onBoardingButtonColor,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.onBoardingButtonColor.withValues(alpha: 0.5),
                blurRadius: 28,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedTextWidget(
            buttonPlayDuration: buttonPlayDuration,
            buttonDelayDuration: buttonDelayDuration,
          ),
        )
            // entrance: rocket up from below with an overshoot
            .animate()
            .slideY(
                begin: 2.2,
                end: 0,
                delay: buttonDelayDuration,
                duration: buttonPlayDuration,
                curve: Curves.easeOutBack)
            .fadeIn(delay: buttonDelayDuration, duration: 300.ms)
            // a one-time light sweep as it lands
            .shimmer(
                delay: settleDelay,
                duration: 1100.ms,
                color: Colors.white.withValues(alpha: 0.65))
            // then breathe + glow forever to pull the tap
            .animate(
              delay: settleDelay,
              onPlay: (c) => c.repeat(reverse: true),
            )
            .scaleXY(
                begin: 1,
                end: 1.035,
                duration: 1400.ms,
                curve: Curves.easeInOut)
            .boxShadow(
              begin: BoxShadow(
                color: AppColors.onBoardingButtonColor.withValues(alpha: 0.25),
                blurRadius: 18,
                spreadRadius: 0,
              ),
              end: BoxShadow(
                color: AppColors.onBoardingButtonColor.withValues(alpha: 0.6),
                blurRadius: 36,
                spreadRadius: 4,
              ),
              duration: 1400.ms,
              curve: Curves.easeInOut,
              borderRadius: BorderRadius.circular(50),
            ),
      ],
    );
  }
}

class AnimatedTextWidget extends StatelessWidget {
  final Duration buttonPlayDuration;
  final Duration buttonDelayDuration;
  const AnimatedTextWidget({
    super.key,
    required this.buttonPlayDuration,
    required this.buttonDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        Strings.onBoardingButton,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ).animate().fadeIn(delay: buttonDelayDuration + 250.ms, duration: 300.ms).scaleXY(
        begin: 0.6,
        end: 1,
        delay: buttonDelayDuration + 250.ms,
        duration: buttonPlayDuration,
        curve: Curves.easeOutBack);
  }
}
