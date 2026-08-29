// ignore_for_file: public_member_api_docs, sort_constructors_first
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
        IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 25)),
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
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline, size: 25)),
      ]
          .animate(interval: 120.ms, delay: appBarDelayTime)
          .fadeIn(duration: appBarPlayTime, curve: Curves.easeOut)
          .slideY(begin: -0.9, end: 0, curve: Curves.easeOutBack)
          .scaleXY(begin: 0.6, end: 1, curve: Curves.easeOutBack),
    );
  }
}
