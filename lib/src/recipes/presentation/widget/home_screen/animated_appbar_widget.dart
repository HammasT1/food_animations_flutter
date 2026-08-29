import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/assets.dart';
import 'animated_name_widget.dart';

class AnimatedAppBarWidget extends StatelessWidget {
  final Duration avatarWaitingDuration;
  final Duration avatarPlayDuration;
  final Duration nameDelayDuration;
  final Duration namePlayDuration;

  const AnimatedAppBarWidget({
    super.key,
    required this.avatarWaitingDuration,
    required this.avatarPlayDuration,
    required this.nameDelayDuration,
    required this.namePlayDuration,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSettle = avatarPlayDuration + avatarWaitingDuration + 300.ms;
    return Row(
      children: [
        const SizedBox(width: 20),
        AnimatedNameWidget(
          namePlayDuration: namePlayDuration,
          nameDelayDuration: nameDelayDuration,
        ),
        Expanded(child: Container()),
        Stack(
          alignment: Alignment.center,
          children: [
            // pulsing halo behind the avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Colors.amberAccent.withValues(alpha: 0.6),
                  Colors.amberAccent.withValues(alpha: 0),
                ]),
              ),
            )
                .animate(
                  delay: avatarSettle,
                  onPlay: (c) => c.repeat(reverse: true),
                )
                .scaleXY(
                    begin: 0.8,
                    end: 1.5,
                    duration: 1600.ms,
                    curve: Curves.easeInOut)
                .fade(begin: 0.7, end: 0.15, duration: 1600.ms),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
                image: const DecorationImage(
                  image: AssetImage(Assets.profileImage),
                  fit: BoxFit.cover,
                  alignment: Alignment(0, -0.72), // frame the face, not the torso
                ),
              ),
            )
                .animate()
                .scaleXY(
                    begin: 0,
                    end: 2,
                    duration: avatarPlayDuration,
                    curve: Curves.easeInOutSine)
                .then(delay: avatarWaitingDuration)
                .scaleXY(begin: 3, end: 1, curve: Curves.easeOutBack)
                .slide(begin: const Offset(-4, 6), end: Offset.zero)
                .shimmer(
                    delay: avatarSettle,
                    duration: 1000.ms,
                    color: Colors.white.withValues(alpha: 0.6)),
          ],
        ),
        const SizedBox(width: 25)
      ],
    );
  }
}
