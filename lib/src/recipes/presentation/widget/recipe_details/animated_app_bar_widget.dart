// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedAppBarWidget extends StatelessWidget {
  final String name;
  final Duration appBarPlayTime;
  final Duration appBarDelayTime;

  /// Extra action after the favourite button (e.g. the cart).
  final Widget? trailing;
  const AnimatedAppBarWidget({
    super.key,
    required this.name,
    required this.appBarPlayTime,
    required this.appBarDelayTime,
    this.trailing,
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
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: trailing == null ? 12 : 8, top: 6),
          child:
              GlassIconButton(onPressed: () {}, icon: Icons.favorite_outline),
        ),
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 6),
            child: trailing,
          ),
      ]
          .animate(interval: 120.ms, delay: appBarDelayTime)
          .fadeIn(duration: appBarPlayTime, curve: Curves.easeOut)
          .slideY(begin: -0.9, end: 0, curve: Curves.easeOutBack)
          .scaleXY(begin: 0.6, end: 1, curve: Curves.easeOutBack),
    );
  }
}
