import 'dart:async';
import 'package:flutter/material.dart';

/// Counts a number up from zero with an easing curve — great for stat rows.
class AnimatedCount extends StatefulWidget {
  final num value;
  final TextStyle? style;
  final Duration duration;
  final Duration delay;
  final String suffix;

  const AnimatedCount({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 1100),
    this.delay = Duration.zero,
    this.suffix = '',
  });

  @override
  State<AnimatedCount> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends State<AnimatedCount> {
  double _end = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _end = widget.value.toDouble();
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) setState(() => _end = widget.value.toDouble());
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _end),
      duration: widget.duration,
      curve: Curves.easeOutExpo,
      builder: (context, v, _) => Text(
        '${v.round()}${widget.suffix}',
        style: widget.style,
      ),
    );
  }
}
