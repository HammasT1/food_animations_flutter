import 'package:flutter/material.dart';

/// Smoothly tweens a currency value whenever it changes — the digits visibly
/// "roll" from the old amount to the new one.
class AnimatedPrice extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final Duration duration;
  final String symbol;

  const AnimatedPrice({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 550),
    this.symbol = '\$',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(
        '$symbol${v.toStringAsFixed(2)}',
        style: style,
      ),
    );
  }
}
