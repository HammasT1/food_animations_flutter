// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedAppBarWidget extends StatelessWidget {
  final String name;
  final Duration appBarPlayTime;
  final Duration appBarDelayTime;
  const AnimatedAppBarWidget({
    super.key,
    required this.name,
    required this.appBarPlayTime,
    required this.appBarDelayTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 6),
          child: GlassIconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.arrow_back_ios_new),
        ),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, top: 6),
          child:
              GlassIconButton(onPressed: () {}, icon: Icons.favorite_outline),
        ),
      ]
          .animate(interval: 120.ms, delay: appBarDelayTime)
          .fadeIn(duration: appBarPlayTime, curve: Curves.easeOut)
          .slideY(begin: -0.9, end: 0, curve: Curves.easeOutBack)
          .scaleXY(begin: 0.6, end: 1, curve: Curves.easeOutBack),
    );
  }
}
